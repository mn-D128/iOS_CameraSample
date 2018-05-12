//
//  CMSampleBuffer+UIImage.swift
//  iOSCameraSample
//
//  Created by mn(D128) on 2018/05/13.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

import UIKit
import CoreMedia

extension CMSampleBuffer {
    
    func image(_ degree: CGFloat = 0.0) -> UIImage? {
        guard let pixelBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(self),
            let filter: CIFilter = CIFilter(name: "CIAffineTransform") else {
                return nil
        }
        
        let radians: CGFloat = degree * CGFloat.pi / 180.0
        let centerX: CGFloat = CGFloat(CVPixelBufferGetWidth(pixelBuffer)) / 2.0
        let centerY: CGFloat = CGFloat(CVPixelBufferGetHeight(pixelBuffer)) / 2.0
        
        let ciImage: CIImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        var transform: CGAffineTransform = CGAffineTransform(translationX: centerX,
                                                             y: centerY)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -centerX,
                                           y: -centerY)
        
        filter.setValue(transform, forKey: kCIInputTransformKey)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage: CIImage = filter.outputImage else {
            return nil
        }
        
        let context: CIContext = CIContext(options: nil)
        guard let cgImage: CGImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        let result: UIImage? = UIImage(cgImage: cgImage)
        return result
    }
    
}
