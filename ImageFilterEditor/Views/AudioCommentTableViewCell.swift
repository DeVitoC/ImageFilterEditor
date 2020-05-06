//
//  AudioCommentTableViewCell.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/5/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class AudioCommentTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var playbackSliderStackView: UIStackView!
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: Any) {
    }
    @IBAction func playbackSliderDragged(_ sender: Any) {
    }
    
    // MARK: - View Methods
    
    // MARK: - Action Methods

}
