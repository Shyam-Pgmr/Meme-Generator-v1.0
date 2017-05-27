//
//  MMHomeViewController.swift
//  MeMe-1.0
//
//  Created by Shyam on 26/05/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class MMHomeViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Constants
    
    let TOP = "Top"
    let BOTTOM = "Bottom"
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        addObserverForKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserverForKeyboard()
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
    
    func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(slideViewUp(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(slideViewDown(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeObserverForKeyboard() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
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
        
        let attributedTextForTopTextField = NSAttributedString(string: TOP, attributes: textAttributes)
        let attributedTextForBottomTextField = NSAttributedString(string: BOTTOM, attributes: textAttributes)

        topTextField.attributedPlaceholder = attributedTextForTopTextField
        bottomTextField.attributedPlaceholder = attributedTextForBottomTextField
        
    }

    func slideViewUp(notification:NSNotification) {
        
        guard bottomTextField.isFirstResponder else {
            return
        }
        
        if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardHeight = value.cgRectValue.size.height
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            })
        }
    }
    
    func slideViewDown(notification:NSNotification) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.identity
        })
        
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

extension MMHomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

