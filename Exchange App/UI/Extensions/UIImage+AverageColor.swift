//
//  UIImage+AverageColor.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension Array where Element: UIImage {
    static func framesWithPrefix(_ prefix: String, firstFrame: Int = 1, multiply: [Int: Int]) -> [UIImage] {
        var images = [UIImage]()
        var frameIndex = firstFrame
        while let frame = UIImage(named: "\(prefix)\(frameIndex)") {
            if let multiplier = multiply[frameIndex] {
                for _ in 1...multiplier {
                    images.append(frame)
                }
            } else {
                images.append(frame)
            }
            frameIndex += 1
        }
        return images
    }
}
