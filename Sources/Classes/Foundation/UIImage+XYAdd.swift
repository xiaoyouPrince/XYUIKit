//
//  UIImage+XYAdd.swift
//  SwiftLearn
//
//  Created by 渠晓友 on 2021/9/26.
//
//  algorithm from: http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+IndieAmbitions+%28Indie+Ambitions%29

import Foundation
import Accelerate
import UniformTypeIdentifiers
import UIKit

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
    
}

// MARK: - 便捷初始化

public extension UIImage {
    
    /// 通过颜色创建一个 UIImage
    /// - Parameter color: 指定的颜色
    /// - Returns: 返回目标 UIImage
    @objc static func image(withColor color: UIColor) -> UIImage {
        image(withColor: color, size: .init(width: 1, height: 1))
    }
    
    /// 通过颜色创建一个 UIImage
    /// - Parameter color: 指定的颜色
    /// - Parameter size: 指定要生成 image 的尺寸
    /// - Returns: 返回目标 UIImage
    @objc static func image(withColor color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    /// 通过 imageURL 加载网络图片, 异步加载, 主线程回调
    /// - Parameters:
    ///   - imageUrl: 图片地址
    ///   - completeion: 回调, 返回对应图片
    static func image(withURL imageUrl: URL?, completeion: @escaping (UIImage?)->()) {
        if let url = imageUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.safeMain {
                        completeion(image)
                    }
                }else{
                    DispatchQueue.safeMain {
                        completeion(nil)
                    }
                }
            }
        }else{
            DispatchQueue.safeMain {
                completeion(nil)
            }
        }
    }
    
    /// 通过 URLString 加载网络图片, 异步加载, 主线程回调
    /// - Parameters:
    ///   - imageUrl: 图片地址
    ///   - completeion: 回调, 返回对应图片
    static func image(withURLStr urlStr: String, completeion: @escaping (UIImage?)->()) {
        if let url = URL(string: urlStr) {
            image(withURL: url, completeion: completeion)
        }else{
            DispatchQueue.safeMain {
                completeion(nil)
            }
        }
    }
}

// MARK: - 裁剪 & 压缩
public extension UIImage {
    
    /// 裁剪图片到指定 rect,  egg: 截取一张图左上角 50x50 的部分
    /// - Parameter rect: 指定需要裁剪的范围, rect 是以当前图片 bounds 为基准指定
    /// - Returns: 裁剪之后得到的 image
    func crop(toRect rect: CGRect) -> UIImage? {
        let scale = UIScreen().scale
        let realRect: CGRect = .init(x: rect.minX * scale, y: rect.minY * scale, width: rect.width * scale, height: rect.height * scale)
        
        guard let cgImage = self.cgImage else { return nil }
        guard let croppedCGImage = cgImage.cropping(to: realRect) else { return nil }
        
        let croppedImage = UIImage(cgImage: croppedCGImage)
        return croppedImage
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
    
    /// 将图像缩放到指定大小尺寸
    ///
    /// - Parameter newSize: 目标大小，指定图像将缩放到的大小。
    /// - Returns: 缩放后的图像。如果缩放失败，返回 nil。
    func scaleToSize(_ newSize: CGSize) -> UIImage? {
        guard let data = hasAlphaChannel ? pngData() : jpegData(compressionQuality: 1.0),
              let oldImage = UIImage(data: data) else { return nil }
        
        if #available(iOS 10, *) {
            let renderer = UIGraphicsImageRenderer(size: newSize)
            let scaledImage = renderer.image { (context) in
                oldImage.draw(in: CGRect(origin: .zero, size: newSize))
            }
            return scaledImage
        } else {
            UIGraphicsBeginImageContextWithOptions(newSize, !hasAlphaChannel, 0)
            oldImage.draw(in: CGRect(origin: .zero, size: newSize))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    
    /// 图片是否包含 alpha 通道
    var hasAlphaChannel: Bool {
        guard let cgImage = cgImage else { return false }
        switch cgImage.alphaInfo {
        case .none:
            return false
        case .premultipliedLast, .premultipliedFirst, .last, .first:
            return true
        case .noneSkipLast, .noneSkipFirst:
            return false
        case .alphaOnly:
            return true
        @unknown default:
            return false
        }
    }
    
    /// 将图片压缩到指定大小内存, 单位: 字节
    /// - Parameter targetMemory: 指定内存大小，如 1024x1024 是 1MB
    /// - Returns: 压缩后的 data
    func compressTo(targetMemory: Int) -> Data? {
        var compression: CGFloat = 1.0
        var imageData = jpegData(compressionQuality: compression)
        
        while let data = imageData, data.count > targetMemory {
            compression -= 0.1
            imageData = jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    /// 将图像等压缩到指定内存大小, 并等比缩放到指定最大尺寸(尺寸单位是点, 需要自行换算像素)
    /// - Parameters:
    ///   - targetMemory: 目标内存大小 1024x1024 = 1MB
    ///   - targetMaxWH: 最大尺寸, 内部以 aspectFit 的规则等比缩放图片
    /// - Returns: 最终 data
    func compressTo(targetMemory: Int, targetMaxWH: CGFloat) -> Data? {
        let newSize = imageSize(with: targetMaxWH)
        if size.width < newSize.width { // 无需压缩尺寸
            return compressTo(targetMemory: targetMemory)
        }else{
            let newImage = scaleToSize(newSize)
            return newImage?.compressTo(targetMemory: targetMemory)
        }
    }
}


// MARK: - 方向处理 & 旋转

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
        
        guard let cgimg = ctx.makeImage() else { return self }
        let img = UIImage(cgImage: cgimg)
        return img
    }
    
    /// 按指定方向旋转图片
    /// - Parameter orientation: 旋转方向
    /// - Returns: 旋转后的图片
    func xy_rotate(orientation: UIImage.Orientation) -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        var bounds = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        let rect = bounds
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


public extension UIImage {
    
    /// 通过 image 数组创建 gif 图
    /// - Parameters:
    ///   - images: 原始images数组
    ///   - outputUrl: 最终输出的 gif URL， 请自己设置好后缀名，egg: file://animation.gif
    @available(iOS 14.0, *)
    static func createGIF(with images: [UIImage], outputUrl: URL) throws {
        if images.count > 1 {
            let gifProperties = [
                kCGImagePropertyGIFDictionary: [
                    kCGImagePropertyGIFLoopCount: 0, // 设置循环次数，0表示无限循环
                    kCGImagePropertyGIFDelayTime: 0.1 // 设置帧间隔时间
                ]
            ]

            let frames = images
            let gifURL = outputUrl

            guard let destination = CGImageDestinationCreateWithURL(gifURL as CFURL, UTType.gif.identifier as CFString/*kUTTypeGIF*/, frames.count, nil) else {
                // 创建CGImageDestination失败的处理逻辑
                throw NSError(domain: "yyuikit.uiimage.createGIF", code: -1)
            }

            for frame in frames {
                CGImageDestinationAddImage(destination, frame.cgImage!, gifProperties as CFDictionary)
            }

            CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)

            if !CGImageDestinationFinalize(destination) {
                // 保存gif图像数据失败的处理逻辑
                throw NSError(domain: "yyuikit.uiimage.createGIF", code: -1)
            }
            
            let imageData = try! Data(contentsOf: gifURL)
            try? imageData.write(to: gifURL)
        }
    }
}
