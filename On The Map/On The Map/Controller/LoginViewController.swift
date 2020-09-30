//
//  ViewController.swift
//  On The Map
//
//  Created by Mouhamed  on 7/26/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import UIKit

// Enables the user to login, navigate to the udacity website to create account and provide a progress view for the network call
class LoginViewController: UIViewController {
    
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        let state = defaults.bool(forKey: "loggedIn")
        HelperManager.setLoginState(to: state)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        passwordTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        
        guard userNameTextField.text?.count ?? 0 > 0 || passwordTextField.text?.count ?? 0 > 0 else {
            return
        }
        
        setLoggingIn(true)
        
        SessionService.createSession(username: userNameTextField.text!, password: passwordTextField.text!) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success( _):
                    self.setLoggingIn(false)
                    self.loginUser()
                    HelperManager.setLoginState(to: true)
                case .failure(let error):
                    self.setLoggingIn(false)
                    self.TriggerAlert(for: error)
                    print(error)
                }
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let  _ = HelperManager.openURL(urlString: K.URL.signUpUrl)
    }
}


//MARK: - Delegates

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
    }
}

//MARK: - Helper Functions
extension LoginViewController {
    
    func setLoggingIn(_ logging: Bool){
        if logging {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func TriggerAlert(for error : Error) {
        let statusCode =  error
        switch statusCode {
        case HTTPNetworkError.authenticationError:
            let alert = UIAlertController(title: "Wrong Credentials", message: "Please Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: false)
        case HTTPNetworkError.badRequest:
            let alert = UIAlertController(title: "Network Issues", message: "Please Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: false)
        default: return
        }
    }
    
    
    func loginUser () {
        DispatchQueue.main.async {
            guard let tbVC = self.storyboard?.instantiateViewController(withIdentifier: K.VC.tabVc) else {return}
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tbVC)
        }
    }
    
}

