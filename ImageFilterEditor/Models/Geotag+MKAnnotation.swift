//
//  Geotag+MKAnnotation.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/7/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import MapKit

extension Geotag: MKAnnotation {
    var  coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
