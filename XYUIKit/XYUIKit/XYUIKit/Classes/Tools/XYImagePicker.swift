//
//  XYImagePicker.swift
//  YYUIKit
//
//  Created by 渠晓友 on 2024/1/19.
//

import Foundation
import UIKit

class XYImagePicker: UIViewController {
    static let shared: XYImagePicker = .init()
    private init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var imageCallback: ((UIImage)->())?
    private var movieCallback: ((Data)->())?
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
    
    static func takeVideo(_ callback: @escaping (Data)->()) {
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
}

extension XYImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        XYImagePicker.shared.ps?.dismiss(animated: true)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            XYImagePicker.shared.imageCallback?(image)
        }else 
        if let movieUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
           let data = try? Data(contentsOf: movieUrl) {
            XYImagePicker.shared.movieCallback?(data)
        }else{
            Toast.make("an error occurred")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        XYImagePicker.shared.ps?.dismiss(animated: true)
    }
}
