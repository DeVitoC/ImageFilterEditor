//
//  Filter.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/4/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

struct CustomFilter {
    var filterType: CIFilter
    let context = CIContext(options: nil)
    var center: CGPoint?
    var radius: CGFloat?
    var scale: CGFloat?
    
    public mutating func filterImage(_ image: UIImage, filterValue: CGFloat? = nil, centerPoint: CGPoint = .zero, radius: CGFloat = 100) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        if centerPoint == .zero {
            center = CGPoint(x: image.size.width/2.0, y: image.size.height/2.0)
        } else {
            center = centerPoint
        }
        
        // setting values / getting values from Core Image
        filterType.setValue(ciImage, forKey: kCIInputImageKey) // "inputImage"
        if scale != nil {
            filterType.setValue(filterValue, forKey: kCIInputScaleKey)
        }
        if let center = center {
            filterType.setValue(CIVector(cgPoint: center), forKey: "inputCenter")
        }
        filterType.setValue(radius, forKey: "inputRadius")

        // Return = CIImage -> CGImage -> UIImage
        guard let outputCIImage = filterType.outputImage else { return nil }
        
        // Render the image (do the image processing here)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        return UIImage(cgImage: outputCGImage)
    }
}
