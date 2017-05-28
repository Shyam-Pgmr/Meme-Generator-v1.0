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
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: Constants
    
    let TOP = "Top"
    let BOTTOM = "Bottom"
    let textAttributes:[String:Any] = {
        let paragraphStype = NSMutableParagraphStyle()
        paragraphStype.alignment = .center
        
        var attributes:[String: Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 60.0),
            NSStrokeWidthAttributeName: -2.0,
            NSParagraphStyleAttributeName: paragraphStype,
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white]
        
        return attributes
    }()
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverForKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserverForKeyboard()
    }
    
    // MARK: Actions
    
    @IBAction func cameraButtonTapAction(_ sender: UIBarButtonItem) {
        presentPicker(with: .camera)
    }

    @IBAction func albumButtonTapAction(_ sender: UIBarButtonItem) {
        presentPicker(with: .photoLibrary)
    }
    
    @IBAction func shareButtonTapAction(_ sender: UIBarButtonItem) {
        shareMeme()
    }
    
    // MARK: Helper
    
    func setupView() {
    
        enableOrDisbleCameraButtonBasedOnAvailability()
        enableOrDisbleShareButtonBasedOnAvailability()
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
    
    func presentPicker(with sourceType:UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    func shareMeme() {
        
        if let imageToShare = generateMeMeImage() {
            
            let controller = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            controller.completionWithItemsHandler = {(type,completion,returnItems,error) in
            
                if completion {
                    self.saveMeme(using: imageToShare)
                }
            }
                
            present(controller, animated: true, completion: nil)
        }
    }
    
    func enableOrDisbleCameraButtonBasedOnAvailability() {
        cameraBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func enableOrDisbleShareButtonBasedOnAvailability() {
        
        // Enable Share option only when image, top text or bottom text is set
        shareBarButtonItem.isEnabled = (pictureImageView.image != nil && (!topTextField.isEmpty || !bottomTextField.isEmpty))
    }
    
    func configApperance(of textField:UITextField, with text:String) {

        let attributedTextForTextField = NSAttributedString(string: text, attributes: textAttributes)
        textField.defaultTextAttributes = textAttributes
        textField.attributedPlaceholder = attributedTextForTextField
    }

    func setupTextFieldAttributes() {
        configApperance(of: topTextField, with: TOP)
        configApperance(of: bottomTextField, with: BOTTOM)
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
    
    func generateMeMeImage() -> UIImage? {
        
        // Hide naviation bar and toolbar so that It is not capture while taking snapshot
        navigationController?.navigationBar.isHidden = true
        toolbar.isHidden = true
        
        // Create UIImage by snapshotting screen's super view
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show naviation bar and toolbar
        navigationController?.navigationBar.isHidden = false
        toolbar.isHidden = false
        
        return memeImage
    }
    
    func saveMeme(using memeImage:UIImage) {
        
        let meme = MeMe(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: pictureImageView.image!, memeImage: memeImage)
    }
    
}

// MARK: Image Picker Delegate

extension MMHomeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureImageView.image = image
            enableOrDisbleShareButtonBasedOnAvailability()
        }
    }
}

// MARK: TextField Delegate

extension MMHomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // To close keyboard
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableOrDisbleShareButtonBasedOnAvailability()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableOrDisbleShareButtonBasedOnAvailability()
    }
}


// MARK: TextField Helper

extension UITextField {
    
    var isEmpty:Bool {
        get {
            return (self.text ?? "").isEmpty
        }
    }
}
