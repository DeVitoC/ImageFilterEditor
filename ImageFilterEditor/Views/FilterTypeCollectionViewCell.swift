//
//  FilterTypeCollectionViewCell.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/4/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class FilterTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            setView()
        }
    }
    var filter: CustomFilter?
    
    // MARK: - IBOutlets
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var imageTypeLabel: UILabel!
    
    func setView() {
        filterImageView.image = image
        imageTypeLabel.text = filter?.name
    }
}
