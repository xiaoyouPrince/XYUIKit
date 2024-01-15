//
//  UIImage+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/9/26.
//
//  algorithm from: http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29

import Foundation
import Accelerate

public extension UIImage {
    
    /// 给当前 image 设置模糊
    /// - Parameter blur: 模糊系数 0.0~1.0
    /// - Returns: 模糊后的 Image
    @objc func xy_blurImage(_ blur: CGFloat) -> UIImage {
        
        var blur = blur
        if blur < 0.0 || blur > 1.0 {
            blur = 0.5
        }
        
        var boxSize = Int(blur*40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        guard let img = self.cgImage else { return self }
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error: vImage_Error!
        var pixelBuffer: UnsafeMutableRawPointer
        
        // 从CGImage中获取数据
        let inProvider = img.dataProvider
        let inBitmapData = inProvider?.data
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = UInt(img.width)
        inBuffer.height = UInt(img.height)
        inBuffer.rowBytes = img.bytesPerRow
        inBuffer.data = (UnsafeMutableRawPointer)(mutating: CFDataGetBytePtr(inBitmapData))
        pixelBuffer = malloc(img.bytesPerRow * img.height)
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(img.width)
        outBuffer.height = UInt(img.height)
        outBuffer.rowBytes = img.bytesPerRow
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != nil && error != 0 {
            NSLog("error from convolution %ld", error)
            return self
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return self }
        
        let imageRef = ctx.makeImage()!
        let returnImage = UIImage(cgImage: imageRef)
        
        free(pixelBuffer)
        return returnImage
    }
    
    
    /// 通过颜色创建一个 UIImage
    /// - Parameter color: 指定的颜色
    /// - Returns: 返回目标 UIImage
    @objc static func image(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? UIImage()
    }
    
    
    /// 裁剪图片到指定 rect
    /// - Parameter rect: 指定需要裁剪的范围
    /// - Returns: 裁剪之后得到的 image
    func crop(toRect rect: CGRect) -> UIImage? {
        let scale = UIScreen().scale
        let realRect: CGRect = .init(x: rect.minX * scale, y: rect.minY * scale, width: rect.width * scale, height: rect.height * scale)
        
        guard let cgImage = self.cgImage else { return nil }
        guard let croppedCGImage = cgImage.cropping(to: realRect) else { return nil }
        
        let croppedImage = UIImage(cgImage: croppedCGImage)
        return croppedImage
    }
    
}
