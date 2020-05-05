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
    var angle: NSNumber?
    
    public mutating func filterImage(_ image: UIImage, filterValue: CGFloat? = nil, centerPoint: CGPoint? = .zero, radius: CGFloat? = nil, angle: NSNumber? = nil) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Set input image
        filterType.setValue(ciImage, forKey: kCIInputImageKey) // "inputImage"
        
        // Set Scale if filter has scale
        if scale != nil {
            filterType.setValue(filterValue, forKey: kCIInputScaleKey)
        }
        
        // Set center
        if center != nil {
            filterType.setValue(CIVector(cgPoint: centerPoint!), forKey: "inputCenter")
        }
        
        // Set Radius if filter has radius
        if self.radius != nil {
            filterType.setValue(radius, forKey: "inputRadius")
        }
        
        // Set Angle if filter has angle
        if self.angle != nil {
            filterType.setValue(angle, forKey: "inputAngle")
        }
        
        // Return = CIImage -> CGImage -> UIImage
        guard let outputCIImage = filterType.outputImage else { return nil }
        
        // Render the image (do the image processing here)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        return UIImage(cgImage: outputCGImage)
    }
}
