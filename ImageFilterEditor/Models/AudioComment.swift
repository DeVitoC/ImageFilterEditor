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
    
    init(author: String, recording: URL, identifier: String = UUID().uuidString) {
        self.author = author
        self.recording = recording
        self.identifier = identifier
    }
}
