//
//  Geotag.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/7/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import MapKit

class Geotag: NSObject, Codable {
    let latitude: Double
    let longitude: Double
    let time: Date
    
    internal init(latitude: Double, longitude: Double, time: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
    }
}