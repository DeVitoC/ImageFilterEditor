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
    
    // MARK: - IBActions
    @IBAction func scaleChanged(_ sender: Any) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let image = image else { return }
        imageView.image = image
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
