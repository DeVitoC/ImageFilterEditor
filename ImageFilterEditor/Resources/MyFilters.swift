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


let distortionFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CIBumpDistortion")!, name: "Bump", center: .zero, radius: 200, scale: 1, angle: nil, intensity: nil)

let circleSplashFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CICircleSplashDistortion")!, name: "Circle Splash", center: .zero, radius: 200, scale: nil, angle: nil, intensity: nil)

let circularWrapDistortion: CustomFilter = CustomFilter(filterType: CIFilter(name: "CICircularWrap")!, name: "Circular Wrap", center: .zero, radius: 0.001, scale: nil, angle: 0.00, intensity: nil)

let bloom: CustomFilter = CustomFilter(filterType: CIFilter(name: "CIBloom")!, name: "Bloom", center: nil, radius: 200, scale: nil, angle: nil, intensity: 0.5)

let straightenFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CIStraightenFilter")!, name: "Straighten", center: nil, radius: nil, scale: nil, angle: 0.00, intensity: nil)


