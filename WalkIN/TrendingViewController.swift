//
//  TrendingViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import GameplayKit

class TrendingViewController: UIViewController {

    @IBInspectable var themeColor: UIColor = UIColor(red: 201.0/255.0, green: 150.0/255.0, blue: 19.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    let emitterLayer = CAEmitterLayer()
    
    var count = 0
    var tags: [Int] = [1, 3, 2, 4]
    var currentTitle = "Trending"
    
    var timer: Timer!
    
    var selectedTag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting title of the view
        self.title = self.currentTitle
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        // making tab bar transparent
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        
        // setting navigation bar as transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        

        // adding background gradient
        let color1 = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor as CGColor
        let color2 = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2]
        self.gradientLayer.locations = [0.0, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundImageView.layer.insertSublayer(self.gradientLayer, at: 0)
        
        // adding emitter layer
        self.emitterLayer.emitterShape = kCAEmitterLayerRectangle
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "Oval1")!.cgImage
        emitterCell.birthRate = 20
        emitterCell.lifetime = 4.0
        emitterCell.scale = 0.1
        emitterCell.scaleRange = 0.05
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        
        let emitterCell2 = CAEmitterCell()
        emitterCell2.contents = UIImage(named: "Oval2")!.cgImage
        emitterCell2.birthRate = 20
        emitterCell2.lifetime = 4.0
        emitterCell2.scale = 0.1
        emitterCell2.scaleRange = 0.05
        emitterCell2.alphaRange = 0.75
        emitterCell2.alphaSpeed = -0.15
        
        let emitterCell3 = CAEmitterCell()
        emitterCell3.contents = UIImage(named: "Oval3")!.cgImage
        emitterCell3.birthRate = 30
        emitterCell3.lifetime = 4.0
        emitterCell3.scale = 0.1
        emitterCell3.scaleRange = 0.05
        emitterCell3.alphaRange = 0.75
        emitterCell3.alphaSpeed = -0.15
        
        self.emitterLayer.emitterCells = [emitterCell, emitterCell2, emitterCell3]
        
        self.backgroundImageView.layer.addSublayer(self.emitterLayer)
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // setting gradient frame
        self.gradientLayer.frame = self.backgroundImageView.bounds
        
        // setting emitter layer position
        self.emitterLayer.frame = self.backgroundImageView.bounds
        self.emitterLayer.emitterSize = self.backgroundImageView.frame.size
        self.emitterLayer.emitterPosition = CGPoint(x: self.backgroundImageView.frame.width / 2.0, y: self.backgroundImageView.frame.height / 2.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 1...4 {
            self.view.viewWithTag(i)?.alpha = 1.0
        }
        
        // setting navigation bar and tab bar color to theme color
        UIView.transition(with: (self.navigationController?.navigationBar)!, duration: 0.8, options: [], animations: {
            self.navigationController?.navigationBar.tintColor = self.themeColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.themeColor]
            self.tabBarController?.tabBar.tintColor = self.themeColor
            }, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(TrendingViewController.addAnimation), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
        
    }
    
    /**Animates buttons to pulse randomly*/
    func addAnimation() {
        
        //let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = NSNumber(floatLiteral: 0.8)
        animation.toValue = NSNumber(floatLiteral: 1.0)
        animation.duration = animation.settlingDuration
        animation.initialVelocity = 25.0
        animation.damping = 5.0
        
        let randomNumber = self.tags[self.count]/**Animates buttons to pulse randomly*/
        func addAnimation() {
            
            //let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.fromValue = NSNumber(floatLiteral: 0.8)
            animation.toValue = NSNumber(floatLiteral: 1.0)
            animation.duration = animation.settlingDuration
            animation.initialVelocity = 25.0
            animation.damping = 5.0
            
            let randomNumber = self.tags[self.count] 
            self.count = (self.count + 1) % 4
            if self.count == 0 {
                self.tags = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.tags) as! [Int]
            }
            
            if let button = self.view.viewWithTag(Int(randomNumber)) as? TrendingButtons {
                button.layer.add(animation, forKey: nil)
            }
            
        }
        self.count = (self.count + 1) % 4
        if self.count == 0 {
            self.tags = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.tags) as! [Int]
        }
        
        if let button = self.view.viewWithTag(Int(randomNumber)) as? TrendingButtons {
            button.layer.add(animation, forKey: nil)
        }
        
    }
    
    @IBAction func trendingButtonPressed(_ sender: AnyObject) {
        
        self.timer.invalidate()
        
        self.selectedTag = sender.tag
        
        for i in 1...4 {
            if i != sender.tag {
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.viewWithTag(i)?.alpha = 0.0
                })
            }
        }
        
        if let button = self.view.viewWithTag(sender.tag) as? TrendingButtons {
            
            self.currentTitle = (button.titleLabel?.text)!
            
            if sender.tag == 2 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.performSegue(withIdentifier: "showTrendingMovieTheatres", sender: self)
                }
            }
            else if sender.tag == 3 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.performSegue(withIdentifier: "showTrendingTouristSpots", sender: self)
                }
            }
            else if sender.tag == 4 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.performSegue(withIdentifier: "showTrendingShoppingCenters", sender: self)
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.performSegue(withIdentifier: "showTrending", sender: self)
                }
            }
            
        }
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            let destinationViewController = segue.destination as! UserViewController
            destinationViewController.themeColor = self.themeColor
        }
        else if segue.identifier == "showTrendingMovieTheatres" {
            let destinationViewController = segue.destination as! MovieTheatresViewController
            destinationViewController.trending = true
        }
        else if segue.identifier == "showTrendingShoppingCenters" {
            let destinationViewController = segue.destination as! ShoppingViewController
            destinationViewController.trending = true
        }
        else if segue.identifier == "showTrendingTouristSpots" {
            let destinationViewController = segue.destination as! TouristSpotsViewController
            destinationViewController.trending = true
        }
    }


}
