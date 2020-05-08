//
//  VideoPostController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import AVFoundation

class VideoPostController {
    var videoPosts: [VideoPost] = []
    var videoPostsDict: [String : VideoPost] = [:]
    let baseURL = URL(string: "https://lambdatimeline-9654e.firebaseio.com/")!
    
    func createVideoPost(by author: String, storedAt url: URL, completion: @escaping () -> Void) {
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("Error converting video post file to data: \(error)")
            completion()
            return
        }
        let videoPost = VideoPost(author: author, video: data, geotag: geotag, videoURL: url)
        videoPosts.append(videoPost)
        
        let requestURL = baseURL.appendingPathComponent("videoPosts").appendingPathExtension("json")
        //let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(videoPost)
        } catch {
            NSLog("Error encoding video post to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with video post creation data task: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    func fetchVideoPosts(completion: @escaping () -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("videoPosts").appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching video posts: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do {
                let fetchedVideos = try JSONDecoder().decode([String : VideoPost].self, from: data)
                self.videoPostsDict = fetchedVideos
                self.videoPosts = Array(fetchedVideos.values)
            } catch {
                self.videoPosts = []
                NSLog("Error decoding video posts from JSON data: \(error)")
            }
            
            completion()
        }.resume()
    }
    
    func saveVideos() {
        for videoPost in 0..<videoPosts.count {
            //let video = AVMovie(data: videoPost.video, options: nil)
            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let videoURL = path.appendingPathComponent(videoPosts[videoPost].identifier)
            do {
                try videoPosts[videoPost].video.write(to: videoURL)
            } catch {
                print("Error saving video to phone: \(error)")
                return
            }
            
            //videoPost.videoURL = videoURL
        }
    }
}
