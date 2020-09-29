//
//  ViewController.swift
//  MemeMe

import UIKit
import CoreData

class MemeMakerViewController: UIViewController {
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottonTextField: UITextField!
    @IBOutlet weak var imageSharer: UIBarButtonItem!

    var selectedImage = UIImage()
    var originalImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottonTextField.delegate = self
        isSourceTypeAvailable(camera: UIImagePickerController.SourceType.camera, album: UIImagePickerController.SourceType.photoLibrary)
        bottonTextField.defaultTextAttributes = setupText()
        topTextField.defaultTextAttributes = setupText()
        imageSharer.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    // image selection functionality
    @IBAction func imageSelection(_ sender: UIBarButtonItem) {
        guard let imageSource = sender.title else {return}
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if imageSource == "Album" {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // image sharing functionality
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        guard let memeImage = memeImageGenerator() else {return}
        
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        let item = [memeImage]
        let activityViewController = (UIActivityViewController(activityItems: item, applicationActivities: nil))
        activityViewController.completionWithItemsHandler = {[weak self] (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if error == nil, completed {
                let topTextMeme = self?.topTextField.text
                let bottomTextMeme = self?.bottonTextField.text
                guard let meme = self?.makeMeme(with: memeImage, originalImage: self!.originalImage, topText: topTextMeme, bottomText: bottomTextMeme) else {return}
                self!.saveMeme(meme)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        topTextField.text = "Top"
        bottonTextField.text = "Bottom"
        memeImageView.image = nil
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UIImagePickerControllerDelegate & UITextFieldDelegate
extension MemeMakerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // ImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            memeImageView.image = selectedImage
            originalImage = selectedImage
            imageSharer.isEnabled = true
        }
        else if let selectedImage = info[.editedImage] as? UIImage {
            memeImageView.image = selectedImage
            originalImage = selectedImage
            imageSharer.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: - Notification Manageer
extension MemeMakerViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(shitViewUp(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(shitViewDown(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.cgRectValue.height
    }
    
    @objc func shitViewUp(_ notification: Notification) {
        if bottonTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func shitViewDown(_ notification: Notification) {
        if bottonTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
}


//MARK: - Helper Functions
extension MemeMakerViewController {
    
    func isSourceTypeAvailable(camera: UIImagePickerController.SourceType,album: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(camera) {
            cameraButton.isEnabled = false
        }
        if !UIImagePickerController.isSourceTypeAvailable(album) {
            albumButton.isEnabled = false
        }
    }
    
    func setupText() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let defaultText: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 40),
            .strokeColor: UIColor.black,
            .strokeWidth: -4.0,
            .paragraphStyle: paragraphStyle
        ]
        return defaultText
    }
    
    func memeImageGenerator() -> UIImage? {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func makeMeme(with memeImage: UIImage, originalImage: UIImage, topText: String? , bottomText: String?) -> Meme {
        let meme = Meme(memeImage: memeImage, originalImage: originalImage, toptextField: topText, bottomTextField: bottomText)
        return meme
    }
    
    func saveMeme(_ newMeme: Meme) {
       let appDelegate =  UIApplication.shared.delegate as! AppDelegate
       appDelegate.memes.append(newMeme)
       NotificationCenter.default.post(name: K.didAddNewMeme.name, object: self, userInfo: nil)
    }

}











