#!/usr/bin/env bash
#
# SPM / GitHub connectivity doctor for Xcode and Swift Package Manager.
#
# Why this script exists:
#   Xcode/SPM dependencies are fetched through Git. In some networks, github.com
#   can resolve and ping successfully, but HTTPS Git traffic is reset. If a local
#   VPN/proxy is working but Git is not configured to use it, Xcode Add Package
#   and SwiftPM package resolution can still fail.
#
# Common symptoms:
#   - Xcode Add Package cannot find a GitHub package.
#   - `swift package resolve` hangs or fails while fetching GitHub dependencies.
#   - `git ls-remote https://github.com/...` fails with:
#       Recv failure: Connection reset by peer
#   - `ping github.com` works, but HTTPS/Git access does not.
#
# Normal workflow:
#   1. Turn on VPN/proxy.
#   2. Run:
#        scripts/spm_github_doctor.sh
#   3. If it says Git proxy is not aligned, run:
#        scripts/spm_github_doctor.sh --fix-git-proxy
#   4. If Xcode package resolution is stuck, quit Xcode first, then run:
#        scripts/spm_github_doctor.sh --kill-stale-xcode-git
#   5. Reopen Xcode and resolve packages again.
#
# Remove Git proxy later:
#   scripts/spm_github_doctor.sh --unset-git-proxy
#
# Safety:
#   The default mode only checks connectivity. Mutating actions require explicit
#   flags: --fix-git-proxy, --unset-git-proxy, or --kill-stale-xcode-git.
#
set -u

usage() {
  cat <<'EOF'
Usage:
  scripts/spm_github_doctor.sh [--check] [--fix-git-proxy] [--unset-git-proxy] [--kill-stale-xcode-git]

What it does:
  --check              Diagnose GitHub/SPM connectivity. This is the default.
  --fix-git-proxy      Read macOS system HTTPS proxy and write it to global Git config.
  --unset-git-proxy    Remove global Git http.proxy / https.proxy / http.curloptResolve.
  --kill-stale-xcode-git
                       Kill stuck Xcode git clone/fetch processes for SourcePackages.

Typical flow:
  # 1. Check current network/proxy/Git state.
  scripts/spm_github_doctor.sh

  # 2. If proxy works but Git does not, align Git with the current macOS proxy.
  scripts/spm_github_doctor.sh --fix-git-proxy

  # 3. Check again. Git HTTPS should be OK.
  scripts/spm_github_doctor.sh

  # 4. If Xcode package resolution is stuck, quit Xcode first, then run:
  scripts/spm_github_doctor.sh --kill-stale-xcode-git

  # 5. If you no longer need proxy for Git:
  scripts/spm_github_doctor.sh --unset-git-proxy

How to read the output:
  Direct HTTPS: FAILED + Proxy HTTPS: OK
    The network cannot reach GitHub directly, but the proxy can.

  Git HTTPS: FAILED + Git via proxy: OK
    Git is not using the working proxy. Run --fix-git-proxy.

  Stale Xcode Git Processes shows PIDs
    Xcode may have an interrupted package clone/fetch. Quit Xcode, then run
    --kill-stale-xcode-git.

Notes:
  Xcode/SwiftPM may keep stale SourcePackages state after an interrupted resolve.
  If Xcode behaves strangely, quit Xcode, run this script, then open Xcode again.
EOF
}

has_arg() {
  local wanted="$1"
  shift
  for arg in "$@"; do
    [[ "$arg" == "$wanted" ]] && return 0
  done
  return 1
}

section() {
  printf '\n== %s ==\n' "$1"
}

run() {
  printf '+ %s\n' "$*"
  "$@"
}

git_get() {
  git config --global --get "$1" 2>/dev/null || true
}

system_https_proxy_url() {
  local proxy port enabled
  enabled="$(scutil --proxy 2>/dev/null | awk '/HTTPSEnable/ {print $3; exit}')"
  proxy="$(scutil --proxy 2>/dev/null | awk '/HTTPSProxy/ {print $3; exit}')"
  port="$(scutil --proxy 2>/dev/null | awk '/HTTPSPort/ {print $3; exit}')"

  if [[ "$enabled" == "1" && -n "$proxy" && -n "$port" ]]; then
    printf 'http://%s:%s\n' "$proxy" "$port"
  fi
}

env_proxy_url() {
  local value
  value="${HTTPS_PROXY:-${https_proxy:-${HTTP_PROXY:-${http_proxy:-}}}}"
  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  fi
}

preferred_proxy_url() {
  local proxy_url
  proxy_url="$(system_https_proxy_url)"
  if [[ -z "$proxy_url" ]]; then
    proxy_url="$(env_proxy_url)"
  fi
  printf '%s\n' "$proxy_url"
}

list_stale_xcode_git() {
  ps -axo pid,ppid,stat,etime,command 2>/dev/null \
    | grep -E 'Xcode.app/.*/git|SourcePackages|SnapKit|git-remote-https' \
    | grep -v grep || true
}

check_connectivity() {
  local proxy_url
  proxy_url="$(preferred_proxy_url)"

  section "System Proxy"
  scutil --proxy 2>/dev/null || true

  section "Environment Proxy"
  env | grep -Ei '^(all|http|https|no)_proxy=' || {
    echo "No proxy environment variables."
  }

  section "Git Proxy Config"
  git config --global --get-regexp '^(http|https)\..*proxy|http\.curloptResolve' 2>/dev/null || {
    echo "No global Git proxy/curloptResolve config."
  }

  section "GitHub DNS"
  dscacheutil -q host -a name github.com 2>/dev/null || true
  dscacheutil -q host -a name api.github.com 2>/dev/null || true
  dscacheutil -q host -a name codeload.github.com 2>/dev/null || true

  section "Direct HTTPS Test"
  if env -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY -u http_proxy -u https_proxy -u all_proxy \
      curl -I -L --connect-timeout 8 https://github.com >/tmp/spm_github_direct.out 2>&1; then
    echo "Direct HTTPS: OK"
  else
    echo "Direct HTTPS: FAILED"
    tail -20 /tmp/spm_github_direct.out
  fi

  if [[ -n "$proxy_url" ]]; then
    section "Proxy HTTPS Test"
    if curl -I -L --connect-timeout 8 -x "$proxy_url" https://github.com >/tmp/spm_github_proxy.out 2>&1; then
      echo "Proxy HTTPS via $proxy_url: OK"
    else
      echo "Proxy HTTPS via $proxy_url: FAILED"
      tail -20 /tmp/spm_github_proxy.out
    fi
  else
    section "Proxy HTTPS Test"
    echo "No enabled macOS HTTPS proxy found."
  fi

  section "Git Test"
  if env -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY -u http_proxy -u https_proxy -u all_proxy \
      git ls-remote https://github.com/SnapKit/SnapKit.git HEAD >/tmp/spm_github_git.out 2>&1; then
    echo "Git HTTPS: OK"
    cat /tmp/spm_github_git.out
  else
    echo "Git HTTPS: FAILED"
    tail -20 /tmp/spm_github_git.out
  fi

  if [[ -n "$proxy_url" ]]; then
    section "Git Via System Proxy Test"
    if git -c "http.proxy=$proxy_url" -c "https.proxy=$proxy_url" ls-remote https://github.com/SnapKit/SnapKit.git HEAD >/tmp/spm_github_git_proxy.out 2>&1; then
      echo "Git via $proxy_url: OK"
      cat /tmp/spm_github_git_proxy.out
    else
      echo "Git via $proxy_url: FAILED"
      tail -20 /tmp/spm_github_git_proxy.out
    fi
  fi

  section "Stale Xcode Git Processes"
  local stale
  stale="$(list_stale_xcode_git)"
  if [[ -n "$stale" ]]; then
    echo "$stale"
    echo
    echo "If package resolve is stuck, quit Xcode first, then run:"
    echo "  scripts/spm_github_doctor.sh --kill-stale-xcode-git"
  else
    echo "No obvious stale Xcode Git processes."
  fi

  section "Recommendation"
  if [[ -n "$proxy_url" ]]; then
    local git_http git_https
    git_http="$(git_get http.proxy)"
    git_https="$(git_get https.proxy)"
    if [[ "$git_http" != "$proxy_url" || "$git_https" != "$proxy_url" ]]; then
      echo "macOS proxy is enabled, but global Git proxy is not aligned."
      echo "Run:"
      echo "  scripts/spm_github_doctor.sh --fix-git-proxy"
    else
      echo "Global Git proxy matches macOS HTTPS proxy."
    fi
  else
    echo "No macOS HTTPS proxy detected. If GitHub direct access fails, enable VPN/proxy first."
  fi
}

fix_git_proxy() {
  local proxy_url
  proxy_url="$(preferred_proxy_url)"
  if [[ -z "$proxy_url" ]]; then
    echo "No macOS HTTPS proxy or proxy environment variable found. Turn on VPN/proxy first."
    exit 1
  fi

  run git config --global http.proxy "$proxy_url"
  run git config --global https.proxy "$proxy_url"
  echo "Git global proxy set to $proxy_url"
}

unset_git_proxy() {
  git config --global --unset-all http.proxy 2>/dev/null || true
  git config --global --unset-all https.proxy 2>/dev/null || true
  git config --global --unset-all http.curloptResolve 2>/dev/null || true
  echo "Removed global Git http.proxy, https.proxy, and http.curloptResolve if present."
}

kill_stale_xcode_git() {
  local pids
  pids="$(list_stale_xcode_git | awk '{print $1}' | tr '\n' ' ')"
  if [[ -z "${pids// /}" ]]; then
    echo "No stale Xcode Git processes found."
    return 0
  fi
  echo "Killing stale Xcode Git processes: $pids"
  kill $pids 2>/dev/null || true
}

main() {
  if has_arg "--help" "$@"; then
    usage
    exit 0
  fi

  if has_arg "--fix-git-proxy" "$@"; then
    fix_git_proxy
  fi

  if has_arg "--unset-git-proxy" "$@"; then
    unset_git_proxy
  fi

  if has_arg "--kill-stale-xcode-git" "$@"; then
    kill_stale_xcode_git
  fi

  if [[ "$#" -eq 0 ]] || has_arg "--check" "$@"; then
    check_connectivity
  fi
}

main "$@"
