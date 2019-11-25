//
//  UserProfileVC.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 19.11.2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class UserProfileVC: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let loginButton = FBSDKLoginButton()
        //let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: view.frame.height - 172, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
  
    private func setupViews(){
        view.addSubview(fbLoginButton)
    }
    
}

//MARK: Facebook SDK

extension UserProfileVC: FBSDKLoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error)
            return
        }

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
        print("Did logged out of facebook")
        openLoginViewController()
    }

    private func openLoginViewController(){
        //FACEBOOK
        //if !(FBSDKAccessToken.currentAccessTokenIsActive())
//        {
//            DispatchQueue.main.async {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                loginViewController.modalPresentationStyle = .fullScreen
//                self.present(loginViewController, animated: true)
//                return
//            }
//        }
        
        //FIREBASE:
        do {
            try Auth.auth().signOut()
             DispatchQueue.main.async {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.modalPresentationStyle = .fullScreen
                            self.present(loginViewController, animated: true)
                            return
                        }
        } catch {
            print("Failed to sign out: ", error.localizedDescription)
        }
    }
    
    
}
