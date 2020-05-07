//
//  AudioComment.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/5/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioComment: Codable {
    var author: String
    var recording: URL
    var identifier: String
    var audio: Data
    
    init(author: String, recording: URL, audio: Data, identifier: String = UUID().uuidString) {
        self.author = author
        self.recording = recording
        self.audio = audio
        self.identifier = identifier
    }
    
    enum CodingKeys: String, CodingKey {
        case author
        case recording
        case identifier
        case audio
    }
}
