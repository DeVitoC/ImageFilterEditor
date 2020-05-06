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
        performSegue(withIdentifier: "AddVideoSegue", sender: self)
    }
    

    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        videosCollectionView.dataSource = self
        videosCollectionView.delegate = self
    }
    
    func updateViews() {
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension VideosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = videosCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "VideoDetailSegue", sender: self)
    }
}
