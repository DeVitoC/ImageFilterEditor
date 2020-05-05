//
//  MyFilters.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/4/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins


let distortionFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CIBumpDistortion")!, center: .zero, radius: 200, scale: 1, angle: nil)

let circleSplashFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CICircleSplashDistortion")!, center: .zero, radius: 200, scale: nil, angle: nil)

let circularWrapDistortion: CustomFilter = CustomFilter(filterType: CIFilter(name: "CICircularWrap")!, center: .zero, radius: 0.001, scale: nil, angle: 0.00)

//let bloom: CustomFilter = CustomFilter(filterType: CIFilter(name: "CIBloom"), center: nil, radius: <#T##CGFloat?#>, scale: <#T##CGFloat?#>, angle: <#T##NSNumber?#>)
