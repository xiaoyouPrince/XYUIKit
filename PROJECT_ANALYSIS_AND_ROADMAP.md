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

`Tests/YYUIKitTests` 已开始补充断言型测试，目前覆盖部分 Foundation 扩展、String / Date 转换、颜色转换、`XYRateLimiter` 和 `XYFileManager`。CI 已增加 iOS Simulator XCTest 执行。后续仍需要继续覆盖网络工具、权限状态等核心能力。

### 3. 稳定性风险偏高

源码中存在较多 `fatalError`、强制解包、强制类型转换和 `try!`。这些在工具库中风险较高，尤其是对外 API、权限管理、文件系统、window/rootVC 查找等场景。

### 4. 部分 API 仍偏个人工具化

例如 `XYNetTool` 的 GET 参数手工拼接，缺少 URL 编码；下载超时逻辑存在跨线程状态变量；部分回调线程语义不够清晰。

### 5. 隐私清单需要复核

项目实际使用了 `UserDefaults`、`FileManager`、Photos、HealthKit、Location、Bluetooth、网络等能力，但 `PrivacyInfo.xcprivacy` 当前声明较空。需要按 Apple 要求重新核对 Required Reason API 和隐私数据声明。

### 6. Auth 子模块存在审核风险

`Auth` 子模块当前包含定位、通知、蓝牙、健康等权限申请相关代码。后续需要重点评估是否从默认完整包中移除，或者改成更细粒度的按需导入模块。原因是 App Store 审核对权限相关能力比较敏感：如果 App 未实际使用某项权限，但依赖包中存在对应权限申请代码、权限说明或相关能力入口，可能导致审核被拒。

短期策略：避免业务方默认接入完整 `YYUIKit` 时被动带入全部权限能力。

中期策略：将 `Auth` 拆为独立 subspec / SPM target，甚至按权限继续拆分为 Location、Notification、Bluetooth、Health 等更细模块。

### 7. CocoaPods 长期发布风险

CocoaPods 计划在 2026 年 12 月进入永久只读状态。后续不能继续把公开 CocoaPods 作为唯一发布渠道，需要提前规划：

- 保留现有 podspec，满足存量项目。
- 评估私有化 Pod 源，服务内部或个人项目。
- 将 Swift Package Manager 作为长期主发布方式。
- 持续补齐 SPM target 拆分、资源加载、Demo 验证和文档。

### 8. Demo 与库兼容范围不一致

库声明支持 iOS 12，但 Demo target 为 iOS 15，无法覆盖 iOS 12-14 的兼容性验证。

## 优化优先级

### P0：工程可用性

- 已完成：修复 `Package.swift` 中 SnapKit 的本机路径依赖，改为远程依赖。
- 已完成：生成 `Package.resolved`，当前 SnapKit 锁定为 `5.7.1`。
- 已完成：新增 `scripts/verify_spm_ios.sh`，用于 generic iOS 目标验证 Swift Package 构建。
- 已完成：新增 `scripts/verify_demo_ios.sh`，用于仓库内置 Demo 的 CocoaPods 集成构建验证。
- 已完成：新增 `scripts/spm_github_doctor.sh`，用于排查 GitHub/SPM 拉包网络和代理问题。
- 已完成：跑通仓库内置 CocoaPods Demo 编译验证。
- 已完成：新增 GitHub Actions 基础 CI，覆盖 SPM iOS build 和 Demo build。
- 已完成：跑通 CocoaPods lint。
- 已完成：将 podspec lint 纳入 CI。

### P1：稳定性治理

- 将对外 API 中的 `fatalError` 改为可恢复错误。
- 优先清理 window/rootVC、文件节点、权限状态、资源加载相关强制解包。
- 明确 UI API 的主线程调用约定。
- 持续给基础工具补充单元测试，并逐步扩大 CI 覆盖。

### P2：模块边界整理

- 保持 Foundation 工具尽量不依赖 UIKit。
- 优先处理 `Auth` 默认引入风险：考虑移除默认完整包中的 Auth，或拆成按需导入的独立权限模块。
- 将 `Auth` 拆成权限核心和 UI 弹窗部分，必要时继续拆分为 Location、Notification、Bluetooth、Health 等子模块。
- 继续细化 CocoaPods subspec / SPM target，降低使用方引入成本。
- 统一资源加载路径，保证 CocoaPods 和 SPM 行为一致。

### P3：文档与 API 产品化

- 补充核心组件使用示例。
- 整理 README：安装、模块说明、快速开始、组件索引、版本兼容、迁移说明。
- 统一命名风格，修正拼写问题，例如 `creatFile`、`paramters`。
- 区分 Swift-only API 和 ObjC 兼容 API，避免过度使用 `@objc` 影响 Swift 表达力。
- 补充 CocoaPods 只读后的发布策略：私有 Pod 源或 SPM 主导迁移。

## 后续路径

### 第一阶段：修复构建链

目标：任何机器 clone 后都可以构建。

- 已完成：修复 SnapKit SPM 依赖。
- 已完成：增加 iOS 平台 SPM 验证脚本 `scripts/verify_spm_ios.sh`。
- 已完成：恢复并验证仓库内置 Demo，后续功能开发以该 Demo 为主要集成验证入口。
- 已完成：增加 GitHub/SPM 网络诊断脚本 `scripts/spm_github_doctor.sh`。
- 已完成：验证 CocoaPods 集成。
- 已完成：增加基础 CI。
- 已完成：增加 podspec lint CI。

### 第二阶段：补基础测试

目标：核心工具能力有回归保护。

优先测试：

- 已完成：部分 Collection、CGRect / CGSize、String / Date、UIColor 扩展。
- 已完成：`XYRateLimiter` 基础频率限制行为。
- 已完成：`XYFileManager` 基础文件创建、删除、读写和路径校验。
- 待处理：UIImage 等 Foundation 扩展。
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
- 重点处理 `Auth` 审核风险：从默认完整包中移除，或改为按需导入。
- 梳理 CocoaPods subspec，保证存量 Pod 用户可以按模块接入。
- 梳理 SPM target，将 SPM 作为长期主发布方式。
- 降低 Auth、FileSystem、Debug 工具对完整 UIKit 模块的耦合。

### 第五阶段：发布渠道迁移

目标：应对 CocoaPods 进入只读状态后的长期维护。

- 保留现有 CocoaPods 兼容能力，避免影响存量项目。
- 评估是否维护私有 Pod 源，用于内部项目或个人项目继续通过 Pod 接入。
- 将新增能力优先适配 SPM，并保证 `scripts/verify_spm_ios.sh` 持续通过。
- 在 README 中明确推荐 SPM 作为长期接入方式。

### 第六阶段：文档和 Demo 标准化

目标：让项目更适合长期维护和对外使用。

- 将 Demo 从试验集合整理成组件目录。
- 每个核心组件补一个最小示例。
- README 保留高层说明，详细文档逐步拆到 `Docs/`。
- 补充版本升级说明和兼容性说明。

## 建议近期先做的 5 件事

1. 继续给 UIImage 扩展、`XYNetTool`、权限状态转换逻辑补测试。
2. 清理最危险的 `fatalError` 和 window 强制解包。
3. 复核 `PrivacyInfo.xcprivacy`，并同步评估 `Auth` 是否从默认完整包中移除。
4. 规划 CocoaPods 只读后的发布策略：私有 Pod 源或 SPM 主导迁移。
5. 继续整理 Demo 组件目录和最小示例，并逐步把单元测试纳入 CI。

## 总结

YYUIKit 当前已经不是简单的代码片段集合，而是一个有实际沉淀价值的 iOS 工具库。下一步优化重点不应继续盲目扩功能，而应优先解决构建可用性、测试覆盖、稳定性和发布规范。等这些基础打稳之后，再继续扩展图片编辑、二维码、日志系统等新能力会更稳。
