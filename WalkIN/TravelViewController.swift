
//
//  TravelViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TravelViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var cabsView: UIView!
    @IBOutlet weak var busesView: UIView!
    @IBOutlet weak var trainsView: UIView!
    
    @IBOutlet weak var cabsButton: CabsButton!
    @IBOutlet weak var busesButton: BusesButton!
    @IBOutlet weak var trainsButton: TrainsButton!
    
    @IBInspectable var themeColor: UIColor = UIColor.green
    
    let gradientLayer = CAGradientLayer()
    let cabsButtonGradientLayer = CAGradientLayer()
    let busesButtonGradientLayer = CAGradientLayer()
    let trainsButtonGradientLayer = CAGradientLayer()

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
        self.cabsView.layer.cornerRadius = 5.0
        self.cabsView.clipsToBounds = true
        
        self.busesView.layer.cornerRadius = 5.0
        self.busesView.clipsToBounds = true
        
        self.trainsView.layer.cornerRadius = 5.0
        self.trainsView.clipsToBounds = true
        
        
        // adding gradient to buttons
        let buttonColor1 = UIColor.green.cgColor as CGColor
        let buttonColor2 = UIColor.yellow.cgColor as CGColor
        self.cabsButtonGradientLayer.colors = [buttonColor1, buttonColor2]
        self.cabsView.layer.insertSublayer(self.cabsButtonGradientLayer, below: self.cabsButton.layer)
        
        let buttonColor3 = UIColor.yellow.cgColor as CGColor
        let buttonColor4 = UIColor.green.cgColor as CGColor
        self.busesButtonGradientLayer.colors = [buttonColor3, buttonColor4]
        self.busesView.layer.insertSublayer(self.busesButtonGradientLayer, below: self.busesButton.layer)
        
        let buttonColor5 = UIColor.yellow.cgColor as CGColor
        let buttonColor6 = UIColor.green.cgColor as CGColor
        self.trainsButtonGradientLayer.colors = [buttonColor5, buttonColor6]
        self.trainsView.layer.insertSublayer(self.trainsButtonGradientLayer, below: self.trainsButton.layer)
        
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
        self.cabsButtonGradientLayer.frame = self.cabsView.bounds
        self.busesButtonGradientLayer.frame = self.busesView.bounds
        self.trainsButtonGradientLayer.frame = self.trainsView.bounds
    }
    
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            let destinationViewController = segue.destination as! UserViewController
            destinationViewController.themeColor = self.themeColor
        }
        
    }

}
