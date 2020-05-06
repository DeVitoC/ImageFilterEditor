//
//  VideosViewController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
    
    // MARK: - Properties
    var videos: [Any] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
    // MARK: - IBActions
    @IBAction func createVideoTapped(_ sender: Any) {
    }
    

    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
