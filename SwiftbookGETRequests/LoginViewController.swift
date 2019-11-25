//
//  LoginViewController.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 16/11/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBSDKLoginButton()
        //let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
//    lazy var customFBLoginButton: UIButton = {
//        let loginButton = UIButton()
//        loginButton.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
//        
//        loginButton.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
//        //loginButton.delegate = self
//        return loginButton
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        setupViews()
    }
    
    
    
    private func setupViews(){
        view.addSubview(fbLoginButton)
    }
    
    private func signIntoFirebase() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if let error = error {
                print("Something went wrong with facebook user: ", error)
                return
            }
            print("Successfully logged in with our FB user: ", user!)
        }
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with facebook")
        guard FBSDKAccessToken.currentAccessTokenIsActive() else {return}
        dismiss(animated: true, completion: nil)
        self.signIntoFirebase()
        openMainViewController()
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
        print("Did logged out of facebook")
    }

    private func openMainViewController(){
        dismiss(animated: true)
    }
}
extension UIView {
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIColor {
    convenience init? (hexValue: String, alpha: CGFloat) {
        if hexValue.hasPrefix("#") {
            let scanner = Scanner(string: hexValue)
            scanner.scanLocation = 1
            
            var hexInt32: UInt32 = 0
            if hexValue.count == 7 {
                if scanner.scanHexInt32(&hexInt32) {
                    let red = CGFloat((hexInt32 & 0xFF0000) >> 16) / 255
                    let green = CGFloat((hexInt32 & 0x00FF00) >> 8) / 255
                    let blue = CGFloat(hexInt32 & 0x0000FF) / 255
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
    
}

