//
//  VideosViewController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/6/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVFoundation

class VideosViewController: UIViewController {
    
    // MARK: - Properties
    var videos: [Any] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var createVideoPostButton: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func createVideoTapped(_ sender: Any) {
        performSegue(withIdentifier: "AddVideoSegue", sender: self)
    }
    

    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createVideoPostButton.isEnabled = false
        createVideoPostButton.title = ""
        videosCollectionView.dataSource = self
        videosCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get Permission
        requestPermissionAndShowCamera()
    }
    
    func updateViews() {
        
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined: // This means that this is the first time we've requested access
            requestPermission()
        case .restricted: // parental controls prevent user from using the camera/microphone
            fatalError("Tell user they need to request permission from parent")
        case .denied:
            fatalError("Tell user to enable in Settings: popup from audio to do this or custom view.")
        case .authorized:
            createVideoPostButton.isEnabled = true
            createVideoPostButton.title = "Create Video Post"
        default:
            fatalError("Handle new case for authorization.")
        }
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user to enable in Settings: popup from audio to do this or custom view.")
            }
            DispatchQueue.main.async {
                self.createVideoPostButton.isEnabled = true
                self.createVideoPostButton.title = "Create Video Post"
            }
        }
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
