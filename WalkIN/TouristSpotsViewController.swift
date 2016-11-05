//
//  TouristSpotsViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class TouristSpotsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var trending: Bool = false
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var themeColor: UIColor = UIColor.red
    
    let generalImage: UIImage = UIImage(named: "generalTouristSpot")!
    
    var images: [String: UIImage] = [:]
    
    // MARK: Loading animation
    let loadingImageView = UIView()
    let containerLayer = CALayer()
    let imageLayer = CALayer()
    
    // MARK: Firebase Variables
    
    let storageReference = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    let databaseReference = FIRDatabase.database().reference()
    
    var touristSpots: [TouristSpot] = []
    
    var filteredTouristSpots: [TouristSpot] = []
    
    // MARK: Table View Variables
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Navigation Variables
    
    var selectedTouristSpot: TouristSpot!

    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting navigation bar as transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = self.themeColor
        
        // setting table view row height
        self.tableView.rowHeight = 84.0
        
        // setting up background gradient
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor(red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2]
        self.gradientLayer.locations = [0.0, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.backgroundImageView.layer.addSublayer(self.gradientLayer)
        
        // setting title
        self.title = "Tourist Spots"
        
        // setting right bar button item as settings icon
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_icon"), style: .plain, target: self, action: #selector(MovieTheatresViewController.goToSettings))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        self.loadingImageView.backgroundColor = self.themeColor
        
        self.imageLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.imageLayer.contents = TouristSpotIcon().touristSpotIcon.cgImage
        
        self.containerLayer.addSublayer(self.imageLayer)
        
        self.loadingImageView.layer.addSublayer(self.containerLayer)
        
        self.view.addSubview(self.loadingImageView)
        
        // search controller
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        // modifying search controller UI
        self.searchController.searchBar.backgroundColor = UIColor.black
        self.searchController.searchBar.barTintColor = UIColor.black
        self.searchController.searchBar.tintColor = self.themeColor
        self.searchController.searchBar.backgroundImage = UIImage()
        
        // loading tourist spots data
        if self.trending {
            self.databaseReference.child("touristSpots").queryOrdered(byChild: "views").queryLimited(toLast: 10).observe(FIRDataEventType.value, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("There was some error fetching trending tourist spot data")
                }
                else {
                    
                    let dataDictionary = snapshot.value as! [String: AnyObject]
                    
                    self.touristSpots = [TouristSpot]()
                    
                    for data in dataDictionary {
                        
                        let key = data.key
                        
                        let value = data.value as! [String: AnyObject]
                        
                        let touristSpot = TouristSpot(key: key, name: value["name"] as! String, tdescription: value["description"] as! String, timings: value["timings"] as! String, entryFee: value["entryFee"] as! String, address: value["address"] as! String, dosAndDonts: value["dos_and_donts"] as! String, images: value["images"] as! Int)
                        
                        self.touristSpots.append(touristSpot)
                        
                    }
                    
                    self.loadingImageView.removeFromSuperview()
                    self.tableView.reloadData()
                    
                }
                
            })
        }
        else {
            
            self.databaseReference.child("touristSpots").observe(FIRDataEventType.value, with: { (snapshot) in
                
                
                
                if snapshot.value is NSNull {
                    print("There was some error fetching trending tourist spot data")
                }
                else {
                    
                    let dataDictionary = snapshot.value as! [String: AnyObject]
                    
                    self.touristSpots = [TouristSpot]()
                    
                    for data in dataDictionary {
                        
                        let key = data.key
                        
                        let value = data.value as! [String: AnyObject]
                        
                        let touristSpot = TouristSpot(key: key, name: value["name"] as! String, tdescription: value["description"] as! String, timings: value["timings"] as! String, entryFee: value["entryFee"] as! String, address: value["address"] as! String, dosAndDonts: value["dos_and_donts"] as! String, images: value["images"] as! Int)
                        
                        self.touristSpots.append(touristSpot)
                        
                    }
                    
                    self.loadingImageView.removeFromSuperview()
                    self.tableView.reloadData()
                    
                }

                
            })
        }
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientLayer.frame = self.backgroundImageView.frame
        
        self.loadingImageView.frame = self.tableView.frame
        
        self.containerLayer.frame = CGRect(origin: CGPoint(x: self.tableView.center.x - 50, y: self.tableView.frame.height/2 - 50), size: CGSize(width: 100, height: 100))
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            return self.filteredTouristSpots.count
        }
        else {
            return self.touristSpots.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "touristSpotsCell", for: indexPath) as! TouristSpotsTableViewCell
        
        cell.picture.image = nil
        
        cell.picture.layer.cornerRadius = (cell.frame.height - 16) / 2.0
        cell.picture.clipsToBounds = true
        
        let touristSpot: TouristSpot!
        
        if self.searchController.isActive && self.searchController.searchBar.text! != "" {
            touristSpot = self.filteredTouristSpots[indexPath.row]
        }
        else {
            touristSpot = self.touristSpots[indexPath.row]
        }
        
        cell.title.text = touristSpot.name
        cell.addressLabel.text = touristSpot.address
        
        cell.title.textColor = self.themeColor
        cell.addressLabel.textColor = self.themeColor
        
        if touristSpot.images == 0 {
            cell.picture.image = self.generalImage
        }
        else {
            
            if let image = self.images[touristSpot.key] {
                cell.picture.image = image
            }
            else {
                let imageReference = self.storageReference.child("touristSpots").child(touristSpot.key).child("1.jpg")
                imageReference.data(withMaxSize: 1024 * 1024, completion: { (data, error) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        self.images[touristSpot.key] = image
                    }
                })

            }
            
        }
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.searchController.isActive && self.searchController.searchBar.text! != "" {
            self.selectedTouristSpot = self.filteredTouristSpots[indexPath.row]
        }
        else {
            self.selectedTouristSpot = self.touristSpots[indexPath.row]
        }
        self.performSegue(withIdentifier: "showTouristSpotDetails", sender: self)
        
    }
    
    // MARK: Search Controller Functions
    func fileterContentsFor(searchText: String, scope: String = "All") {
        
        self.filteredTouristSpots = [TouristSpot]()
        
        self.filteredTouristSpots += self.filteredTouristSpots.filter({ (rest) -> Bool in
            return rest.name.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.fileterContentsFor(searchText: searchController.searchBar.text!)
    }
    
    // MARK: Navigation
    func goToSettings() {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            let destinationViewController = segue.destination as! UserViewController
            destinationViewController.themeColor = self.themeColor
        }
        else if segue.identifier == "showTouristSpotDetails" {
            let destinationViewController = segue.destination as! TouristSpotDetailsViewController
            destinationViewController.touristSpot = self.selectedTouristSpot
        }
        
    }
    
}
