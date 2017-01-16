//
//  RestaurantsViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class RestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Loading animation
    let loadingImageView = UIView()
    let containerLayer = CALayer()
    let imageLayer = CALayer()
    
    // MARK: Firebase variables
    let databaseReference = FIRDatabase.database().reference()
    let storageReference = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    
    var restaurantsLow: [Restaurant] = []
    var restaurantsMedium: [Restaurant] = []
    var restaurantsHigh: [Restaurant] = []
    
    var selectedRestaurant: Restaurant!
    
    var filteredRestaurants = [Restaurant]()
    
    var generalImage: UIImage = UIImage(named: "generalRestaurant")!
    
    var images: [String: UIImage] = [:]
    
    // MARK: Table Variables
    
    let tableViewSectionHeaderTitles = ["Low on Cash", "Just Want to Eat", "Burn My Pockets"]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = restaurantsColor
        
        // setting row height
        self.tableView.rowHeight = 84.0
        
        // adding loading view animation
        
        self.loadingImageView.backgroundColor = restaurantsColor
        
        self.imageLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.imageLayer.contents = RestaurantIcon().restaurantIcon.cgImage
        
        
        self.containerLayer.addSublayer(self.imageLayer)
        
        self.loadingImageView.layer.addSublayer(self.containerLayer)
        
        self.view.addSubview(self.loadingImageView)
        
        // modifying search controller
        
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.tintColor = restaurantsColor
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // setting navigation bar UI
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = restaurantsColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        // setting title of the screen
        self.title = "Restaurants"
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // search controller
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        // modifying search controller UI
        self.searchController.searchBar.backgroundColor = grayColor
        self.searchController.searchBar.barTintColor = restaurantsColor
        self.searchController.searchBar.tintColor = restaurantsColor
//        self.searchController.searchBar.backgroundImage = UIImage()
        self.searchController.searchBar.textColor = restaurantsColor
        
        self.searchController.searchBar.setSearchFieldBackgroundImage(self.createImageFromColor(), for: .normal)
        
        // load restaurant data
        self.databaseReference.child("restaurants").observe(FIRDataEventType.value, with: { (snapshot) in
            if !(snapshot.value is NSNull) {
                let dataDictionary = snapshot.value as! [String: AnyObject]
                
                self.restaurantsLow = [Restaurant]()
                self.restaurantsMedium = [Restaurant]()
                self.restaurantsHigh = [Restaurant]()
                
                for data in dataDictionary {
                    
                    let key = data.key
                    let value = data.value as! [String: AnyObject]
                    
                    let homeDelivery = (value["home_delivery"] as? String) == "No" ? false : true
                    
                    let restaurant = Restaurant(id: key, rid: value["rid"] as! Int, name: value["name"] as! String, timings: value["timings"] as! String, contact: value["contact"] as! String, address: value["address"] as! String, speciality: value["speciality"] as! String, rdescription: value["description"] as! String, weblink: value["weblink"] as! String, homeDelivery: homeDelivery, no5: value["no5"] as! Int, no4: value["no4"] as! Int, no3: value["no3"] as! Int, no2: value["no2"] as! Int, no1: value["no1"] as! Int, rating: value["rating"] as! Float, images: value["images"] as! Int)
                    
                    if restaurant.rid == 0 {
                        self.restaurantsLow.append(restaurant)
                    }
                    else if restaurant.rid == 1 {
                        self.restaurantsMedium.append(restaurant)
                    }
                    else {
                        self.restaurantsHigh.append(restaurant)
                    }
                    
                }
                
                self.restaurantsLow.sort() { r1, r2 in r1.rating >= r2.rating}
                self.restaurantsMedium.sort() { r1, r2 in r1.rating >= r2.rating}
                self.restaurantsHigh.sort() { r1, r2 in r1.rating >= r2.rating}
                
                self.loadingImageView.removeFromSuperview()
                
                self.tableView.reloadData()
                
            }
        }) { (error) in
            
            print("There was some error retreiving restaurant data")
            
        }
        
//        // adding general restaurant image
//        self.storageReference.child("restaurants").child("general/1.jpg").data(withMaxSize: 1024 * 1024) { (data, error) in
//            if error == nil {
//                self.generalImage = UIImage(data: data!)!
//                self.tableView.reloadData()
//            }
//            else {
//                print("Error fetching general image")
//            }
//        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setting frame of the gradient
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text! != "" {
            return 1
        }
        else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label: UILabel = UILabel()
        let attributedText = NSMutableAttributedString(string: "  ")
        
        if searchController.isActive && searchController.searchBar.text! != "" {
            attributedText.append(NSMutableAttributedString(string: "Search Results"))
        }
        else {
            attributedText.append(NSMutableAttributedString(string: self.tableViewSectionHeaderTitles[section]))
        }
        
        
        
        
        attributedText.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: NSRange(location: 0, length: attributedText.length))
        
        
        label.attributedText = attributedText
        
        label.backgroundColor = restaurantsColor
        
        return label
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && self.searchController.searchBar.text! != "" {
            return self.filteredRestaurants.count
        }
        else {
            if section == 0 {
                return self.restaurantsLow.count
            }
            else if section == 1 {
                return self.restaurantsMedium.count
            }
            else {
                return self.restaurantsHigh.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantsTableViewCell
        
        cell.picture.image = nil
        
        var ratingCount = 0
        
        if self.searchController.isActive && self.searchController.searchBar.text! != "" {
            cell.title.text = self.filteredRestaurants[indexPath.row].name
            cell.speciality.text = self.filteredRestaurants[indexPath.row].speciality
            cell.ratingsView.rating = Double(self.filteredRestaurants[indexPath.row].rating)
            
            let restaurant = self.filteredRestaurants[indexPath.row]
            
            ratingCount = restaurant.no1 + restaurant.no2 + restaurant.no3 + restaurant.no4 + restaurant.no5
            cell.ratingCount.text = "(\(ratingCount))"
            
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
            
            
        }
        else {
            
            let restaurant: Restaurant!
            
            if indexPath.section == 0 {
                
                cell.title.text = self.restaurantsLow[indexPath.row].name
                cell.speciality.text = self.restaurantsLow[indexPath.row].speciality
                cell.ratingsView.rating = Double(self.restaurantsLow[indexPath.row].rating)
                
                restaurant = self.restaurantsLow[indexPath.row]
                
            }
            else if indexPath.section == 1 {
                
                cell.title.text = self.restaurantsMedium[indexPath.row].name
                cell.speciality.text = self.restaurantsMedium[indexPath.row].speciality
                cell.ratingsView.rating = Double(self.restaurantsMedium[indexPath.row].rating)
                
                restaurant = self.restaurantsMedium[indexPath.row]
                
            }
            else {
                
                cell.title.text = self.restaurantsHigh[indexPath.row].name
                cell.speciality.text = self.restaurantsHigh[indexPath.row].speciality
                cell.ratingsView.rating = Double(self.restaurantsHigh[indexPath.row].rating)
                
                restaurant = self.restaurantsHigh[indexPath.row]
                
                
            }
            
            ratingCount = restaurant.no1 + restaurant.no2 + restaurant.no3 + restaurant.no4 + restaurant.no5

            cell.ratingCount.text = "(\(ratingCount))"
            
            
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
            
        }
        cell.ratingsView.setNeedsDisplay()
        cell.picture.layer.cornerRadius = (cell.frame.height - 16.0) / 2.0
        cell.picture.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // store details to send to next view
        if searchController.isActive && searchController.searchBar.text! != "" {
            self.selectedRestaurant = self.filteredRestaurants[indexPath.row]
        }
        else {
            if indexPath.section == 0 {
                self.selectedRestaurant = self.restaurantsLow[indexPath.row]
            }
            else if indexPath.section == 1 {
                self.selectedRestaurant = self.restaurantsMedium[indexPath.row]
            }
            else {
                self.selectedRestaurant = self.restaurantsHigh[indexPath.row]
            }
        }
        
        // perform segue
        self.performSegue(withIdentifier: "goToDetails", sender: self)
        
    }
    
    // MARK: Search Controller Functions
    
    func filterContentFor(searchText: String, scope: String = "All") {
        self.filteredRestaurants = self.restaurantsLow.filter({ rest in
            return rest.name.lowercased().contains(searchText.lowercased())
        })
        
        self.filteredRestaurants += self.restaurantsMedium.filter({ rest in
            return rest.name.lowercased().contains(searchText.lowercased())
        })
        
        self.filteredRestaurants += self.restaurantsHigh.filter({ rest in
            return rest.name.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            // pass data
            let destinationViewController = segue.destination as! RestaurantsDetailsViewController
            destinationViewController.restaurant = self.selectedRestaurant
        }
    }
    
    func createImageFromColor() -> UIImage {
    
        let imageSize = CGSize(width: 30, height: 30)
        let imageSizeRectF = CGRect(x: 0, y: 0, width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
//        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let color = UIColor.white.cgColor as CGColor
        context?.setFillColor(color)
        context?.fill(imageSizeRectF)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }

}

extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.textColor = newValue
            }
        }
    }
}
