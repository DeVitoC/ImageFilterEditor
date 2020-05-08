//
//  VideoPost.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation

struct VideoPost: Codable {
    var author: String
    var video: Data
    var audioComment: AudioComment?
    var geotag: Geotag
    var identifier: String
    var videoURL: URL
    
    init(author: String, video: Data, audioComment: AudioComment? = nil, geotag: Geotag, videoURL: URL, identifier: String = UUID().uuidString) {
        self.author = author
        self.video = video
        self.audioComment = audioComment
        self.videoURL = videoURL
        self.identifier = identifier
        self.geotag = geotag
    }
    
    enum CodingKeys: String, CodingKey {
        case author
        case video
        case audioComment
        case videoURL
        case identifier
        case geotag
    }
}
