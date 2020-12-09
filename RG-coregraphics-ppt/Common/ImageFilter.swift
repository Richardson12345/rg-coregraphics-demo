//
//  ImageFilter.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 07/12/20.
//

import UIKit

typealias mapPointPercentage = (CGFloat, CGFloat)

public class ImageFilter {
    
    public enum Filter {
        case increaseContrast
        case grayscale
    }
    
    func applyFilter(_ filter: Filter, to image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // Redraw image for correct pixel format
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        var bytesPerRow = width * 4
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        // create the input image context
        guard let imageContext = CGContext(
            data: imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        let pixelArea = width * height
        // get pixel rgb data for increase contrast
        
        for y in 0..<height { // 0 - 788
            for x in 0..<width { // 0 - 1583
                let index = y * width + x // 0 - 1249776
                let pixel = pixels[index]
                
                //                print("check the pixel \(pixel.red)")
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let avgRed = totalRed / pixelArea
        let avgGreen = totalGreen / pixelArea
        let avgBlue = totalBlue / pixelArea
        
        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                var pixel = pixels[index]
                
                let redDelta = Int(pixel.red) - avgRed
                let greenDelta = Int(pixel.green) - avgGreen
                let blueDelta = Int(pixel.blue) - avgBlue
                
                switch filter {
                case .increaseContrast:
                    // formula for increase contrast
                    pixel.red = UInt8(max(min(255, avgRed + 2 * redDelta), 0))
                    pixel.blue = UInt8(max(min(255, avgBlue + 2 * blueDelta), 0))
                    pixel.green = UInt8(max(min(255, avgGreen + 2 * greenDelta), 0))
                case .grayscale:
                    // formula for grayscale
                    let avg = Int(Double(Int(pixel.red) + Int(pixel.blue) + Int(pixel.green))/3.0)
                    let pixelColor = UInt8(avg)
                    pixel.red = pixelColor
                    pixel.blue = pixelColor
                    pixel.green = pixelColor
                }
                
                pixels[index] = pixel
            }
        }
        
        colorSpace = CGColorSpaceCreateDeviceRGB()
        bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        bytesPerRow = width * 4
        
        // create filtered image context
        guard let context = CGContext(
            data: pixels.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else { return nil }
        
        guard let newCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
    
    func addGhost(to image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let bytesPerRow = width * 4
        
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        // create original image context
        guard let imageContext = CGContext(
            data: imageData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        let ghostImage = UIImage(named: "ghost")!
        guard let ghostCGImage = ghostImage.cgImage else { return nil }
        
        // determine ghost size and placement
        let ghostImageAspectRatio = ghostImage.size.width / ghostImage.size.height
        let targetGhostWidth = CGFloat(width) * 0.25
        let ghostWidth = Int(targetGhostWidth)
        let ghostHeight = Int(targetGhostWidth / ghostImageAspectRatio)
        
        let ghostOrigin = CGPoint(x: CGFloat(width) * 0.5, y: CGFloat(height) * 0.2)
        
        let bytesPerPixel = 4;
        let bitsPerComponent = 8;
        let ghostBytesPerRow = ghostWidth * bytesPerPixel
        
        let ghostPixelData = UnsafeMutablePointer<Pixel>.allocate(capacity: ghostWidth * ghostHeight)
        
        // create ghost image context
        guard let ghostContext = CGContext(data: ghostPixelData, width: ghostWidth, height: ghostHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: ghostBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        
        ghostContext.draw(ghostCGImage, in: .init(x: 0, y: 0, width: ghostWidth, height: ghostHeight))
        
        let ghostPixels = UnsafeMutableBufferPointer<Pixel>(start: ghostPixelData, count: ghostWidth * ghostHeight)
        
        let offsetPixelCountForInput = Int(ghostOrigin.y) * width + Int(ghostOrigin.x)
        
        // read through ghost context width * height and overwrite input image pixel with ghost image pixel
        for y in 0..<Int(ghostHeight) { // loop time: ghostHeight * ghostWidth
            for x in 0..<Int((ghostWidth)) {
                let pixelOffset: Int = y * width + x + offsetPixelCountForInput
                var toModifyPixelColor: Pixel = pixels[pixelOffset]
                
                let ghostPixelOffset: Int = y * ghostWidth + x
                let ghostPixelColor: Pixel = ghostPixels[ghostPixelOffset]
                
                toModifyPixelColor.red = ghostPixelColor.alpha < UInt8(15) ? toModifyPixelColor.red : ghostPixelColor.red
                toModifyPixelColor.blue = ghostPixelColor.alpha < UInt8(15) ? toModifyPixelColor.blue : ghostPixelColor.blue
                toModifyPixelColor.green = ghostPixelColor.alpha < UInt8(15) ? toModifyPixelColor.green : ghostPixelColor.green
                
                pixels[pixelOffset] = toModifyPixelColor
            }
        }
        
        // create new context with overlayed image
        guard let context = CGContext(
            data: pixels.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else { return nil }
        
        // return new image
        guard let newCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
}

public struct Pixel {
    public var value: UInt32
    
    public var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        } set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }
    
    public var green: UInt8 {
        get {
            return UInt8((value >> 8) & 0xFF)
        } set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }
    
    public var blue: UInt8 {
        get {
            return UInt8((value >> 16) & 0xFF)
        } set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }
    
    public var alpha: UInt8 {
        get {
            return UInt8((value >> 24) & 0xFF)
        } set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
}

/* Faulty previous logic
 let offsetPixelCountForInput = (Int(ghostOrigin.y) * width) + Int(ghostOrigin.x)
 
 for y in 0..<Int(ghostHeight) {
 for x in 0..<Int((ghostWidth)) {
 let pixelOffset: Int = offsetPixelCountForInput + (y * ghostWidth) + x
 let ghostPixelOffset: Int = (y * ghostWidth) + x
 
 var toModifyPixelColor: Pixel = pixels[pixelOffset]
 let ghostPixelColor: Pixel = ghostPixels[ghostPixelOffset]
 
 let ghostAlpha = 0.5 * (Float(ghostPixelColor.alpha) / 255)
 let newRed = (Float(toModifyPixelColor.red) * (1 - ghostAlpha)) + (Float(ghostPixelColor.red) * ghostAlpha)
 let newGreen = (Float(toModifyPixelColor.green) * (1 - ghostAlpha)) + (Float(ghostPixelColor.green) * ghostAlpha)
 let newBlue = (Float(toModifyPixelColor.blue) * (1 - ghostAlpha)) + (Float(ghostPixelColor.blue) * ghostAlpha)
 
 toModifyPixelColor.red =  UInt8(newRed)
 toModifyPixelColor.blue = UInt8(newGreen)
 toModifyPixelColor.green = UInt8(newBlue)
 
 pixels[pixelOffset] = toModifyPixelColor
 }
 }
 
 // Blend the ghost with 50% alpha
 CGFloat ghostAlpha = 0.5f * (A(ghostColor) / 255.0);
 UInt32 newR = R(inputColor) * (1 - ghostAlpha) + R(ghostColor) * ghostAlpha;
 UInt32 newG = G(inputColor) * (1 - ghostAlpha) + G(ghostColor) * ghostAlpha;
 UInt32 newB = B(inputColor) * (1 - ghostAlpha) + B(ghostColor) * ghostAlpha;
 */
