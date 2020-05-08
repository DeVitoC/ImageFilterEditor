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
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("Error converting audio file to data: \(error)")
            completion()
            return
        }
        let comment = AudioComment(author: author, recording: url, audio: data)
        audioComments.append(comment)
        
        //let requestURL = baseURL.appendingPathComponent(comment.identifier).appendingPathExtension("json")
        let requestURL = baseURL.appendingPathComponent("audioComments").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(comment)
        } catch {
            NSLog("Error encoding audio comment to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with audio comment creation data task: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    func fetchAudioComments(completion: @escaping () -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("audioComments").appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching audio comments: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let fetchedComments = try JSONDecoder().decode([String : AudioComment].self, from: data)
                self.audioComments = Array(fetchedComments.values)
            } catch {
                self.audioComments = []
                NSLog("Error decoding audio comments from JSON data: \(error)")
            }
            
            completion()
        }.resume()
    }
}
