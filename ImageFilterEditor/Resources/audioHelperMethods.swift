//
//  audioHelperMethods.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/5/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation

var timeIntervalFormatter: DateComponentsFormatter = {
    // NOTE: DateComponentFormatter is good for minutes/hours/seconds
    // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
    
    let formatting = DateComponentsFormatter()
    formatting.unitsStyle = .positional // 00:00  mm:ss
    formatting.zeroFormattingBehavior = .pad
    formatting.allowedUnits = [.minute, .second]
    return formatting
}()


