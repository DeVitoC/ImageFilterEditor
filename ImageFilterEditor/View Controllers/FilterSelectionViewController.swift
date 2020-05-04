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
    
    var index: Int?
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    // MARK: - IBActions
    @IBAction func selectPictureButton(_ sender: Any) {
        
    }
    
    @IBAction func editFilterButton(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filters = filterController.filters
        originalImage = UIImage(named: "flyingSideKick")
    }
    
    func updateViews() {
        imageView.image = scaledImage
        filterCollectionView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue) {
        
    }
}

extension FilterSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterTypeCollectionViewCell else { return UICollectionViewCell() }
        cell.filter = filters[indexPath.item]
        cell.image = scaledImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = scaledImage else { return }
        let index = indexPath.item
        let filter = filters[index]
        imageView.image = filter.filterImage(image)
        
    }
}

extension FilterSelectionViewController: UICollectionViewDelegate {
    
}
