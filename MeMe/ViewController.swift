//
//  ViewController.swift
//  MeMe
//
//  Created by Chantal Deguire on 2020-03-23.
//  Copyright © 2020 Udacity. All rights reserved.
//
// Note: I chose not to use a navigation bar -- app uses a single view and presented subviews
//

import UIKit
import AVFoundation

class ViewController:  UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    //weak var memedImage: UIImage!
    
    struct Meme {
        var topText: String!
        var bottomText: String!
        var originalImage: UIImage!
        var memedImage: UIImage
    }
    
    // MARK: - Views Control
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        topText.delegate = self
        bottomText.delegate = self
        setDefaultText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //topText.becomeFirstResponder()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }*/
    
    // MARK: - Keyboard Settings
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if bottomText.isEditing && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if bottomText.isEditing && view.frame.origin.y != 0 {
             view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setting Default Texts
    func setDefaultText() {
        
        topText.text = "TOP"
        topText.textAlignment = NSTextAlignment.center
        topText.backgroundColor = UIColor.clear
               
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = NSTextAlignment.center
        bottomText.backgroundColor = UIColor.clear
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.0,
        ]
        
       topText.defaultTextAttributes = memeTextAttributes
       bottomText.defaultTextAttributes = memeTextAttributes

    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = pickedImage
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerController Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Share and Cancel Button Actions
    @IBAction func shareCurrentPhoto(_ sender: Any) {
        //Generate memedImage
       let sharedImage = generateMemedImage()
        
        //present an ActivityViewController
        let activityView = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
                present(activityView, animated: true)
        
        //Completion Handler - saving
        activityView.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                print("share completed")
                self.save()
                return
            } else {
                print("cancel")
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
        
    }
    @IBAction func cancelCurrentMeme(_ sender: Any) {
        // TO DO: return to default settings (no images and custom texts)
    }
    
    // MARK: - Memory Functions
    func save() {
        
        // Create the meme
        _ = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        self.toolBar.isHidden = true
        self.navBar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        self.toolBar.isHidden = false
        self.navBar.isHidden = false

        return memedImage
    }
    
}

