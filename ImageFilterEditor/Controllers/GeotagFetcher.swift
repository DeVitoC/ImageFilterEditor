//
//  GeotagFetcher.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/7/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation

enum GeotagError: Int, Error {
    case invalidURL
    case noDataReturned
    case dateMathError
    case decodeError
}

class GeotagFetcher {
    var geotags: [Geotag] = []
    let baseURL = URL(string: "https://lambdatimeline-9654e.firebaseio.com/")!
    
    func createGeotag(at location: [Double], completion: @escaping () -> Void) -> Geotag {
        
        let date = Date()
        let geotag = Geotag(latitude: location[0], longitude: location[1], time: date)
        geotags.append(geotag)
        
        let requestURL = baseURL.appendingPathComponent("geotags").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(geotag)
        } catch {
            NSLog("Error encoding geotag to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with geotag creation data task: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
        return geotag
    }
    
    func fetchGeotags(completion: @escaping () -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("geotags").appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching geotags: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from geotag data task")
                completion()
                return
            }
            
            do {
                let fetchedGeotags = try JSONDecoder().decode([String : Geotag].self, from: data)
                self.geotags = Array(fetchedGeotags.values)
            } catch {
                self.geotags = []
                NSLog("Error decoding geotags from JSON data: \(error)")
            }
            
            completion()
        }.resume()
    }
    
//    func createGeotag(latitude: Double, longitude: Double) {
//        
//    }
}
