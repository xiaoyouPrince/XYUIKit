# AI 协作复盘与人工把关建议

## 背景

本项目在使用 AI 协助优化 `YYUIKit` 的过程中，暴露出一个典型问题：AI 在处理内部安全改造时，可能为了修复一个局部风险，顺手改动了公开 API 的类型或行为，从而引入新的兼容性风险。

这类问题不一定会被当前项目的测试立刻发现，因为测试通常覆盖的是本仓库内部调用，而三方库真正的风险往往出现在外部使用者的源码编译、历史调用方式和二进制兼容预期上。

## 本次事件经过

优化目标是降低 UI 工具类在无可见控制器场景下的崩溃风险。原有代码中存在类似下面的调用方式：

```swift
UIViewController.currentVisibleVC.present(...)
```

其中 `currentVisibleVC` 是一个隐式解包可选值：

```swift
static var currentVisibleVC: UIViewController!
```

当 App 没有 keyWindow、没有 rootViewController，或者处在特殊窗口场景时，这类调用可能拿不到可见控制器，继续调用 `.present` 就会触发运行时崩溃。

AI 的初始改法是：把底层查找函数改成返回 `UIViewController?`，然后在 `XYAlert` 内部使用 `guard let` 安全判断，找不到 presenter 时返回 `false`。

这个方向本身是对的，但初始改动里存在一个问题：公开函数 `currentVisibleController()` 的返回值从：

```swift
public func currentVisibleController() -> UIViewController!
```

变成了：

```swift
public func currentVisibleController() -> UIViewController?
```

这会影响外部调用方。比如外部项目中如果已有：

```swift
let vc: UIViewController = currentVisibleController()
```

旧版本可以编译，新版本会因为返回值变成 optional 而需要调用方改代码。这对一个三方库来说属于破坏性变更。

## 最终修正

最终采用的修正策略是：公开旧 API 不变，新增安全 API，内部逐步迁移。

保留旧 API：

```swift
public func currentVisibleController() -> UIViewController!

public extension UIViewController {
    static var currentVisibleVC: UIViewController!
}
```

新增安全路径：

```swift
UIViewController.currentVisibleViewController: UIViewController?
```

库内部新代码优先使用可选 API：

```swift
guard let presenter = UIViewController.currentVisibleViewController else {
    return false
}
```

这样可以同时满足两个目标：

- 外部旧代码继续编译，不因为本次优化被迫修改。
- 库内部可以逐步消除隐式解包和强制调用带来的崩溃风险。

## 暴露出的核心问题

### 1. AI 容易只关注局部正确

AI 修复 `XYAlert` 崩溃风险时，会优先让当前文件变得更安全。但三方库不是普通业务代码，公开 API 的签名、返回类型、默认行为都属于对外契约，不能只看当前仓库是否编译通过。

### 2. 测试通过不等于对外兼容

本次 `SPM build` 和单元测试可以通过，但这只能说明当前仓库内部调用没问题。它不能证明外部用户的旧代码还能无修改编译。

三方库还需要额外关注：

- public / open API 签名是否变化。
- 返回值可选性是否变化。
- 方法是否从无返回值变成有返回值。
- 参数默认值、泛型约束、访问级别是否变化。
- 原本会直接执行的逻辑是否变成需要调用方判断结果。

### 3. “安全改造”也可能是破坏性改造

把强制解包改成 optional 是正确方向，但如果直接改公开 API，就会把内部安全问题转嫁给外部调用方。更稳的方式通常是：

- 保留旧 API。
- 新增安全 API。
- 内部先迁移到安全 API。
- 后续大版本再考虑废弃旧 API。

### 4. AI 需要明确边界条件

如果没有明确告诉 AI “这是三方库，public API 必须兼容”，AI 可能按普通 App 项目方式处理：只要当前编译通过、测试通过，就认为完成。

## 人工把关建议

### 1. 让 AI 改代码前先声明 API 兼容策略

涉及三方库、SDK、公共组件时，先要求 AI 明确：

```text
本次修改是否会改变 public/open API？
是否会改变方法签名、返回类型、参数类型、访问级别？
如果需要改变，是否有兼容保留方案？
```

没有回答清楚前，不建议直接让 AI 执行大范围改动。

### 2. 每次改动后检查 public API diff

人工重点检查这些变化：

- `public func`
- `public var`
- `open class`
- `public class`
- `public struct`
- `public enum`
- `public protocol`
- `@objc`
- `@discardableResult`
- `typealias`

可以让 AI 或自己执行：

```bash
git diff -- Sources
```

重点看 public API 的签名是否变化，而不是只看实现是否更安全。

### 3. 对三方库采用“新增优先，替换谨慎”

更推荐的演进方式：

```swift
// 保留旧 API
static var currentVisibleVC: UIViewController!

// 新增安全 API
static var currentVisibleViewController: UIViewController?
```

不推荐在小版本里直接把旧 API 改成：

```swift
static var currentVisibleVC: UIViewController?
```

如果确实要改，应该作为大版本变更，并在文档中写清楚迁移方式。

### 4. 让 AI 输出“影响面说明”

每轮代码修改完成后，要求 AI 附带：

```text
本次 public API 是否变化：
本次行为是否变化：
是否需要用户修改调用代码：
是否新增测试：
验证命令和结果：
仍然存在的风险：
```

如果 AI 只说“测试通过”，这个结论不够。测试通过只是验证结果的一部分。

### 5. 对返回值变化特别敏感

以下变化都要人工重点确认：

- `Void` 改成 `Bool`
- `UIViewController!` 改成 `UIViewController?`
- 非可选改成可选
- 可选改成非可选
- 同步方法改成异步方法
- 回调参数结构变化
- throw / Result / completion 行为变化

有些变化源码上看起来更合理，但对外部调用方就是破坏性变更。

### 6. 区分内部 API 和公开 API

更安全的判断标准：

- `private` / `fileprivate` / `internal`：可以根据项目需要较自由地重构。
- `public` / `open`：默认视为对外契约，除非明确进入大版本重构，否则优先兼容。

本次修正后的思路就是把 optional 安全逻辑放在内部或新增 API 上，而不是直接改旧公开函数。

### 7. 要求 AI 保留迁移路径

如果旧 API 确实设计不好，可以先这样处理：

```swift
@available(*, deprecated, message: "Use currentVisibleViewController for nil-safe access.")
static var currentVisibleVC: UIViewController! {
    currentVisibleController()
}
```

但是否加 deprecated 也要谨慎。对用户影响较大的废弃提示，最好等到文档和替代方案都稳定后再加。

### 8. 建议保留一份人工 Review Checklist

以后每次让 AI 改库代码，可以按这个清单过一遍：

- 是否修改了 public/open API 签名。
- 是否修改了原有方法的返回值语义。
- 是否会导致外部旧代码编译失败。
- 是否把原本的运行时风险变成了调用方必须处理的编译负担。
- 是否新增了兼容 API，而不是直接替换旧 API。
- 是否补了对应测试。
- 是否跑过 SPM build、Demo build、单元测试。
- 文档是否准确描述了“已完成”和“待处理”。

## 后续使用 AI 的推荐提示词

以后可以在让 AI 改代码前补充这段约束：

```text
这是一个对外发布的 Swift 三方库。请优先保持 public/open API 兼容。
除非我明确同意，不要修改已有 public API 的方法名、参数、返回类型、可选性和访问级别。
如果为了安全性需要改变旧行为，请优先新增安全 API，并让内部代码迁移到新 API。
修改完成后，请单独输出 public API 影响面、外部调用方是否需要改代码、验证命令和结果。
```

如果涉及崩溃修复，可以追加：

```text
请修复内部崩溃风险，但不要把风险直接转嫁成外部调用方必须处理的 optional 或 breaking change。
旧 API 保持兼容，新 API 可以更安全。
```

## 推荐结论

AI 可以显著提高代码整理、测试补充和风险扫描效率，但在三方库维护场景下，人工必须重点把关 API 契约。

对 `YYUIKit` 这类库，后续优化应坚持：

- 小版本：修 bug、补测试、内部安全改造、保持外部兼容。
- 中版本：新增更安全 API，文档提示推荐用法。
- 大版本：集中清理历史 API、移除不合理设计、明确迁移指南。

这样既能持续优化质量，也能减少外部用户因为升级库版本而被迫改代码的风险。
