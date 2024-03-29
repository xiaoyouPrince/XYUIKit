# XYUIKit

使用 Swift 写的一些小控件、工作中某些组件的雏形

慢慢积累，逐渐形成自己的一套开发工具包

> NOTE
> 本项目从最初就想叫 XYUIKit, 无奈名称早已被占用
> 想来想去, 最终决定使用 YYUIKit 命名

### 使用 CocoaPods 安装

```ruby
pod YYUIKit                     #全部功能, 主要基于 UIKit 平台
pod YYUIKit/Foundation          #Foundation功能分类, 此部分平台无关, 可用于 Apple 全平台开发
```

## 近期 TODOs
1. XYLoger: 一套 log 读写工具, 目标: 日志写入文件, 便于调试,查看日志, 无需断点调试, 尤其是避免一些启动等特殊场景下的断点调试
2. XYImageEditor: 一个简易的图片编辑器, 裁剪,旋转,翻转,缩放... 参考微信图片裁剪
3. XYQrCodeManager: 一个二维码/条码, 生成 / 扫描识别 / 图片二维码识别工具, 参考微信扫码
4. ...

## 功能介绍

YYUIKit 分 `Foundation 分类 / UIKit` 两部分, 具体 UI 欢迎下载 Demo 体验, 如果对你有帮助, 欢迎点赞🌟🌟🌟🌟支持 💪🎉

### Foundation 分类

此部分平台无关, 可用于 Apple 全平台开发, 可单独导入

```
常用 Foundation 分类/工具如下
1. String / NSAttributeString
2. Date
3. DispatchQueue
4. UIColor / NSColor
5. Optional
6. Runlooper
7. UIImage
8. ......
```
    
### UIKit

此部分主要依赖 UIKit, 可用于 UIKit 项目开发

```
(1). Categories: 
CGFloat / Label / Control / View / ViewController / Responder / ScrollView / Application ....

(2). 自定义控制器
1. XYAlertSheetController, 便捷的 alertSheet 弹框, 封装框的各种效果, 仅需要专注于弹框内容
2. XYSpeedMatchController, 便捷的快速匹配控制器, 类似探探快速匹配心动女孩页面

(3) 文件系统 FileSystem
1. FileSystem 核心就是提供一套 iOS 下的文件夹查看/预览系统

(4) Global
1. 各种公共函数, 如 doOnce / doOnce(forKey:) / doSth(forKey: forCount)
2. 一些公共常量, 如 状态栏高度 / 导航栏高度 / 底部安全区高度 ...

(5) Toast
1. 提供一套全局的 Toast 工具, 支持 文本 + activity

(6) 系统工具
1. XYAlert 系统 UIAlertController 的封装, 方便使用
2. XYAlertManager, 弹框管理器, 比如 App 启动后需要按指定顺序弹框各种提示/功能
3. XYNetTool, 一套简单的网络请求工具/ Post/Get/DataTask/ 前期开发阶段网络调试利器
4. XYDebugTool, 提供一些调试常用小工具/函数
5. XYFileManager, 分装一套便捷的文件读写工具, 支持 Model 快速读写 / 持久化 / 文档查看
6. XYUtils - 各种系统工具, 提供别名 AppUtils, 所有功能类方法调用即可
	1. XYDatePicker 日期选择器 (yyyy-MM-dd)
	2. XYColorPicker 颜色选择器
	3. XYImagePicker 图片/音频(从视频截取)/视频选取工具
	4. XYMediaPlayer 音视频播放器
	5. XYImageEditor 图片编辑器: in doing

(7) Views
1. XYBadgeView: 红点 / 各种消息提示的红点, 做过 IM 应该比较有体会
2. XYDebugView: 一套悬浮小球的解决方案, 各种小球, 各种场景自定义
3. XYTagsView: 一套标签视图工具, 类似于商品标签 / 简易的 CollectionView / 九宫格布局 / 自定义样式 / 点击事件
4. XYIndexBar: UITableView.indexView 的自定义实现
5. XYPickerView: 一个 PickerView 的快捷实现, 可高度自定义
6. XYStackView / XYBoxView: 对 UIStackView 便捷封装, 对 UIView 快速拓展边框区域的实现

持续增加中...
```

## 版本记录(重要功能版本)

#### v0.3.0 (2024/2/22)

1. 新增文件系统 FileSystem, 可快捷查看指定目录下的文件结构, 支持文件的查看和预览功能
2. 提供 AppUtils 的快捷调用函数

#### v0.2.5 (2024/2/10)

1. 增加 XYDebugView, 可用于创建各种悬浮小球 XYDebugView 
	
	- 提供一套默认实现
	- 支持悬浮小球的尺寸, 手势, 添加父容器, 视图内容全面自定义

2. 增加 Runlooper 工具类, 模拟 runloop 机制提供特定用途的循环

#### older versions

基础常用分类工具 & 自定义工具类 & 自定义 UIViews
    


