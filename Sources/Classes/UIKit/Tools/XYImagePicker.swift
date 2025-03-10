//
//  XYImagePicker.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation
import UIKit
import AVFoundation

class XYImagePicker: UIViewController {
    static let shared: XYImagePicker = .init()
    private init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var imageCallback: ((UIImage)->())?
    private var movieCallback: ((URL)->())?
    private var ps: UIViewController?
    
    static func chooseImage(_ callback: @escaping (UIImage)->()) {
        let ps = UIImagePickerController()
        ps.sourceType = .photoLibrary
        ps.delegate = shared
        if #available(iOS 13.0, *) {
            ps.overrideUserInterfaceStyle = XYUtils.overrideUserInterfaceStyle
        }
        shared.imageCallback = callback
        shared.ps = ps
        currentVisibleVC.present(ps, animated: true)
    }
    
    static func takePhoto(_ callback: @escaping (UIImage)->()) {
        let ps = UIImagePickerController()
        ps.sourceType = .camera
        ps.delegate = shared
        ps.cameraDevice = .rear
        if #available(iOS 13.0, *) {
            ps.overrideUserInterfaceStyle = XYUtils.overrideUserInterfaceStyle
        }
        shared.imageCallback = callback
        shared.ps = ps
        currentVisibleVC.present(ps, animated: true)
    }
    
    static func takeVideo(_ callback: @escaping (URL)->()) {
        let ps = UIImagePickerController()
        ps.sourceType = .camera
        ps.delegate = shared
        ps.mediaTypes = ["public.movie"]
        ps.videoQuality = .typeHigh
        ps.cameraDevice = .rear
        if #available(iOS 13.0, *) {
            ps.overrideUserInterfaceStyle = XYUtils.overrideUserInterfaceStyle
        }
        shared.movieCallback = callback
        shared.ps = ps
        currentVisibleVC.present(ps, animated: true)
    }
    
    static func chooseVideo(callback: @escaping (URL)->()) {
        let ps = UIImagePickerController()
        ps.sourceType = .photoLibrary
        ps.delegate = shared
        ps.mediaTypes = ["public.movie"]
        ps.allowsEditing = true
        if #available(iOS 13.0, *) {
            ps.overrideUserInterfaceStyle = XYUtils.overrideUserInterfaceStyle
        }
        shared.movieCallback = callback
        shared.ps = ps
        currentVisibleVC.present(ps, animated: true)
    }
    
    @objc public static func chooseAudioFromVideo(callback: @escaping (URL?, Error?)->()) {
        chooseVideo { videoUrl in
            
            print("videoUrl = \(videoUrl)")
            self.exportAudioFromVideo(url: videoUrl) { audioUrl, error in
                callback(audioUrl, error)
            }
        }
    }
}

extension XYImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        XYImagePicker.shared.ps?.dismiss(animated: true)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            XYImagePicker.shared.imageCallback?(image)
        }else
        if let movieUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            XYImagePicker.shared.movieCallback?(movieUrl)
        }else{
            Toast.make("an error occurred")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        XYImagePicker.shared.ps?.dismiss(animated: true)
    }
}

private extension XYImagePicker {
    static func exportAudioFromVideo(url: URL, complete:((URL?, Error?)->())?) {
        let asset = AVAsset(url: url)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("Failed to create export session")
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).caf")
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a
        
        exportSession.exportAsynchronously {
            callback()
        }
        
        /// iOS 18 (Swift 6)之后闭包被默认设置为@Sendable，系统会对内部捕获变量校验是否遵守 Sendable 协议，当前写法是为避开系统检查的警告
        func callback() {
            switch exportSession.status {
            case .completed:
                print("Audio extraction complete. Output URL: \(outputURL)")
                // Do something with the extracted audio file
                complete?(outputURL, nil)
            case .failed:
                if let error = exportSession.error {
                    print("Audio extraction failed: \(error.localizedDescription)")
                    complete?(nil, error)
                } else {
                    print("Audio extraction failed")
                    complete?(nil, NSError())
                }
            case .cancelled:
                print("Audio extraction cancelled")
                complete?(nil, NSError())
            default:
                print("Unknown status")
                complete?(nil, NSError())
            }
        }
    }
}

