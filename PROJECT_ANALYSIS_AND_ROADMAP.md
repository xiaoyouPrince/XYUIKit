# YYUIKit Project Analysis and Roadmap

## 项目现状

YYUIKit 是一个面向 iOS 的 Swift UI/工具组件库，仓库名为 `XYUIKit`，实际发布名为 `YYUIKit`。项目主要由三部分组成：

- `Sources/Classes/Foundation`：Foundation 扩展与基础工具。
- `Sources/Classes/UIKit`：UIKit 扩展、Toast、Alert、文件系统、调试工具、媒体选择/播放等。
- `Sources/Classes/Authority`：定位、通知、蓝牙、健康、活动权限管理。

当前项目同时支持 CocoaPods 和 Swift Package Manager，Demo 工程位于 `YYUIKitDemo`。

后续功能开发以仓库内置 `YYUIKitDemo` 作为主要集成验证工程。该 Demo 通过 CocoaPods 以本地路径接入 YYUIKit，可以覆盖更接近真实 App 的集成链路；SPM 则继续作为包发布形态的独立验证入口。

项目规模概览：

- 库源码约 77 个 Swift 文件，约 1.09 万行。
- Demo 约 41 个 Swift 文件。
- CocoaPods 当前版本为 `0.7.3`。
- 库声明最低支持 iOS 12，Swift 5。

整体定位比较清晰：这是一个日常 App 开发中沉淀出来的通用 UIKit 工具包，功能覆盖较广，已经具备继续产品化、工程化的基础。

## 主要优点

- 功能覆盖面完整，包含 UI 组件、系统工具、调试工具、权限管理、文件查看等高频能力。
- CocoaPods 已按 `Foundation`、`UIKit`、`Auth` 做了 subspec 拆分，方向合理。
- Demo 工程包含较多真实使用场景，便于功能验证。
- README 已有安装方式、功能说明和版本记录。
- 已开始兼容 SPM、资源加载和隐私清单，具备进一步标准化发布的基础。

## 当前问题

### 1. SwiftPM 路径依赖问题已处理

历史问题：`Package.swift` 中 SnapKit 依赖曾指向本机绝对路径：

```swift
.package(name: "SnapKit", path: "/Users/will/Desktop/SnapKit")
```

这会导致其他机器无法通过 SwiftPM 构建。目前已改为远程 SnapKit 依赖，并生成 `Package.resolved` 锁定当前解析版本。

注意：YYUIKit 是 iOS/UIKit 包，默认 `swift test` 会按 macOS host 平台编译，可能报 `no such module 'UIKit'`。SPM 主验证方式应使用 `scripts/verify_spm_ios.sh`，按 generic iOS 目标构建；如需专门验证模拟器，可通过 `DESTINATION` 环境变量覆盖。

### 2. 自动化测试不足

`Tests/YYUIKitTests` 当前只有示例代码，没有断言型测试。基础扩展、文件工具、网络工具、权限状态等核心能力缺少回归保护。

### 3. 稳定性风险偏高

源码中存在较多 `fatalError`、强制解包、强制类型转换和 `try!`。这些在工具库中风险较高，尤其是对外 API、权限管理、文件系统、window/rootVC 查找等场景。

### 4. 部分 API 仍偏个人工具化

例如 `XYNetTool` 的 GET 参数手工拼接，缺少 URL 编码；下载超时逻辑存在跨线程状态变量；部分回调线程语义不够清晰。

### 5. 隐私清单需要复核

项目实际使用了 `UserDefaults`、`FileManager`、Photos、HealthKit、Location、Bluetooth、网络等能力，但 `PrivacyInfo.xcprivacy` 当前声明较空。需要按 Apple 要求重新核对 Required Reason API 和隐私数据声明。

### 6. Demo 与库兼容范围不一致

库声明支持 iOS 12，但 Demo target 为 iOS 15，无法覆盖 iOS 12-14 的兼容性验证。

## 优化优先级

### P0：工程可用性

- 已完成：修复 `Package.swift` 中 SnapKit 的本机路径依赖，改为远程依赖。
- 已完成：生成 `Package.resolved`，当前 SnapKit 锁定为 `5.7.1`。
- 已完成：新增 `scripts/verify_spm_ios.sh`，用于 generic iOS 目标验证 Swift Package 构建。
- 已完成：新增 `scripts/verify_demo_ios.sh`，用于仓库内置 Demo 的 CocoaPods 集成构建验证。
- 已完成：新增 `scripts/spm_github_doctor.sh`，用于排查 GitHub/SPM 拉包网络和代理问题。
- 已完成：跑通仓库内置 CocoaPods Demo 编译验证。
- 待处理：跑通 CocoaPods lint。
- 待处理：增加基础 CI：SPM iOS build、podspec lint、Demo build。

### P1：稳定性治理

- 将对外 API 中的 `fatalError` 改为可恢复错误。
- 优先清理 window/rootVC、文件节点、权限状态、资源加载相关强制解包。
- 明确 UI API 的主线程调用约定。
- 给基础工具补充单元测试。

### P2：模块边界整理

- 保持 Foundation 工具尽量不依赖 UIKit。
- 考虑将 `Auth` 拆成权限核心和 UI 弹窗部分。
- 继续细化 CocoaPods subspec / SPM target，降低使用方引入成本。
- 统一资源加载路径，保证 CocoaPods 和 SPM 行为一致。

### P3：文档与 API 产品化

- 补充核心组件使用示例。
- 整理 README：安装、模块说明、快速开始、组件索引、版本兼容、迁移说明。
- 统一命名风格，修正拼写问题，例如 `creatFile`、`paramters`。
- 区分 Swift-only API 和 ObjC 兼容 API，避免过度使用 `@objc` 影响 Swift 表达力。

## 后续路径

### 第一阶段：修复构建链

目标：任何机器 clone 后都可以构建。

- 已完成：修复 SnapKit SPM 依赖。
- 已完成：增加 iOS 平台 SPM 验证脚本 `scripts/verify_spm_ios.sh`。
- 已完成：恢复并验证仓库内置 Demo，后续功能开发以该 Demo 为主要集成验证入口。
- 已完成：增加 GitHub/SPM 网络诊断脚本 `scripts/spm_github_doctor.sh`。
- 已完成：验证 CocoaPods 集成。
- 待处理：增加基础 CI。

### 第二阶段：补基础测试

目标：核心工具能力有回归保护。

优先测试：

- String / Date / UIColor / UIImage 等 Foundation 扩展。
- `XYFileManager`。
- `XYRateLimiter`。
- `XYNetTool` 的参数构造、错误回调、下载逻辑。
- 权限状态转换逻辑。

### 第三阶段：降低崩溃风险

目标：工具库不因普通调用错误直接崩溃。

- 替换对外 API 中的 `fatalError`。
- 清理高风险强制解包。
- 优化 keyWindow / currentVC 查找逻辑。
- 优化 FileSystem、AuthorityManager、XYPickerView 等高频入口的错误处理。

### 第四阶段：隐私与模块化

目标：发布形态更稳定、更符合平台要求。

- 复核并完善 `PrivacyInfo.xcprivacy`。
- 梳理 CocoaPods subspec。
- 梳理 SPM target。
- 降低 Auth、FileSystem、Debug 工具对完整 UIKit 模块的耦合。

### 第五阶段：文档和 Demo 标准化

目标：让项目更适合长期维护和对外使用。

- 将 Demo 从试验集合整理成组件目录。
- 每个核心组件补一个最小示例。
- README 保留高层说明，详细文档逐步拆到 `Docs/`。
- 补充版本升级说明和兼容性说明。

## 建议近期先做的 5 件事

1. 增加基础 CI，覆盖 SPM iOS build、Demo build 和 podspec lint。
2. 跑通 CocoaPods lint。
3. 给 `XYFileManager`、`XYRateLimiter`、基础 String/Date 扩展补测试。
4. 清理最危险的 `fatalError` 和 window 强制解包。
5. 复核 `PrivacyInfo.xcprivacy`。

## 总结

YYUIKit 当前已经不是简单的代码片段集合，而是一个有实际沉淀价值的 iOS 工具库。下一步优化重点不应继续盲目扩功能，而应优先解决构建可用性、测试覆盖、稳定性和发布规范。等这些基础打稳之后，再继续扩展图片编辑、二维码、日志系统等新能力会更稳。
