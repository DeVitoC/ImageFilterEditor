//
//  GeotagDetailView.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/7/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class GeotagMarkerView: UIView {
    
    var geotag: Geotag? {
        didSet {
            updateSubviews()
        }
    }
    
    private let dateLabel = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
    
    private lazy var latlonFormatter: NumberFormatter = {
        let result = NumberFormatter()
        result.numberStyle = .decimal
        result.minimumIntegerDigits = 1
        result.minimumFractionDigits = 2
        result.maximumFractionDigits = 2
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        latitudeLabel.setContentHuggingPriority(.defaultLow+1, for: .horizontal)
        
        let latlonStackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        latlonStackView.spacing = UIStackView.spacingUseSystem
        latlonStackView.axis = .horizontal
        let mainStackView = UIStackView(arrangedSubviews: [dateLabel, latlonStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func updateSubviews() {
        guard let geotag = geotag else { return }
        dateLabel.text = dateFormatter.string(from: geotag.time)
        latitudeLabel.text = "Lat: " + latlonFormatter.string(from: geotag.latitude as NSNumber)!
        longitudeLabel.text = "Lon: " + latlonFormatter.string(from: geotag.longitude as NSNumber)!
    }
}
