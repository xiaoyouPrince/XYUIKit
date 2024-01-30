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
import YYUIKit

//class CombineViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, AVAudioPlayerDelegate {
//    var selectedVideoURL: URL?
//    var audioPlayer: AVAudioPlayer?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .random
//        
//        let selectButton = UIButton(type: .system)
//        selectButton.setTitle("Select Video", for: .normal)
//        selectButton.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
//        
//        view.addSubview(selectButton)
//        
//        selectButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            selectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    @objc func selectVideo() {
//        AppUtils.chooseVideo {[weak self]  videoURL in
//            guard let self = self else { return }
//            
//            self.selectedVideoURL = videoURL
//            self.dismiss(animated: true, completion: nil)
//            
//            Toast.make("hhhhh")
//            
////            // 截取视频
////            let startTime = CMTime(seconds: 2.0, preferredTimescale: 600)
////            let endTime = CMTime(seconds: 6.0, preferredTimescale: 600)
////            
////            self.trimVideo(sourceURL: videoURL, startTime: startTime, endTime: endTime) { (trimmedURL) in
////                // 处理截取后的视频，比如展示在界面上
////                let player = AVPlayer(url: trimmedURL)
////                let playerViewController = AVPlayerViewController()
////                playerViewController.player = player
////                self.present(playerViewController, animated: true) {
////                    player.play()
////                }
////            }
//            
//            // 提取音频并播放
//            self.extractAudioAndPlay(videoURL: videoURL)
//        }
//    }
//    
//    func trimVideo(sourceURL: URL, startTime: CMTime, endTime: CMTime, completion: @escaping (URL) -> Void) {
//        let asset = AVURLAsset(url: sourceURL)
//        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
//        
//        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
//        
//        exportSession?.outputURL = outputURL
//        exportSession?.outputFileType = .mp4
//        
//        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
//        exportSession?.timeRange = timeRange
//        
//        exportSession?.exportAsynchronously {
//            guard exportSession?.status == .completed else {
//                print("Export failed: \(exportSession?.error?.localizedDescription ?? "")")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion(outputURL)
//            }
//        }
//    }
//    
//
//    func extractAudioAndPlay(videoURL: URL) {
//        let asset = AVURLAsset(url: videoURL)
//        
//        do {
//            let audioAsset = try asset.audioAsset()
//            audioPlayer = try AVAudioPlayer(contentsOf: audioAsset.url)
//            audioPlayer?.delegate = self
//            
//            if let player = audioPlayer {
//                player.play()
//            }
//        } catch {
//            print("Error extracting audio: \(error.localizedDescription)")
//        }
//    }
//    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            print("Audio playback finished successfully.")
//        } else {
//            print("Audio playback finished with an error.")
//        }
//        
//        // 清理 AVAudioPlayer 对象，准备下一次播放
//        audioPlayer = nil
//    }
//}

//extension AVURLAsset {
//    func audioAsset() throws -> AVURLAsset {
//        let composition = AVMutableComposition()
//        
//        do {
//            if let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
//                if let assetTrack = tracks(withMediaType: .audio).first {
//                    try audioTrack.insertTimeRange(assetTrack.timeRange, of: assetTrack, at: .zero)
//                }
//            }
//        } catch {
//            throw error
//        }
//        
//        return AVURLAsset(url: composition.exportToURL())
//    }
//}

//extension AVMutableComposition {
//    func exportToURL() -> URL {
//        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
//        
//        if let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetAppleM4A) {
//            exportSession.outputURL = outputURL
//            exportSession.outputFileType = .m4a
//            
//            exportSession.exportAsynchronously {
//                if exportSession.status == .completed {
//                    print("Export completed")
//                } else if let error = exportSession.error {
//                    print("Export failed: \(error.localizedDescription)")
//                }
//            }
//        }
//        
//        return outputURL
//    }
//}


import UIKit
import MobileCoreServices
import AVFoundation

class CombineViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, AVAudioPlayerDelegate {
    var selectedVideoURL: URL?
    var audioPlayer: AVAudioPlayer?
    
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
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[.mediaURL] as? URL {
            selectedVideoURL = videoURL
            dismiss(animated: true, completion: nil)
            
            // 提取音频并播放
            extractAudioAndPlay(videoURL: videoURL)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func extractAudioAndPlay(videoURL: URL) {
        let asset = AVURLAsset(url: videoURL)
        
        do {
            let audioAsset = try asset.audioAsset()
            audioPlayer = try AVAudioPlayer(contentsOf: audioAsset.url)
            audioPlayer?.delegate = self
            
            if let player = audioPlayer {
                player.play()
            }
        } catch {
            print("Error extracting audio: \(error.localizedDescription)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Audio playback finished successfully.")
        } else {
            print("Audio playback finished with an error.")
        }
        
        // 清理 AVAudioPlayer 对象，准备下一次播放
        audioPlayer = nil
    }
}

extension AVURLAsset {
    func audioAsset() throws -> AVURLAsset {
        let composition = AVMutableComposition()
        
        do {
            if let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
                if let assetTrack = tracks(withMediaType: .audio).first {
                    try audioTrack.insertTimeRange(assetTrack.timeRange, of: assetTrack, at: .zero)
                }
            }
        } catch {
            throw error
        }
        
        return AVURLAsset(url: composition.exportToURL())
    }
}

extension AVMutableComposition {
    func exportToURL() -> URL {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
        
        if let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetAppleM4A) {
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .m4a
            
            exportSession.exportAsynchronously {
                if exportSession.status == .completed {
                    print("Export completed")
                } else if let error = exportSession.error {
                    print("Export failed: \(error.localizedDescription)")
                }
            }
        }
        
        return outputURL
    }
}

