//
//  TrendingListViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 12/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class TrendingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBInspectable var restaurantThemeColor: UIColor = UIColor.blue
    @IBInspectable var moviesThemeColor: UIColor = UIColor.red
    @IBInspectable var touristThemeColor: UIColor = UIColor.green
    @IBInspectable var shoppingThemeColor: UIColor = UIColor.red
    
    var selectedThemeColor = UIColor.white
    
    let gradientLayer = CAGradientLayer()
    
    // MARK: Passed from previous view
    var trendingType: String = "Restaurants"
    
    // MARK: Required for table view
    
    var restaurantItemList: [Restaurant] = []
    
    // MARK: Loading animation
    let loadingImageView = UIView()
    let containerLayer = CALayer()
    let imageLayer = CALayer()
    
    // MARK: Firebase References
    let databaseReference = FIRDatabase.database().reference()
    let storageReference = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    
    var generalImage: UIImage = UIImage(named: "generalRestaurant")!
    var images: [String: UIImage] = [:]
    
    // MARK: Navigation Variables
    var selectedRestaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setting right bar button item as settings icon
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_icon"), style: .plain, target: self, action: #selector(TrendingListViewController.goToSettings))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // setting title of the screen
        self.title = self.trendingType
        
        // adding gradient to background
        let color1 = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor as CGColor
        let color2 = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2]
        self.gradientLayer.locations = [0.0, 1.0]
        self.backgroundImageView.layer.insertSublayer(self.gradientLayer, at: 0)
        
        
        // getting the theme color
        self.selectedThemeColor = self.restaurantThemeColor
        
        // setting row height
        self.tableView.rowHeight = 84.0
        
        // adding loading view animation
        
        self.loadingImageView.backgroundColor = UIColor(red: 53.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
        self.imageLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.imageLayer.contents = RestaurantIcon().restaurantIcon.cgImage
        
        
        self.containerLayer.addSublayer(self.imageLayer)
        
        self.loadingImageView.layer.addSublayer(self.containerLayer)
        
        self.view.addSubview(self.loadingImageView)
        
        // getting data
        
        self.databaseReference.child("restaurants").queryOrdered(byChild: "views").queryLimited(toLast: 10).observe(FIRDataEventType.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("There was some error fetching the data according to views")
            }
            else {
                
                let dataDictionary = snapshot.value as! [String: AnyObject]
                
                self.restaurantItemList = [Restaurant]()
                
                for data in dataDictionary {
                    
                    
                    
                    let key = data.key
                    let value = data.value as! [String: AnyObject]
                    
                    let homeDelivery = (value["home_delivery"] as? String) == "No" ? false : true
                    
                    let restaurant = Restaurant(id: key, rid: value["rid"] as! Int, name: value["name"] as! String, timings: value["timings"] as! String, contact: value["contact"] as! String, address: value["address"] as! String, speciality: value["speciality"] as! String, rdescription: value["description"] as! String, weblink: value["weblink"] as! String, homeDelivery: homeDelivery, no5: value["no5"] as! Int, no4: value["no4"] as! Int, no3: value["no3"] as! Int, no2: value["no2"] as! Int, no1: value["no1"] as! Int, rating: value["rating"] as! Float, images: value["images"] as! Int)
                    
                    self.restaurantItemList.append(restaurant)
                }
                
                self.loadingImageView.removeFromSuperview()
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.transition(with: (self.navigationController?.navigationBar)!, duration: 0.8, options: [], animations: {
            self.navigationController?.navigationBar.tintColor = self.restaurantThemeColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: self.restaurantThemeColor]
            self.tabBarController?.tabBar.tintColor = self.restaurantThemeColor
            }, completion: nil)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = self.backgroundImageView.frame
        
        self.loadingImageView.frame = self.tableView.frame
        
        self.containerLayer.frame = CGRect(origin: CGPoint(x: self.tableView.center.x - 50, y: self.tableView.frame.height/2 - 50), size: CGSize(width: 100, height: 100))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.loadingImageView.superview != nil {
            let loadingAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
            loadingAnimation.fromValue = 0.0
            loadingAnimation.toValue = CGFloat(M_PI)
            loadingAnimation.duration = 0.5
            
            let loadingAnimation2 = CABasicAnimation(keyPath: "transform.rotation.y")
            loadingAnimation2.fromValue = CGFloat(M_PI)
            loadingAnimation2.toValue = CGFloat(M_PI * 2)
            loadingAnimation2.beginTime = 0.5
            loadingAnimation2.duration = 0.5
            
            let position = self.imageLayer.position.y
            
            let moveDownAnimation = CABasicAnimation(keyPath: "position.y")
            moveDownAnimation.fromValue = position
            moveDownAnimation.toValue = position + 20.0
            moveDownAnimation.duration = 0.5
            
            let moveUpAnimation = CABasicAnimation(keyPath: "position.y")
            moveUpAnimation.fromValue = position + 20.0
            moveUpAnimation.toValue = position
            moveUpAnimation.duration = 0.5
            moveUpAnimation.beginTime = 0.5
            
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [loadingAnimation, loadingAnimation2, moveDownAnimation, moveUpAnimation]
            animationGroup.repeatCount = Float.infinity
            animationGroup.duration = 1.2
            
            self.imageLayer.add(animationGroup, forKey: "loading")
        }

    }
    
    // MARK: Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.restaurantItemList.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendingRestaurantCell", for: indexPath) as! TrendingRestaurantsTableViewCell
        
        cell.picture.image = nil
        cell.picture.layer.cornerRadius = (cell.frame.height - 16.0) / 2.0
        cell.picture.clipsToBounds = true
        
        let restaurant = self.restaurantItemList[indexPath.row]
        
        cell.titleLabel.text = restaurant.name
        cell.speciality.text = restaurant.speciality
        
        let ratingCount = restaurant.no1 + restaurant.no2 + restaurant.no3 + restaurant.no4 + restaurant.no5
        cell.ratingsCount.text = "(\(ratingCount))"
        
        cell.ratingsView.rating = Double(restaurant.rating)
        cell.ratingsView.setNeedsDisplay()
        
        if restaurant.images == 0 {
            cell.picture.image = self.generalImage
        }
        else {
            // getting picture from the database
            if let image = self.images[restaurant.id] {
                cell.picture.image = image
            }
            else {
                let imageReference = self.storageReference.child("restaurants").child(restaurant.id).child("1.jpg")
                imageReference.data(withMaxSize: 1024 * 1024, completion: { (data, error) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.images[restaurant.id] = image
                        cell.picture.image = image
                    }
                })
            }
        }
        
        // setting all colours
        cell.titleLabel.textColor = self.restaurantThemeColor
        cell.speciality.textColor = self.restaurantThemeColor
        cell.ratingsView.themeColor = self.restaurantThemeColor
        cell.ratingsCount.textColor = self.restaurantThemeColor
        
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRestaurant = self.restaurantItemList[indexPath.row]
        self.performSegue(withIdentifier: "showRestaurantDetails", sender: self)

        
    }
    
    // MARK: Navigation
    
    func goToSettings() {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetails" {
            let destinationViewController = segue.destination as! RestaurantsDetailsViewController
            destinationViewController.restaurant = self.selectedRestaurant
        }
        else if segue.identifier == "goToSettings" {
            let destinationViewController = segue.destination as! UserViewController
            destinationViewController.themeColor = self.selectedThemeColor
        }
        
    }

}
