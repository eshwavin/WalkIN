//
//  ViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 24/09/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

var isGuest: Bool = false

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    var gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var FBSignInButton: FBSDKLoginButton!
    @IBOutlet weak var guestSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up FB Login Button
        self.FBSignInButton.readPermissions = ["public_profile", "email", "user_friends"]
        self.FBSignInButton.delegate = self
        
        // setting up the gradient layer
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0).cgColor as CGColor
        
        self.gradientLayer.colors = [color1, color2]
        self.gradientLayer.locations = [0.0, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        self.backgroundImageView.layer.addSublayer(self.gradientLayer)
        
        // adding corner radius to guest sign in button
        self.guestSignInButton.layer.cornerRadius = 3.0
        self.guestSignInButton.clipsToBounds = true
        
        // logging in
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                // User is signed in
                self.FBSignInButton.isHidden = true
                self.performSegue(withIdentifier: "signIn", sender: self)
            }
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientLayer.frame = self.backgroundImageView.frame
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else if result.isCancelled {
            print("Result cancelled")
        }
        else {
            
            // hiding FBSignInButton
            self.FBSignInButton.isHidden = true
            
            
            
            // Firebase connection
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    self.displayErrorMessage(message: "Could not authenticate login")
                }
                else {
                    // Performing Segue
                    self.performSegue(withIdentifier: "signIn", sender: self)
                }
            })
            
            
            
        }

    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        self.FBSignInButton.isHidden = false
    
    }
    
    
    @IBAction func signIn(_ sender: AnyObject) {
        
        isGuest = true
        self.performSegue(withIdentifier: "signIn", sender: sender)
        
    }

    func displayErrorMessage(message: String) {
        
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

