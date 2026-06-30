import ImageIO
import UIKit
import XCTest
@testable import YYUIKit

final class UIImageExtensionsTests: XCTestCase {
    func testImageWithColorCreatesExpectedSizeAndPixelColor() throws {
        let image = UIImage.image(withColor: .red, size: CGSize(width: 4, height: 3))

        XCTAssertEqual(image.size, CGSize(width: 4, height: 3))
        let color = try XCTUnwrap(image.xy_pixelColor(at: CGPoint(x: 1, y: 1)))
        XCTAssertEqual(color.red, 1, accuracy: 0.01)
        XCTAssertEqual(color.green, 0, accuracy: 0.01)
        XCTAssertEqual(color.blue, 0, accuracy: 0.01)
        XCTAssertEqual(color.alpha, 1, accuracy: 0.01)
    }

    func testImageAspectFlagsAndTargetSize() {
        let landscape = UIImage.image(withColor: .red, size: CGSize(width: 120, height: 60))
        let portrait = UIImage.image(withColor: .red, size: CGSize(width: 60, height: 120))
        let square = UIImage.image(withColor: .red, size: CGSize(width: 80, height: 80))
        let small = UIImage.image(withColor: .red, size: CGSize(width: 30, height: 20))

        XCTAssertTrue(landscape.isLandscape)
        XCTAssertFalse(landscape.isPortrait)
        XCTAssertEqual(landscape.imageSize(with: 60), CGSize(width: 60, height: 30))

        XCTAssertTrue(portrait.isPortrait)
        XCTAssertFalse(portrait.isLandscape)
        XCTAssertEqual(portrait.imageSize(with: 60), CGSize(width: 30, height: 60))

        XCTAssertTrue(square.isSquare)
        XCTAssertEqual(square.imageSize(with: 40), CGSize(width: 40, height: 40))
        XCTAssertEqual(small.imageSize(with: 60), CGSize(width: 60, height: 40))
        XCTAssertEqual(small.imageSize(with: 0), .zero)
    }

    func testCropUsesImageScale() throws {
        let image = UIImage.xy_testImage(
            size: CGSize(width: 4, height: 2),
            scale: 2,
            pixels: (0..<32).map { index in
                index % 8 < 4 ? .red : .green
            }
        )

        let cropped = try XCTUnwrap(image.crop(toRect: CGRect(x: 2, y: 0, width: 2, height: 2)))

        XCTAssertEqual(cropped.size, CGSize(width: 2, height: 2))
        let color = try XCTUnwrap(cropped.xy_pixelColor(at: CGPoint(x: 0, y: 0)))
        XCTAssertEqual(color.green, 1, accuracy: 0.01)
    }

    func testScaleToSizeAndCompression() throws {
        let image = UIImage.image(withColor: .blue, size: CGSize(width: 80, height: 40))

        let scaled = try XCTUnwrap(image.scaleToSize(CGSize(width: 20, height: 10)))

        XCTAssertEqual(scaled.size, CGSize(width: 20, height: 10))
        XCTAssertNotNil(image.compressTo(targetMemory: 20_000))
        XCTAssertNotNil(image.compressTo(targetMemory: 20_000, targetMaxWH: 20))
    }

    func testRotateUsesRequestedOrientation() throws {
        let image = UIImage.xy_testImage(
            size: CGSize(width: 2, height: 1),
            scale: 1,
            pixels: [
                .red,
                .green
            ]
        )

        let rotatedRight = image.xy_rotate(orientation: .right)

        XCTAssertEqual(rotatedRight.size.width, 1, accuracy: 0.01)
        XCTAssertEqual(rotatedRight.size.height, 2, accuracy: 0.01)
        try rotatedRight.xy_assertPixelColor(at: CGPoint(x: 0, y: 0), equals: .red)
        try rotatedRight.xy_assertPixelColor(at: CGPoint(x: 0, y: 1), equals: .green)

        let rotatedLeft = image.xy_rotate(orientation: .left)

        XCTAssertEqual(rotatedLeft.size.width, 1, accuracy: 0.01)
        XCTAssertEqual(rotatedLeft.size.height, 2, accuracy: 0.01)
        try rotatedLeft.xy_assertPixelColor(at: CGPoint(x: 0, y: 0), equals: .green)
        try rotatedLeft.xy_assertPixelColor(at: CGPoint(x: 0, y: 1), equals: .red)
    }

    func testFixOrientationReturnsUprightImage() {
        let image = UIImage(
            cgImage: UIImage.image(withColor: .red, size: CGSize(width: 4, height: 2)).cgImage!,
            scale: 1,
            orientation: .right
        )

        let fixed = image.xy_fixOrientation()

        XCTAssertEqual(fixed.imageOrientation, .up)
    }

    @available(iOS 14.0, *)
    func testCreateGIFWritesAnimatedImage() throws {
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("yyuikit-\(UUID().uuidString).gif")
        defer {
            try? FileManager.default.removeItem(at: outputURL)
        }

        try UIImage.createGIF(
            with: [
                UIImage.image(withColor: .red, size: CGSize(width: 2, height: 2)),
                UIImage.image(withColor: .blue, size: CGSize(width: 2, height: 2))
            ],
            outputUrl: outputURL
        )

        let data = try Data(contentsOf: outputURL)
        let source = try XCTUnwrap(CGImageSourceCreateWithData(data as CFData, nil))
        XCTAssertEqual(CGImageSourceGetCount(source), 2)
    }

    @available(iOS 14.0, *)
    func testCreateGIFThrowsWhenFrameHasNoCGImage() {
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("yyuikit-\(UUID().uuidString).gif")
        defer {
            try? FileManager.default.removeItem(at: outputURL)
        }

        let invalidFrame = UIImage(ciImage: CIImage(color: .red))

        XCTAssertThrowsError(
            try UIImage.createGIF(
                with: [
                    invalidFrame,
                    UIImage.image(withColor: .blue, size: CGSize(width: 2, height: 2))
                ],
                outputUrl: outputURL
            )
        )
    }
}

private extension UIImage {
    static func xy_testImage(size: CGSize, scale: CGFloat, pixels: [UIColor]) -> UIImage {
        let width = Int(size.width * scale)
        let height = Int(size.height * scale)
        precondition(pixels.count == width * height)

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        var data = [UInt8](repeating: 0, count: height * bytesPerRow)

        for index in pixels.indices {
            let rgba = pixels[index].getRGBA()
            let offset = index * bytesPerPixel
            data[offset] = UInt8(rgba.red * 255)
            data[offset + 1] = UInt8(rgba.green * 255)
            data[offset + 2] = UInt8(rgba.blue * 255)
            data[offset + 3] = UInt8(rgba.alpha * 255)
        }

        let provider = CGDataProvider(data: Data(data) as CFData)!
        let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )!

        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }

    func xy_pixelColor(at point: CGPoint) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let cgImage else { return nil }

        let scale = self.scale
        let x = Int(point.x * scale)
        let y = Int(point.y * scale)
        guard x >= 0, y >= 0, x < cgImage.width, y < cgImage.height else { return nil }

        let bytesPerPixel = 4
        let bytesPerRow = cgImage.width * bytesPerPixel
        var data = [UInt8](repeating: 0, count: cgImage.height * bytesPerRow)

        guard let context = CGContext(
            data: &data,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))

        let offset = y * bytesPerRow + x * bytesPerPixel
        return (
            red: CGFloat(data[offset]) / 255,
            green: CGFloat(data[offset + 1]) / 255,
            blue: CGFloat(data[offset + 2]) / 255,
            alpha: CGFloat(data[offset + 3]) / 255
        )
    }

    func xy_assertPixelColor(
        at point: CGPoint,
        equals expectedColor: UIColor,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let actual = try XCTUnwrap(xy_pixelColor(at: point), file: file, line: line)
        let expected = expectedColor.getRGBA()

        XCTAssertEqual(actual.red, expected.red, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(actual.green, expected.green, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(actual.blue, expected.blue, accuracy: 0.01, file: file, line: line)
        XCTAssertEqual(actual.alpha, expected.alpha, accuracy: 0.01, file: file, line: line)
    }
}
