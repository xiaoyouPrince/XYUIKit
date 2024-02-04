//
//  XYMediaPlayer.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/30.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class XYMediaPlayer: UIViewController {
    static let shared: XYMediaPlayer = .init()
    private var audioPlayer: AVAudioPlayer?
    private init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func playAudio(data: Data) {
        let audioData = data
        shared.audioPlayer = try? AVAudioPlayer(data: audioData)
        shared.audioPlayer?.volume = 1.0
        shared.audioPlayer?.prepareToPlay()
        shared.audioPlayer?.play()
    }

    @objc public static func playVideo(url: URL) {
        DispatchQueue.safeMain {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            UIApplication.shared.getKeyWindow()?.rootViewController?.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }
}
