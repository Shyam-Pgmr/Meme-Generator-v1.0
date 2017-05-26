//
//  MMHomeViewController.swift
//  MeMe-1.0
//
//  Created by Shyam on 26/05/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class MMHomeViewController: UIViewController {

    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Actions
    
    @IBAction func cameraButtonTapAction(_ sender: UIBarButtonItem) {
        
    }

    @IBAction func albumButtonTapAction(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Helper
    
    func setupView() {
    
        enableOrDisbleCameraButtonBasedOnAvailability()
    }
    
    func openCamera() {
        
    }
    
    func openAlbum() {
        
    }
    
    func enableOrDisbleCameraButtonBasedOnAvailability() {
        cameraBarButtonItem.isEnabled = true
    }
    
}
