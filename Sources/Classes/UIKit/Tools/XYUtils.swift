//
//  XYUtils.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation
import UIKit
import Photos

public typealias Utils = XYUtils
public typealias AppUtils = XYUtils
@objc public class XYUtils: NSObject {
    private override init() {}
    
    /// 指定 XYUtils 下所有功能的的 userInterfaceStyle
    @available(iOS 12.0, *)
    @objc public static var overrideUserInterfaceStyle = UIUserInterfaceStyle.unspecified
    
    /// 选择时间/ 中文年月日格式
    /// - Parameters:
    ///   - title: 指定一个标题
    ///   - choosenDate: 指定当前选中的时间
    ///   - callback: 选择完毕回调
    @objc public static func chooseDate(title: String,
                                        choosenDate: Date,
                                        callback: @escaping (_ date: Date)->()) {
        XYDatePicker.chooseDate(title: title, choosenDate: choosenDate) { date in
            DispatchQueue.safeMain {
                callback(date)
            }
        }
    }
    
    
    /// 选择颜色
    /// - Parameter callback: 选择颜色回调
    @available(iOS 14.0, *)
    @objc public static func chooseColor(callback: @escaping (_ color: UIColor)->()) {
        DispatchQueue.safeMain {
            XYColorPicker.showColorPicker { color in
                DispatchQueue.safeMain {
                    callback(color)
                }
            }
        }
    }
    
    /// 选择照片
    /// - Parameter callback: 选择照片回调
    /// - NOTE: 需要在 Info.plist 中加入 NSPhotoLibraryUsageDescription, 说明原因
    @objc public static func chooseImage(callback: @escaping (_ image: UIImage)->()) {
        DispatchQueue.safeMain {
            XYImagePicker.chooseImage { image in
                DispatchQueue.safeMain {
                    callback(image)
                }
            }
        }
    }
    
    /// 拍摄照片
    /// - Parameter callback: 选择照片回调
    /// - NOTE: 需要在 Info.plist 中加入 NSCameraUsageDescription, 说明原因
    @objc public static func takePhoto(callback: @escaping (_ image: UIImage)->()) {
        DispatchQueue.safeMain {
            XYImagePicker.takePhoto { image in
                DispatchQueue.safeMain {
                    callback(image)
                }
            }
        }
    }
    
    /// 拍摄视频
    /// - Parameter callback: 拍摄视频回调
    /// - NOTE: 需要在 Info.plist 中加入 NSCameraUsageDescription & NSMicrophoneUsageDescription, 说明原因
    @objc public static func takeVideo(callback: @escaping (_ movieUrl: URL)->()) {
        DispatchQueue.safeMain {
            XYImagePicker.takeVideo { movieUrl in
                DispatchQueue.safeMain {
                    callback(movieUrl)
                }
            }
        }
    }
    
    /// 选择视频
    /// - Parameter callback: 选择视频回调, 返回 videoURL
    @objc public static func chooseVideo(callback: @escaping (_ movieUrl: URL)->()) {
        DispatchQueue.safeMain {
            XYImagePicker.chooseVideo { movieUrl in
                DispatchQueue.safeMain {
                    callback(movieUrl)
                }
            }
        }
    }
    
    /// 选择音频, 从视频中提取
    /// - Parameter callback: 选择音频回调, 返回 audioURL
    @objc public static func chooseAudioFromVideo(callback: @escaping (_ audioURL: URL?, _ error: Error?)->()) {
        DispatchQueue.safeMain {
            XYImagePicker.chooseAudioFromVideo { audioURL, error in
                DispatchQueue.safeMain {
                    callback(audioURL, error)
                }
            }
        }
    }
    
    /// 播放音频
    /// - Parameter url: 音频的文件地址
    @objc public static func playAudio(url: URL) {
        if let data = try? Data(contentsOf: url) {
            playAudio(data: data)
        }
    }
    
    /// 播放音频
    /// - Parameter data: 音频文件
    @objc public static func playAudio(data: Data) {
        DispatchQueue.safeMain {
            XYMediaPlayer.playAudio(data: data)
        }
    }
    
    /// 播放视频
    /// - Parameter url: 视频的文件地址
    @objc public static func playVideo(url: URL) {
        DispatchQueue.safeMain {
            XYMediaPlayer.playVideo(url: url)
        }
    }
    
    /// 使用文件系统打开指定文件夹, 默认使用 present 方式
    /// - Parameter path: 文件夹路径, 默认为路径是当前 App 的沙盒目录
    @objc public static func openFolder(_ path: String = FileSystem.sandBoxPath()) {
        DispatchQueue.safeMain {
            FileSystem.default.open(dir: path)
        }
    }
    
    /// 使用文件系统打开指定文件夹, 使用导航栏 push 方式
    /// - Parameter path: 文件夹路径, , 默认为路径是当前 App 的沙盒目录
    /// - Parameter onNavigationController: push 所在的导航栏
    @objc public static func openFolder(_ path: String = FileSystem.sandBoxPath(), withPush onNavigationController: UINavigationController) {
        DispatchQueue.safeMain {
            FileSystem.default.pushOpen(navigationVC: onNavigationController, dirpath: path)
        }
    }
    
    
    /// 保存图片到图库 - 本方法基于 Photos 框架保存，图片数据不压缩
    /// - Parameters:
    ///   - imageData: 图片的二进制数据
    ///   - completion: 成功失败回调
    @objc public static func saveImageToPhotosAlbum(imageData: Data, completion: @escaping (_ success: Bool, _ errMsg: String?)->()) {
        PhotoLibraryManager.shared.saveImageToLibrary(imageData: imageData) { result in
            switch result {
            case .success:
                completion(true, nil)
            case .failure(let error):
                completion(false, error?.localizedDescription)
            }
        }
    }
    
    /// 保存图片到图库 - 本方法基于 UIImageWriteToSavedPhotosAlbum 方法保存，图片数据会被系统优化，通常会压缩
    /// - Parameters:
    ///   - image: 图片的 UIImage
    ///   - completion: 成功失败回调
    @objc public static func saveImageToPhotosAlbum(image: UIImage, completion: @escaping (_ success: Bool, _ errMsg: String?)->()) {
        PhotoLibraryManager.shared.saveImageToLibrary(image: image) { result in
            switch result {
            case .success:
                completion(true, nil)
            case .failure(let error):
                completion(false, error?.localizedDescription)
            }
        }
    }
}
