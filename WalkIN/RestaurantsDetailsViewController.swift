//
//  RestaurantsDetailsViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 12/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class RestaurantsDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var shouldAddRatingGestureRecognizer = true
    var restaurant: Restaurant!
    var userRatingsView: RatingsView = RatingsView()
    var ratingCount = 0
    
    let sectionTitles = ["Speciality", "Description", "Address", "Contact", "Timings", "Website", "Home Delivery", "Ratings"]
    
    let generalImage: UIImage = UIImage(named: "generalRestaurant")!
    
    // MARK: Ratings variables
    var currentRestaurantUserRating = 0
    
    var userId = ""
    
    // MARK: Firebase variables
    
    let storageReference = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    let databaseReference = FIRDatabase.database().reference()
    
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting title
        self.title = self.restaurant.name
        
        // setting right bar button item as settings icon
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_icon"), style: .plain, target: self, action: #selector(RestaurantsDetailsViewController.goToSettings))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // get current database value for the given restaurant
        let restaurantReference = self.databaseReference.child("restaurants").child(self.restaurant.id)
        restaurantReference.observe(FIRDataEventType.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Error getting current data")
            }
            else {
                
                let value = snapshot.value as! [String: AnyObject]
                
                let homeDelivery = (value["home_delivery"] as? String) == "No" ? false : true
                
                self.restaurant = Restaurant(id: self.restaurant.id, rid: value["rid"] as! Int, name: value["name"] as! String, timings: value["timings"] as! String, contact: value["contact"] as! String, address: value["address"] as! String, speciality: value["speciality"] as! String, rdescription: value["description"] as! String, weblink: value["weblink"] as! String, homeDelivery: homeDelivery, no5: value["no5"] as! Int, no4: value["no4"] as! Int, no3: value["no3"] as! Int, no2: value["no2"] as! Int, no1: value["no1"] as! Int, rating: value["rating"] as! Float, images: value["images"] as! Int)
                self.tableView.reloadData()
            }
        })
        
        
        // increase views
        restaurantReference.child("views").runTransactionBlock({ (currentData) -> FIRTransactionResult in
            
            var value = currentData.value as? Int
            
            if (value == nil) {
                value = 0
            }
            currentData.value = value! + 1
            
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        
        // configuring page control
        
        self.pageControl.numberOfPages = self.restaurant.images == 0 ? 1 : self.restaurant.images
        if self.restaurant.images <= 1 {
            self.pageControl.isHidden = true
        }
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = restaurantsColor
        self.pageControl.addTarget(self, action: #selector(RestaurantsDetailsViewController.changePage(_:)), for: UIControlEvents.valueChanged)
        
        // configuring scroll view
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(self.pageControl.numberOfPages), height: UIScreen.main.bounds.width / 2.0)
        
        
        
        
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // loading images for scroll view
        var imageReference = self.storageReference.child("restaurants")
        if self.restaurant.images == 0 { // if there are no images available use the general image
            
            // adding to scroll view
            var frame = CGRect.zero
            
            frame.origin.x = 0.0
            frame.size = self.scrollView.frame.size
            self.scrollView.isPagingEnabled = true
            
            let imageView = UIImageView(frame: frame)
            imageView.image = self.generalImage
            
            self.scrollView.addSubview(imageView)
        }
            
        else { // else download images of the restaurant
            imageReference = imageReference.child(self.restaurant.id)
            
            for i in 1...self.restaurant.images {// downloading the number of images in the database
                imageReference.child("\(i).jpg").data(withMaxSize: 1024 * 1024, completion: { (data, error) in
                    if error == nil {
                        
                        
                        // adding to scroll view
                        var frame = CGRect.zero
                        
                        frame.origin.x = self.scrollView.frame.size.width * CGFloat(i-1)
                        frame.size = self.scrollView.frame.size
                        self.scrollView.isPagingEnabled = true
                        
                        let imageView = UIImageView(frame: frame)
                        imageView.image = UIImage(data: data!)
                        
                        self.scrollView.addSubview(imageView)
                        
                    }
                    else {
                        print(error.debugDescription)
                        
                        // handle error
                    }
                }) // end of firebase downloading
                
            } // end of for loop
            
        }// end of else dowloading images for restaurants
        
        
    }
    
        
    // MARK: Page Control
    func changePage(_ sender: AnyObject) {
        let x = CGFloat(self.pageControl.currentPage) * self.scrollView.frame.size.width
        self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
    }
    
    // MARK: Navigation
    
    func goToSettings() {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    // MARK: Table View Data Source Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30.0))
        
        headerView.backgroundColor = UIColor.white
        
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.tableView.frame.size.width - 40.0, height: 30.0))
        let attributedText = NSMutableAttributedString(string: self.sectionTitles[section])
        
        
//        attributedText.addAttributes([NSForegroundColorAttributeName: restaurantsColor], range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        
        let lineView = UIView(frame: CGRect(x: 1, y: 26, width: 40, height: 2))
        lineView.backgroundColor = UIColor(red: 254.0/255.0, green: 56.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        
        label.addSubview(lineView)
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let speciality = self.restaurant.speciality
            
            if speciality == "" {
                cell.details.text = "Not Available at the moment"
            }
            else {
                cell.details.text = speciality
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let restaurantDescription = self.restaurant.rdescription
            
            if restaurantDescription == ""{
                cell.details.text = "Not Available at the moment"
            }
            else {
                cell.details.text = restaurantDescription
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let address = self.restaurant.address
            
            if address == "" {
                cell.details.text = "Not Available at the moment"
            }
            else {
                cell.details.text = address
            }
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let contact = self.restaurant.contact
            
            if contact == "" {
                cell.details.text = "Not Available at the moment"
            }
            else {
                cell.details.text = contact
            }
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let timings = self.restaurant.timings
            
            if timings == "" {
                cell.details.text = "Not Available at the moment"
            }
            else {
                cell.details.text = timings
            }
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let website = self.restaurant.weblink
            
            if website == "" {
                cell.details.text = "Not Available at the moment"
            }
            else {
                cell.details.text = website
            }
            
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsDetailsCell", for: indexPath) as! RestaurantsDetailsTableViewCell
            
            let homedelivery = self.restaurant.homeDelivery
            
            if homedelivery == true {
                cell.details.text = "Yes"
            }
            else {
                cell.details.text = "No"
            }
            
            return cell
            
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsRatingsCell", for: indexPath) as! RestaurantsRatingsTableViewCell
            
            let ratingCount = self.restaurant.no1 + self.restaurant.no2 + self.restaurant.no3 + self.restaurant.no4 + self.restaurant.no5
            self.ratingCount = ratingCount
            
            cell.ratingIndicator1.percentage = CGFloat(self.restaurant.no1) / CGFloat(ratingCount)
            cell.ratingIndicator2.percentage = CGFloat(self.restaurant.no2) / CGFloat(ratingCount)
            cell.ratingIndicator3.percentage = CGFloat(self.restaurant.no3) / CGFloat(ratingCount)
            cell.ratingIndicator4.percentage = CGFloat(self.restaurant.no4) / CGFloat(ratingCount)
            cell.ratingIndicator5.percentage = CGFloat(self.restaurant.no5) / CGFloat(ratingCount)
            
            cell.ratingIndicator1.setNeedsDisplay()
            cell.ratingIndicator2.setNeedsDisplay()
            cell.ratingIndicator3.setNeedsDisplay()
            cell.ratingIndicator4.setNeedsDisplay()
            cell.ratingIndicator5.setNeedsDisplay()
            
            cell.ratingIndicator1.layer.cornerRadius = 1.5
            cell.ratingIndicator2.layer.cornerRadius = 1.5
            cell.ratingIndicator3.layer.cornerRadius = 1.5
            cell.ratingIndicator4.layer.cornerRadius = 1.5
            cell.ratingIndicator5.layer.cornerRadius = 1.5
            
            let ratingToRound = 10 * self.restaurant.rating
            let integerRating = round(ratingToRound)
            
            let actualRating = Float(integerRating) / 10.0
            
            
            
            cell.ratingLabel.text = "\(actualRating)"
            cell.ratingCountLabel.text = "(\(ratingCount))"
            
            if isGuest {
                cell.userRating.isHidden = true
            }
            else {
                self.userRatingsView = cell.userRating
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantsDetailsViewController.ratingsTapped(_:)))
                
                
                
                
                // changing the current rating to the user rating if he has rated
                if let user = FIRAuth.auth()?.currentUser {
                    
                    self.userId = user.uid
                    
                    if self.shouldAddRatingGestureRecognizer {
                        if let recognizers = self.userRatingsView.gestureRecognizers {
                            for recognizer in recognizers {
                                self.userRatingsView.removeGestureRecognizer(recognizer)
                            }
                            
                        }
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                    }
                    
                    
                    let ratingsReference = self.databaseReference.child("ratings").child(self.userId)
                    ratingsReference.observe(FIRDataEventType.value, with: { (snapshot) in
                        if !(snapshot.value is NSNull) {
                            
                            let snapshotValue = snapshot.value as! [String: AnyObject]
                            
                            if let currentRestaurantRating = snapshotValue[self.restaurant.id] as? Int {
                                self.currentRestaurantUserRating = currentRestaurantRating
                                
                                cell.userRating.rating = Double(currentRestaurantRating)
                                cell.userRating.setNeedsDisplay()
                                
                            }
                            else {
                                cell.userRating.rating = 0
                                cell.userRating.setNeedsDisplay()
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                    })
                }
                
                
            }
            
            return cell
            
            
        default:
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "")
            cell.backgroundColor = UIColor.clear
            return cell
            
            
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 7 {
            return 150.0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func ratingsTapped(_ sender: UITapGestureRecognizer) {
        
        //        if !self.isConnectedToNetwork() {
        //            print("Not connected to internet")
        //            return
        //        }
        
        self.userRatingsView.isUserInteractionEnabled = false
        
        if let recognizers = self.userRatingsView.gestureRecognizers {
            for recognizer in recognizers {
                self.userRatingsView.removeGestureRecognizer(recognizer)
            }
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantsDetailsViewController.ratingsTapped(_:)))
        
        let location = Double(sender.location(in: self.userRatingsView).x)
        let width = Double(self.userRatingsView.frame.width)
        
        let rating = round((location * 100 / width) / 20.0)
        
        self.userRatingsView.rating = rating == 0 ? 1.0 : rating
        self.userRatingsView.setNeedsDisplay()
        
        // update database
        
        let integerRating = Int(self.userRatingsView.rating)
        
        if self.currentRestaurantUserRating == integerRating {
            self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
            self.userRatingsView.isUserInteractionEnabled = true
            return
        }
        
        
        let restaurantReference = self.databaseReference.child("restaurants").child(self.restaurant.id)
        
        // checking if user has already rated
        if self.currentRestaurantUserRating == 0 { // user has not rated before
            
            // add new rating
            
            // create a new reference to the restaurant
            
            if self.userId == "" {
                print("could not connect to database")
                self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                return
                
            }
            
            self.currentRestaurantUserRating = integerRating
            
            // updating restaurant
            switch integerRating {
                
            case 1:
                
                restaurantReference.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                    
                    if var currentRestaurantData = currentData.value as? [String: AnyObject] {
                        
                        if var no1 = currentRestaurantData["no1"] as? Int, var rating = currentRestaurantData["rating"] as? Float, let no2 = currentRestaurantData["no2"] as? Int, let no3 = currentRestaurantData["no3"] as? Int, let no4 = currentRestaurantData["no4"] as? Int, let no5 = currentRestaurantData["no5"] as? Int{
                            
                            let ratingCount = no1 + no2 + no3 + no4 + no5
                            
                            rating = ((rating * Float(ratingCount)) + 1) / (Float(ratingCount) + 1)
                            no1 += 1
                            
                            currentRestaurantData["no1"] = no1 as AnyObject
                            currentRestaurantData["rating"] = rating as AnyObject
                            
                        }
                        
                        currentData.value = currentRestaurantData
                        return FIRTransactionResult.success(withValue: currentData)
                        
                    }
                    return FIRTransactionResult.success(withValue: currentData)
                    
                    
                    }, andCompletionBlock: { (error, committed, snapshot) in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                })
                
                
            case 2:
                
                restaurantReference.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                    if var currentRestaurantData = currentData.value as? [String: AnyObject] {
                        
                        if let no1 = currentRestaurantData["no1"] as? Int, var rating = currentRestaurantData["rating"] as? Float, var no2 = currentRestaurantData["no2"] as? Int, let no3 = currentRestaurantData["no3"] as? Int, let no4 = currentRestaurantData["no4"] as? Int, let no5 = currentRestaurantData["no5"] as? Int{
                            
                            let ratingCount = no1 + no2 + no3 + no4 + no5
                            
                            rating = ((rating * Float(ratingCount)) + 2) / (Float(ratingCount) + 1)
                            no2 += 1
                            
                            currentRestaurantData["no2"] = no2 as AnyObject
                            currentRestaurantData["rating"] = rating as AnyObject
                            
                        }
                        
                        currentData.value = currentRestaurantData
                        return FIRTransactionResult.success(withValue: currentData)
                        
                    }
                    return FIRTransactionResult.success(withValue: currentData)
                    
                    
                    }, andCompletionBlock: { (error, committed, snapshot) in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                })
                
                
            case 3:
                
                restaurantReference.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                    
                    if var currentRestaurantData = currentData.value as? [String: AnyObject] {
                        
                        if let no1 = currentRestaurantData["no1"] as? Int, var rating = currentRestaurantData["rating"] as? Float, let no2 = currentRestaurantData["no2"] as? Int, var no3 = currentRestaurantData["no3"] as? Int, let no4 = currentRestaurantData["no4"] as? Int, let no5 = currentRestaurantData["no5"] as? Int{
                            
                            let ratingCount = no1 + no2 + no3 + no4 + no5
                            
                            rating = ((rating * Float(ratingCount)) + 3) / (Float(ratingCount) + 1)
                            no3 += 1
                            
                            currentRestaurantData["no3"] = no3 as AnyObject
                            currentRestaurantData["rating"] = rating as AnyObject
                            
                        }
                        
                        currentData.value = currentRestaurantData
                        return FIRTransactionResult.success(withValue: currentData)
                        
                    }
                    return FIRTransactionResult.success(withValue: currentData)
                    
                    
                    }, andCompletionBlock: { (error, committed, snapshot) in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                })
                
                
            case 4:
                
                restaurantReference.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                    
                    if var currentRestaurantData = currentData.value as? [String: AnyObject] {
                        
                        if let no1 = currentRestaurantData["no1"] as? Int, var rating = currentRestaurantData["rating"] as? Float, let no2 = currentRestaurantData["no2"] as? Int, let no3 = currentRestaurantData["no3"] as? Int, var no4 = currentRestaurantData["no4"] as? Int, let no5 = currentRestaurantData["no5"] as? Int{
                            
                            let ratingCount = no1 + no2 + no3 + no4 + no5
                            
                            rating = ((rating * Float(ratingCount)) + 4) / (Float(ratingCount) + 1)
                            no4 += 1
                            
                            currentRestaurantData["no4"] = no4 as AnyObject
                            currentRestaurantData["rating"] = rating as AnyObject
                            
                        }
                        
                        currentData.value = currentRestaurantData
                        return FIRTransactionResult.success(withValue: currentData)
                        
                    }
                    return FIRTransactionResult.success(withValue: currentData)
                    
                    
                    }, andCompletionBlock: { (error, committed, snapshot) in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                })
                
                
                
            case 5:
                
                restaurantReference.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                    
                    if var currentRestaurantData = currentData.value as? [String: AnyObject] {
                        
                        if let no1 = currentRestaurantData["no1"] as? Int, var rating = currentRestaurantData["rating"] as? Float, let no2 = currentRestaurantData["no2"] as? Int, let no3 = currentRestaurantData["no3"] as? Int, let no4 = currentRestaurantData["no4"] as? Int, var no5 = currentRestaurantData["no5"] as? Int{
                            
                            let ratingCount = no1 + no2 + no3 + no4 + no5
                            
                            rating = ((rating * Float(ratingCount)) + 5) / (Float(ratingCount) + 1)
                            no5 += 1
                            
                            currentRestaurantData["no5"] = no5 as AnyObject
                            currentRestaurantData["rating"] = rating as AnyObject
                            
                        }
                        
                        currentData.value = currentRestaurantData
                        return FIRTransactionResult.success(withValue: currentData)
                        
                    }
                    return FIRTransactionResult.success(withValue: currentData)
                    
                    
                    }, andCompletionBlock: { (error, committed, snapshot) in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                        if committed == false {
                            print("Ratings could not be updated at the moment")
                        }
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                })
                
                
            default: break
                
            } // end of switch case
            
        }// end of currentRating == 0
            
        else {
            
            // changing the existing rating
            
            restaurantReference.runTransactionBlock({ (currentData) -> FIRTransactionResult in
                
                
                if var currentRestaurantData = currentData.value as? [String: AnyObject] {
                    
                    let newRating = "no\(integerRating)"
                    let oldRating = "no\(self.currentRestaurantUserRating)"
                    
                    if var new = currentRestaurantData[newRating] as? Int, var old = currentRestaurantData[oldRating] as? Int, var rating = currentRestaurantData["rating"] as? Float, let no1 = currentRestaurantData["no1"] as? Int, let no2 = currentRestaurantData["no2"] as? Int, let no3 = currentRestaurantData["no3"] as? Int, let no4 = currentRestaurantData["no4"] as? Int, let no5 = currentRestaurantData["no5"] as? Int {
                        
                        new += 1
                        old -= 1
                        
                        let ratingCount = no1 + no2 + no3 + no4 + no5
                        
                        rating = ((rating * Float(ratingCount)) + Float(integerRating) - Float(self.currentRestaurantUserRating)) / Float(self.ratingCount)
                        
                        currentRestaurantData[oldRating] = old as AnyObject
                        currentRestaurantData[newRating] = new as AnyObject
                        currentRestaurantData["rating"] = rating as AnyObject
                        
                    }
                    
                    currentData.value = currentRestaurantData
                    
                    return FIRTransactionResult.success(withValue: currentData)
                    
                }
                return FIRTransactionResult.success(withValue: currentData)
                
                
                }, andCompletionBlock: { (error, committed, snapshot) in
                    
                    
                    if error != nil {
                        print(error?.localizedDescription)
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                    }
                    if committed == false {
                        print("Ratings could not be updated at the moment")
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                    }
                    else {
                        // changing current user rating to the rating
                        self.currentRestaurantUserRating = integerRating
                        self.userRatingsView.addGestureRecognizer(tapGestureRecognizer)
                        
                    }
                    
                    
                    
                    
            })
            
            
        }
        
        // updating user ratings
        let ratingsReference = self.databaseReference.child("ratings").child(self.userId)
        ratingsReference.updateChildValues([self.restaurant.id : integerRating])
        
        
        
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.userRatingsView.isUserInteractionEnabled = true
        }
        
    }

    

}
