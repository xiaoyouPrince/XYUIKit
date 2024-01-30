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
        
        shared.imageCallback = callback
        shared.ps = ps
        currentVisibleVC.present(ps, animated: true)
    }
    
    static func takePhoto(_ callback: @escaping (UIImage)->()) {
        let ps = UIImagePickerController()
        ps.sourceType = .camera
        ps.delegate = shared
        ps.cameraDevice = .rear
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
        shared.movieCallback = callback
        shared.ps = ps
        currentVisibleVC.present(ps, animated: true)
    }
    
    @objc public static func chooseAudioFromVideo(callback: @escaping (URL)->()) {
        chooseVideo { videoUrl in
            let asset = AVURLAsset(url: videoUrl)
            let audioUrl = XYFileManager.rootURL!.appendingPathComponent( UUID().uuidString + ".caf")
            
            asset.writeAudioTrack(to: audioUrl) {
                callback(audioUrl)
            } failure: { error in
                Toast.make(error.localizedDescription)
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


fileprivate extension AVAsset {
    
    func writeAudioTrack(to url: URL,
                         success: @escaping () -> (),
                         failure: @escaping (Error) -> ()) {
        do {
            let asset = try audioAsset()
            asset.write(to: url, success: success, failure: failure)
        } catch {
            failure(error)
        }
    }
    
    private func write(to url: URL,
                       success: @escaping () -> (),
                       failure: @escaping (Error) -> ()) {
        try? FileManager().removeItem(at: url)
        
        // Create an export session that will output an
        // audio track (CAF file)
        guard let exportSession = AVAssetExportSession(asset: self,
                                                       presetName: AVAssetExportPresetPassthrough) else {
            // This is just a generic error
            let error = NSError(domain: "domain",
                                code: 0,
                                userInfo: nil)
            failure(error)
            
            return
        }
        
        exportSession.outputFileType = .caf
        exportSession.outputURL = url
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                success()
            default:
                let error = NSError(domain: "domain", code: 0, userInfo: nil)
                failure(error)
                break
            }
        }
        
    }
    
    private func audioAsset() throws -> AVAsset {
        let composition = AVMutableComposition()
        let audioTracks = tracks(withMediaType: .audio)
        
        for track in audioTracks {
            let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try compositionTrack?.insertTimeRange(track.timeRange, of: track, at: track.timeRange.start)
            compositionTrack?.preferredTransform = track.preferredTransform
        }
        return composition
    }
}

