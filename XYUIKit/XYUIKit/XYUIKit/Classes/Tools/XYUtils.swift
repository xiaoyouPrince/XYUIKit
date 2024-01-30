//
//  XYUtils.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation

public typealias Utils = XYUtils
public typealias AppUtils = XYUtils
@objc public class XYUtils: NSObject {
    private override init() {}
    
    /// 选择时间/ 中文年月日格式
    /// - Parameters:
    ///   - title: 指定一个标题
    ///   - choosenDate: 指定当前选中的时间
    ///   - callback: 选择完毕回调
    @objc public static func chooseDate(title: String,
                                        choosenDate: Date,
                                        callback: @escaping (_ date: Date)->()) {
        XYDatePicker.chooseDate(title: title, choosenDate: choosenDate) { date in
            callback(date)
        }
    }
    
    
    /// 选择颜色
    /// - Parameter callback: 选择颜色回调
    @available(iOS 14.0, *)
    @objc public static func chooseColor(callback: @escaping (_ color: UIColor)->()) {
        XYColorPicker.showColorPicker { color in
            callback(color)
        }
    }
    
    /// 选择照片
    /// - Parameter callback: 选择照片回调
    /// - NOTE: 需要在 Info.plist 中加入 NSPhotoLibraryUsageDescription, 说明原因
    @objc public static func chooseImage(callback: @escaping (_ image: UIImage)->()) {
        XYImagePicker.chooseImage { image in
            callback(image)
        }
    }
    
    /// 拍摄照片
    /// - Parameter callback: 选择照片回调
    /// - NOTE: 需要在 Info.plist 中加入 NSCameraUsageDescription, 说明原因
    @objc public static func takePhoto(callback: @escaping (_ image: UIImage)->()) {
        XYImagePicker.takePhoto { image in
            callback(image)
        }
    }
    
    /// 拍摄视频
    /// - Parameter callback: 拍摄视频回调
    /// - NOTE: 需要在 Info.plist 中加入 NSCameraUsageDescription & NSMicrophoneUsageDescription, 说明原因
    @objc public static func takeVideo(callback: @escaping (_ movieUrl: URL)->()) {
        XYImagePicker.takeVideo { movieUrl in
            callback(movieUrl)
        }
    }
    
    /// 选择视频
    /// - Parameter callback: 选择视频回调, 返回 videoURL
    @objc public static func chooseVideo(callback: @escaping (_ movieUrl: URL)->()) {
        XYImagePicker.chooseVideo { movieUrl in
            callback(movieUrl)
        }
    }
    
    /// 选择音频, 从视频中提取
    /// - Parameter callback: 选择音频回调, 返回 audioURL
    @objc public static func chooseAudioFromVideo(callback: @escaping (_ audioURL: URL)->()) {
        XYImagePicker.chooseAudioFromVideo { audioURL in
            callback(audioURL)
        }
    }
    
}
