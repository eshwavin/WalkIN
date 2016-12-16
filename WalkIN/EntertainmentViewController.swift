//
//  EntertainmentViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 13/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class EntertainmentViewController: UIViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var movieTheatresView: UIView!
    @IBOutlet weak var movieTheatresButton: MovieTheatresButton!
    
    @IBOutlet weak var shoppingView: UIView!
    @IBOutlet weak var shoppingButton: ShoppingButton!
    
    @IBInspectable var themeColor: UIColor = UIColor.red
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    let moviesButtonGradientLayer = CAGradientLayer()
    let shoppingButtonGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // setting navigation bar as transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = self.themeColor
        
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // adding gradient
        let color1 = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor as CGColor
        let color2 = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2, color1]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.backgroundImageView.layer.insertSublayer(self.gradientLayer, at: 0)

        
        // rounding borders
        self.movieTheatresView.layer.cornerRadius = 5.0
        self.movieTheatresView.clipsToBounds = true
        
        self.shoppingView.layer.cornerRadius = 5.0
        self.shoppingView.clipsToBounds = true
        
        // adding gradient to buttons
        
        let buttonColor1 = UIColor(red: 93.0/255.0, green: 75.0/255.0, blue: 196.0/255.0, alpha: 1.0).cgColor as CGColor
        let buttonColor2 = UIColor(red: 140.0/255.0, green: 75.0/255.0, blue: 196.0/255.0, alpha: 1.0).cgColor as CGColor
        
        self.moviesButtonGradientLayer.colors = [buttonColor1, buttonColor2]
        self.moviesButtonGradientLayer.locations = [0.0, 1.0]
        self.moviesButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.moviesButtonGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.movieTheatresView.layer.insertSublayer(self.moviesButtonGradientLayer, below: self.movieTheatresButton.layer)
        
        self.shoppingButtonGradientLayer.colors = [buttonColor2, buttonColor1]
        self.shoppingButtonGradientLayer.locations = [0.0, 1.0]
        self.shoppingButtonGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.shoppingButtonGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.shoppingView.layer.insertSublayer(self.shoppingButtonGradientLayer, below: self.shoppingButton.layer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setting navigation bar and tab bar color to theme color
        UIView.transition(with: (self.navigationController?.navigationBar)!, duration: 0.8, options: [], animations: {
            self.navigationController?.navigationBar.tintColor = self.themeColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.themeColor]
            self.tabBarController?.tabBar.tintColor = self.themeColor
            }, completion: nil)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        self.gradientLayer.frame = self.backgroundImageView.bounds
        self.moviesButtonGradientLayer.frame = self.movieTheatresView.bounds
        self.shoppingButtonGradientLayer.frame = self.shoppingView.bounds
        
    }
    
    
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            let destinationViewController = segue.destination as! UserViewController
            destinationViewController.themeColor = self.themeColor
        }
        
    }
    

}
