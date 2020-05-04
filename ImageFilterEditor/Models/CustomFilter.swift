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
    
    public func filterImage(_ image: UIImage) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        // setting values / getting values from Core Image
        filterType.setValue(ciImage, forKey: kCIInputImageKey) // "inputImage"
        //filterType.setValue(filterValue, forKey: kCIInputDistortionEffect)

        // Return = CIImage -> CGImage -> UIImage
        guard let outputCIImage = filterType.outputImage else { return nil }
        
        // Render the image (do the image processing here)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        return UIImage(cgImage: outputCGImage)
    }
}
