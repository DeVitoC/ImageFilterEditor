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
    let geotagFetcher = GeotagFetcher()
    
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
        
        // TODO: - pass location information to method instead of 0.00, 0.00.
        let geotag = geotagFetcher.createGeotag(at: [0.00, 0.00]) {
            
        }
        let videoPost = VideoPost(author: author, video: data, geotag: geotag, videoURL: url)
        videoPosts.append(videoPost)
        
        let requestURL = baseURL.appendingPathComponent("videoPosts").appendingPathComponent("\(videoPost.identifier)").appendingPathExtension("json")
        
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
    
    func saveVideosToPhone(withID: String) {
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
            
            videoPosts[videoPost].videoURL = videoURL
        }
    }
    
    func fetchVideo(identifier: String, completion: @escaping () -> Void) -> VideoPost{
        
        guard let videoPost = videoPostForID(identifier: identifier) else {
            fatalError("Could not find videoPost")
        }
        
        let requestURL = baseURL.appendingPathComponent("videoPosts").appendingPathComponent("\(identifier)").appendingPathExtension("json")
        
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
        return videoPost
    }
    
    func updateVideoPost(identifier: String, withAudioComment: AudioComment, completion: @escaping () -> Void) {
        
        guard var videoPost = videoPostForID(identifier: identifier) else {
            return
        }
        videoPost.audioComment = withAudioComment
        
        let requestURL = baseURL.appendingPathComponent("videoPosts").appendingPathComponent("\(identifier)").appendingPathExtension("json")
        
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
    
    func videoPostForID(identifier: String) -> VideoPost? {
        var videoPost: VideoPost?
        
        // find item in video posts if it exists
        for item in videoPosts where item.identifier == identifier {
            videoPost = item
        }
        
        // test whether videoPost is nil, if so, print message
        guard videoPost != nil else {
            print("Video Post was not found in video posts array.")
            return nil}
        
        return videoPost
    }
}
