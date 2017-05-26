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
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: Actions
    
    @IBAction func cameraButtonTapAction(_ sender: UIBarButtonItem) {
        openCamera()
    }

    @IBAction func albumButtonTapAction(_ sender: UIBarButtonItem) {
        openAlbum()
    }
    
    @IBAction func shareButtonTapAction(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Helper
    
    func setupView() {
    
        enableOrDisbleCameraButtonBasedOnAvailability()
        setupTextFieldAttributes()
    }
    
    func openCamera() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openAlbum() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func enableOrDisbleCameraButtonBasedOnAvailability() {
        cameraBarButtonItem.isEnabled = TARGET_OS_SIMULATOR == 0
    }
    
    func enableOrDisbleShareButtonBasedOnAvailability() {
        // TODO:
        shareBarButtonItem.isEnabled = false
    }
    
    func setupTextFieldAttributes() {
        
        let paragraphStype = NSMutableParagraphStyle()
        paragraphStype.alignment = .center
        
        let textAttributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 60.0),
            NSStrokeWidthAttributeName: -2.0,
            NSParagraphStyleAttributeName: paragraphStype,
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white]
        
        topTextField.defaultTextAttributes = textAttributes;
        bottomTextField.defaultTextAttributes = textAttributes;
    }
}

// MARK: Image Picker Delegate

extension MMHomeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureImageView.image = image
        }
    }
}

