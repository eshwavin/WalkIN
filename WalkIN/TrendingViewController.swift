//
//  TrendingViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TrendingViewController: UIViewController {
    
    var selectedTag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        
        // setting navigation bar as transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 1...4 {
            self.view.viewWithTag(i)?.alpha = 1.0
        }
        
    }
    
    @IBAction func trendingButtonPressed(_ sender: AnyObject) {
        
        self.selectedTag = sender.tag
        
        for i in 1...4 {
            if i != sender.tag {
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.viewWithTag(i)?.alpha = 0.0
                })
            }
        }
        
        if (self.view.viewWithTag(sender.tag) as? UIButton) != nil {
            
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
        
        if segue.identifier == "showTrendingMovieTheatres" {
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
