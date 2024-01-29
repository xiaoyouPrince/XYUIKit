//
//  Demo_Combine.swift
//  XYUIKitDemo
//
//  Created by 渠晓友 on 2023/2/26.
//  Copyright © 2023 XYUIKit. All rights reserved.
//
//
//  __  __          ____           _          _
//  \ \/ / /\_/\   /___ \  _   _  (_)   ___  | | __
//   \  /  \_ _/  //  / / | | | | | |  / __| | |/ /
//   /  \   / \  / \_/ /  | |_| | | | | (__  |   <
//  /_/\_\  \_/  \___,_\   \__,_| |_|  \___| |_|\_\
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

/*
 * - TODO -
 * 选择视频, 并拿到指定视频
 *
 *  1. 获取系统视频
 *  2. 视频裁剪 / 编辑
 */

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class CombineViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var selectedVideoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("Select Video", for: .normal)
        selectButton.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
        
        view.addSubview(selectButton)
        
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func selectVideo() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[.mediaURL] as? URL {
            selectedVideoURL = videoURL
            dismiss(animated: true, completion: nil)
            
            // 截取视频
            let startTime = CMTime(seconds: 2.0, preferredTimescale: 600)
            let endTime = CMTime(seconds: 6.0, preferredTimescale: 600)
            
            trimVideo(sourceURL: videoURL, startTime: startTime, endTime: endTime) { (trimmedURL) in
                // 处理截取后的视频，比如展示在界面上
                let player = AVPlayer(url: trimmedURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func trimVideo(sourceURL: URL, startTime: CMTime, endTime: CMTime, completion: @escaping (URL) -> Void) {
        let asset = AVURLAsset(url: sourceURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .mp4
        
        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        exportSession?.timeRange = timeRange
        
        exportSession?.exportAsynchronously {
            guard exportSession?.status == .completed else {
                print("Export failed: \(exportSession?.error?.localizedDescription ?? "")")
                return
            }
            
            DispatchQueue.main.async {
                completion(outputURL)
            }
        }
    }
}
