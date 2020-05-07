//
//  FilterSelectionViewController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/4/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class FilterSelectionViewController: UIViewController {
    
    // MARK: - Properties
    let filterController = FilterController()
    var filters: [CustomFilter] = []
    var originalImage: UIImage? {
        didSet {
            // resize the scaledImage and set it
            guard let originalImage = originalImage else { return }
            
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            
            scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }
    }
    var scaledImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    var savedOriginalImage: UIImage?
    var index: Int?
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    // MARK: - IBActions
    @IBAction func selectPictureButton(_ sender: Any) {
        
    }
    
    @IBAction func editFilterButton(_ sender: Any) {
        performSegue(withIdentifier: "EditFilterSegue", sender: self)
    }
    @IBAction func resetButton(_ sender: Any) {
        imageView.image = savedOriginalImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filters = filterController.filters
        originalImage = UIImage(named: "flyingSideKick")
        savedOriginalImage = originalImage
    }
    
    func updateViews() {
        imageView.image = scaledImage
        filterCollectionView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFilterSegue" {
            guard let index = index else { return }
            let editFilterVC = segue.destination as! ApplyFilterViewController
            editFilterVC.filter = filters[index]
            editFilterVC.filterController = filterController
            editFilterVC.image = scaledImage
        }
    }

    @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue) {
        updateViews()
    }
}

extension FilterSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterTypeCollectionViewCell, let scaledImage = scaledImage else { return UICollectionViewCell() }
        var filter = filters[indexPath.item]
        cell.filter = filter
        let scale = filter.scale
        let centerImage = CGPoint(x: scaledImage.size.width/2, y: scaledImage.size.height/2)
        let center = filter.center != nil ? centerImage : nil
        let radius = (filter.radius != nil) ? filter.radius : nil
        let angle = filter.angle
        let intensity = filter.intensity
        cell.image = filter.filterImage(scaledImage, filterValue: scale, centerPoint: center, radius: radius, angle: angle, intensity: intensity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = scaledImage else { return }
        let index = indexPath.item
        self.index = index
        var filter = filters[index]
        let scale = filter.scale
        let center = CGPoint(x: image.size.width/2, y: image.size.height/2)
        let radius = (filter.radius != nil) ? filter.radius : nil
        let angle = filter.angle
        let intensity = filter.intensity
        imageView.image = filter.filterImage(image, filterValue: scale, centerPoint: center, radius: radius, angle: angle, intensity: intensity)
        filterCollectionView.cellForItem(at: indexPath)?.layer.borderWidth = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        filterCollectionView.cellForItem(at: indexPath)?.layer.borderWidth = 0
        index = nil
        imageView.image = scaledImage
    }
}

extension FilterSelectionViewController: UICollectionViewDelegate {
    
}
