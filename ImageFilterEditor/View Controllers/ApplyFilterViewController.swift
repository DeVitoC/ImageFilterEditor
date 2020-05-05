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
    @IBOutlet weak var fourthSlider: UISlider!
    @IBOutlet weak var scaleStackView: UIStackView!
    @IBOutlet weak var radiusStackView: UIStackView!
    @IBOutlet weak var AngleStackView: UIStackView!
    @IBOutlet weak var fourthStackView: UIStackView!
    
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
    @IBAction func fourthChanged(_ sender: Any) {
        updateViews()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
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
        if filter?.scale == nil {
            scaleStackView.isHidden = true
        } else {
            scaleSlider.maximumValue = 1.0
            scaleSlider.minimumValue = -1.0
            scaleSlider.value = 0.5
        }
        if filter?.angle == nil {
            AngleStackView.isHidden = true
        } else {
            angleSlider.maximumValue = 100
            angleSlider.minimumValue = 0.00
            angleSlider.value = 0.00
        }
        fourthStackView.isHidden = true
        if let image = image {
            imageView.image = filter?.filterImage(image, filterValue: CGFloat(scaleSlider.value), centerPoint: CGPoint(x: image.size.width/2, y: image.size.height/2), radius: CGFloat(radiusSlider.value), angle: NSNumber(value: angleSlider.value))
        } else {
            imageView.image = nil
        }
    }
    
    func updateViews() {
        if let image = image {
            imageView.image = filter?.filterImage(image, filterValue: CGFloat(scaleSlider.value), centerPoint: CGPoint(x: image.size.width/2, y: image.size.height/2), radius: CGFloat(radiusSlider.value))
        } else {
            imageView.image = nil
        }
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
