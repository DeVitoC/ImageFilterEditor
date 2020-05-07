//
//  AudioCommentTableViewCell.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/5/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVFoundation

class AudioCommentTableViewCell: UITableViewCell {
    // MARK: - Properties
    var audioComment: AudioComment? {
        didSet {
            setViews()
        }
    }
    var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
        }
    }
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    var timer: Timer?
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var playbackSliderStackView: UIStackView!
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: Any) {
        if isPlaying {
            pause()
            playbackSliderStackView.isHidden = true
        } else {
            play()
            playbackSliderStackView.isHidden = false
        }
    }
    @IBAction func playbackSliderDragged(_ sender: Any) {
        if isPlaying {
            pause()
        }
        
        audioPlayer?.currentTime = TimeInterval(playbackSlider.value)
        updateViews()
    }
    
    // MARK: - View Methods
    func setViews() {
        guard let audioComment = audioComment else { return }
        authorLabel.text = audioComment.author
        playbackSliderStackView.isHidden = true
        currentTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: currentTimeLabel.font.pointSize,
                                                                 weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)
        loadAudio()
    }
    
    func updateViews() {
        playButton.isSelected = isPlaying
        
        let currentTime = audioPlayer?.currentTime ?? 0.0
        let duration = audioPlayer?.duration ?? 0.0
        let timeRemaining = round(duration) - currentTime
        currentTimeLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
        timeRemainingLabel.text = "-" + (timeIntervalFormatter.string(from: timeRemaining) ?? "00:00")
        
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(duration)
        playbackSlider.value = Float(currentTime)
    }
    
    deinit {
        cancelTimer()
    }
    
    // MARK: - Action Methods
    func loadAudio() {
        guard let commentURL = audioComment?.recording else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: commentURL)
    }
    
    func play() {
        audioPlayer?.play()
        startTimer()
        updateViews()
    }
    
    func pause() {
        audioPlayer?.pause()
        updateViews()
        cancelTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.030, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.updateViews()
        }
    }
        
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension AudioCommentTableViewCell: AVAudioPlayerDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio player error: \(error)")
        }
        updateViews()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateViews()
    }
}
