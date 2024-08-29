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
    
    @objc public static func chooseAudioFromVideo(callback: @escaping (URL)->()) {
        chooseVideo { videoUrl in
            
            print("videoUrl = \(videoUrl)")
            self.exportAudioFromVideo(url: videoUrl) { audioUrl in
                callback(audioUrl)
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
    static func exportAudioFromVideo(url: URL, complete:((URL)->())?) {
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
            switch exportSession.status {
            case .completed:
                print("Audio extraction complete. Output URL: \(outputURL)")
                // Do something with the extracted audio file
                complete?(outputURL)
            case .failed:
                if let error = exportSession.error {
                    print("Audio extraction failed: \(error.localizedDescription)")
                } else {
                    print("Audio extraction failed")
                }
            case .cancelled:
                print("Audio extraction cancelled")
            default:
                print("Unknown status")
            }
        }
    }
}

