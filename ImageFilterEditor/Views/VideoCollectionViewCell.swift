//
//  VideoCollectionViewCell.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var videoPost: VideoPost? {
        didSet {
            setView()
        }
    }
    var videoController: VideoPostController?
    var videoURL: URL?
    
    private var player: AVPlayer!
    //private let playerView = VideoPlayerView
    var videoLooper: AVPlayerLooper?
    
    // MARK: - IBOutlets
    @IBOutlet var videoView: VideoPlayerView!
    @IBOutlet weak var titleAndArtistLabel: UILabel!
    
    // MARK: - View Methods
    func setView() {
        guard let videoPost = videoPost else { return }
        titleAndArtistLabel.text = "\(videoPost.author) by \(videoPost.author)"
        videoView = VideoPlayerView()
        playMovie()
    }
    
    private func playMovie() {
        var videoID: String
        guard let videoController = videoController, let videoPost = videoPost else { return }
        for entry in videoController.videoPostsDict where entry.value.identifier == videoPost.identifier {
            videoID = entry.key
            videoURL = videoController.baseURL.appendingPathComponent("videoPosts").appendingPathComponent(videoID).appendingPathExtension("json")
        }
        guard let videoURL = videoURL else { return }
        
        let asset = AVAsset(url: videoURL)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer(playerItem: item)
        videoView.player = player
        
        videoLooper = AVPlayerLooper(player: player, templateItem: item)
        player.play()
    }
}
