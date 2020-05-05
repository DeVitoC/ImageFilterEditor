//
//  ApplyFilterViewController.swift
//  ImageFilterEditor
//
//  Created by Christopher Devito on 5/4/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit

class ApplyFilterViewController: UIViewController {
    
    // MARK: - Properties
    var filterController: FilterController?
    var image: UIImage?
    var filter: CustomFilter?
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var scaleStackView: UIStackView!
    @IBOutlet weak var radiusStackView: UIStackView!
    @IBOutlet weak var angleStackView: UIStackView!
    @IBOutlet weak var intensityStackView: UIStackView!
    
    // MARK: - IBActions
    @IBAction func scaleChanged(_ sender: Any) {
        updateViews()
    }
    @IBAction func radiusChanged(_ sender: Any) {
        updateViews()
    }
    @IBAction func angleChanged(_ sender: Any) {
        updateViews()
    }
    @IBAction func intensityChanged(_ sender: Any) {
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        title = filter?.name
        setRadius()
        setScale()
        setAngle()
        setIntensity()
        setImage()
    }
    
    func setRadius() {
        if filter?.radius == nil {
            radiusStackView.isHidden = true
        } else {
            guard let height = Float("\(image!.size.height)"),
                let width = Float("\(image!.size.width)")
                else { return }
            radiusSlider.maximumValue = ((height > width) ? (width/2) : (height/2))
            radiusSlider.minimumValue = 0
            radiusSlider.value = radiusSlider.maximumValue/2
            
        }
    }
    
    func setScale() {
        if filter?.scale == nil {
            scaleStackView.isHidden = true
        } else {
            scaleSlider.maximumValue = 1.0
            scaleSlider.minimumValue = -1.0
            scaleSlider.value = 0.5
        }
    }
    
    func setAngle() {
        if filter?.angle == nil {
            angleStackView.isHidden = true
        } else {
            angleSlider.maximumValue = 100
            angleSlider.minimumValue = 0.00
            angleSlider.value = 0.00
        }
    }
    
    func setIntensity() {
        if filter?.intensity == nil {
            intensityStackView.isHidden = true
        } else {
            intensitySlider.maximumValue = 1
            intensitySlider.minimumValue = 0
            intensitySlider.value = 0.5
        }
    }
    
    func setImage() {
        if let image = image {
            imageView.image = filter?.filterImage(image, filterValue: CGFloat(scaleSlider.value), centerPoint: CGPoint(x: image.size.width/2, y: image.size.height/2), radius: CGFloat(radiusSlider.value), angle: NSNumber(value: angleSlider.value), intensity: NSNumber(value: intensitySlider.value))
        } else {
            imageView.image = nil
        }
    }
    
    func updateViews() {
        setImage()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filterSelectionVC = segue.destination as! FilterSelectionViewController
        let centerImage = CGPoint(x: (filterSelectionVC.originalImage?.size.width)!/2, y: (filterSelectionVC.originalImage?.size.height)!/2)
        let center = filter?.center != nil ? centerImage : nil
        filterSelectionVC.originalImage = filter?.filterImage(filterSelectionVC.originalImage!, filterValue: CGFloat(scaleSlider.value), centerPoint: center, radius: CGFloat(radiusSlider.value), angle: NSNumber(value: angleSlider.value), intensity: NSNumber(value: intensitySlider.value))
    }

}
