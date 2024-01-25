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
    
    /// 是否是横图, width > height
    var isLandscape: Bool {
        size.width > size.height
    }
    
    /// 是否是人像模式的图 heiget > width
    var isPortrait: Bool {
        size.width < size.height
    }
    
    /// 是否是正方形的图 width = height
    var isSquare: Bool {
        size.width == size.height
    }
    
    
    /// 将图片等比缩放到指定宽高 Square, 获取等比缩放之后图片最终 Size
    /// - Parameter maxWH: 指定最大范围的宽高
    /// - Returns: 缩放后图片的 size
    func imageSize(with maxWH: CGFloat) -> CGSize {
        let size = size
        let maxWH: CGFloat = maxWH
        var imageSize: CGSize = .init(width: maxWH, height: maxWH)
        
        if isLandscape { // 宽图片
            if size.width > maxWH { // 压缩宽度
                let scale = size.width / maxWH
                let scaleHeight = size.height / scale
                imageSize.width = maxWH
                imageSize.height = scaleHeight
            }
        } else { // 窄图片 / 正方形图
            if size.height > maxWH { // 压缩高度
                let scale = size.height / maxWH
                let scaleWidth = size.width / scale
                imageSize.width = scaleWidth
                imageSize.height = maxWH
            }
        }
        
        return imageSize
    }
    
    /// 将图像缩放到指定大小。
    ///
    /// - Parameter newSize: 目标大小，指定图像将缩放到的大小。
    /// - Returns: 缩放后的图像。如果缩放失败，返回 nil。
    func scaleToSize(_ newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        // 使用渲染器创建新的图像
        let scaledImage = renderer.image { (context) in
            // 在目标大小的矩形中绘制原始图像
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return scaledImage
    }
    
}

public extension UIImage {
    
    /// 修正图片的方向
    /// - Returns: 修正为 UIImage.Orientation.up 的 image
    func xy_fixOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransformIdentity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, Double.pi);
            break;
        case .left, .leftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, Double.pi/2);
            break;
        case .right, .rightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -Double.pi/2);
            break;
        case .up, .upMirrored:
            break;
        @unknown default:
            fatalError()
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case .leftMirrored, .rightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case .up, .down, .left, .right:
            break;
        @unknown default:
            fatalError()
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        var cgBitmapinfo: CGBitmapInfo = .alphaInfoMask
        guard let cgImage = cgImage,
              let colorSpace = cgImage.colorSpace,
              let ctx = CGContext(data: &cgBitmapinfo, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        else { fatalError() }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: .init(x: 0, y: 0, width: size.height, height: size.width), byTiling: false)
            break;
        default:
            ctx.draw(cgImage, in: .init(x: 0, y: 0, width: size.width, height: size.height), byTiling: false)
            break;
        }
        
        let cgimg = ctx.makeImage()
        let img = UIImage(cgImage: cgImage)
        return img
    }
    
    /// 按指定方向旋转图片
    /// - Parameter orientation: 旋转方向
    /// - Returns: 旋转后的图片
    func xy_rotate(orientation: UIImage.Orientation) -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        var bounds = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        var rect = bounds
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .up:
            return self
        case .upMirrored:
            transform = transform.translatedBy(x: rect.size.width, y: 0).scaledBy(x: -1, y: 1)
            break;
        case .down:
            transform = transform.translatedBy(x: rect.size.width, y: rect.size.height).rotated(by: .pi)
            break;
        case .downMirrored:
            transform = transform.translatedBy(x: 0, y: rect.size.height).scaledBy(x: 1, y: -1)
            break;
        case .left:
            bounds = bounds.swapRectWH()
            transform = transform.translatedBy(x: 0, y: rect.size.width).rotated(by: 3 * .pi / 2)
            break;
        case .leftMirrored:
            bounds = bounds.swapRectWH()
            transform = transform.translatedBy(x: rect.size.height, y: rect.size.width).scaledBy(x: -1, y: 1).rotated(by: 3 * .pi / 2)
            break;
        case .right:
            bounds = bounds.swapRectWH()
            transform = transform.translatedBy(x: rect.size.height, y: 0).rotated(by: .pi / 2)
            break;
        case .rightMirrored:
            bounds = bounds.swapRectWH()
            transform = transform.scaledBy(x: -1, y: 1).rotated(by: .pi / 2)
            break;
        default:
            return self;
        }
        
        var newImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return self }
        
        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.scaleBy(x: -1.0, y: 1.0)
            ctx.translateBy(x: -rect.size.height, y: 0.0)
        default:
            ctx.scaleBy(x: 1.0, y: -1.0)
            ctx.translateBy(x: 0.0, y: -rect.size.height)
        }
        
        ctx.concatenate(transform)
        ctx.draw(cgImage, in: rect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    /// 沿Y轴翻转
    /// - Returns: 沿Y轴翻转的图片
    func xy_verticalityMirror() -> UIImage {
        xy_rotate(orientation: .upMirrored)
    }
    
    /// 沿X轴翻转
    /// - Returns: 沿X轴翻转的图片
    func xy_horizontalMirror() -> UIImage {
        xy_rotate(orientation: .downMirrored)
    }
}
