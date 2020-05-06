//
//  NetworkController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation

class NetworkController {
    let baseURL = URL(string: "https://lambdatimeline-9654e.firebaseio.com/")!
    var audioComments: [AudioComment] = []
    
    func createAudioComment(by author: String, storedAt url: URL, completion: @escaping () -> Void) {
        
        let comment = AudioComment(author: author, recording: url)
        
        audioComments.append(comment)
        
        let requestURL = baseURL.appendingPathComponent(comment.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(comment)
        } catch {
            NSLog("Error encoding audio comment to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
}
