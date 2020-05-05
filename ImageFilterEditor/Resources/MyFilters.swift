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


let distortionFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CIBumpDistortion")!, center: .zero, radius: 200, scale: 1)

let circleSplashFilter: CustomFilter = CustomFilter(filterType: CIFilter(name: "CICircleSplashDistortion")!, center: .zero, radius: 200)
