//
//  XYImageWriter.swift
//  YYUIKit
//
//  Created by will on 2025/3/7.
//

import Foundation
import UIKit
import Photos

@objc class PhotoLibraryManager: NSObject {

    static let shared = PhotoLibraryManager()

    private override init() {}

    enum SaveResult {
        case success
        case failure(Error?)
    }
    
    private var completion: ((SaveResult) -> Void)?

    func saveImageToLibrary(imageData: Data, completion: @escaping (SaveResult) -> Void) {
        // 检查权限
        checkPhotoLibraryAuthorization { authorized in
            if authorized {
                // 保存图片
                self.saveImage(imageData: imageData, completion: completion)
            } else {
                completion(.failure(NSError(domain: "PhotoLibraryManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "相册权限未授权"])))
            }
        }
    }

    private func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
            var status: PHAuthorizationStatus
            if #available(iOS 14, *) {
                status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            } else {
                status = PHPhotoLibrary.authorizationStatus()
            }

            switch status {
            case .authorized:
                completion(true)
            case .notDetermined:
                if #available(iOS 14, *) {
                    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                        DispatchQueue.main.async {
                            completion(status == .authorized)
                        }
                    }
                } else {
                    PHPhotoLibrary.requestAuthorization { status in
                        DispatchQueue.main.async {
                            completion(status == .authorized)
                        }
                    }
                }
            default:
                completion(false)
            }
        }

    private func saveImage(imageData: Data, completion: @escaping (SaveResult) -> Void) {
        // 使用 Photos 框架保存
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(.success)
                } else {
                    completion(.failure(error))
                }
            }
        })
    }

    // 可选：添加 UIImageWriteToSavedPhotosAlbum 方法的封装
    func saveImageToLibrary(image: UIImage, completion: @escaping (SaveResult) -> Void) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            if let error = error {
                self.completion?(.failure(error))
            } else {
                self.completion?(.success)
            }
            self.completion = nil
        }
    }
}
