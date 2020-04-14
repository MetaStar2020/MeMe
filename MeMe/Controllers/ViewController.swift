//
//  ViewController.swift
//  MeMe
//
//  Created by Chantal Deguire on 2020-03-23.
//  Copyright © 2020 Udacity. All rights reserved.
//
// Note: There's no need for a navigation bar -- app uses a single view and presented subviews
//


import UIKit
import AVFoundation

class ViewController:  UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Variables and Constants
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    //Set NSAttributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0,
    ]
    
    //Constants
    let topDefaultFieldText: String = "TOP"
    let bottomDefaultFieldText: String = "BOTTOM"
    
    // MARK: - Views Control
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        setTextStyle(topText, topDefaultFieldText)
        setTextStyle(bottomText, bottomDefaultFieldText)
        
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
    
    // MARK: - Navigation
    
       /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
        let destVC : SentMemesVC = segue.destination as! SentMemesVC
           // Pass the selected object to the new view controller. -- IMPLEMENTATION NEEDED!
        destVC.delegate = self
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
 
    func setTextStyle(_ textField: UITextField, _ defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.backgroundColor = UIColor.clear
        textField.delegate = self
        textField.adjustsFontSizeToFitWidth = true
        textField.text = defaultText
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
        pickFromSource(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickFromSource(.camera)
    }
    
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
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
                showAlert("MemeMe", "share completed")
                self.save()
                return
            } else {
                showAlert("MemeMe", "share cancelled")
            }
            if let shareError = error {
                showAlert("MemeMe", "error while sharing: \(shareError.localizedDescription)")
            }
        }
        
        //Set up Alerts
        func showAlert(_ alertTitle: String, _ alertMessage: String) {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
               
            //self.present(alert, animated: true)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
    }
    @IBAction func cancelCurrentMeme(_ sender: Any) {
        // Removing current image and return to Sent Memes
        imagePickerView.image = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Memory Functions
    func save() {
        
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        //Add to the memes array in AppDelegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
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

