//
//  CabsViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CabsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBInspectable var themeColor: UIColor = UIColor.green
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    // MARK: Loading animation
    let loadingImageView = UIView()
    let containerLayer = CALayer()
    let imageLayer = CALayer()
    
    // MARK: Firebase Variables
    
    let databaseReference = FIRDatabase.database().reference()
    
    var cabs: [Cab] = []
    var filteredCabs: [Cab] = []
    
    // MARK: Search controller
    
     let searchController = UISearchController(searchResultsController: nil)
    
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
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // adding loading view
        
        self.loadingImageView.backgroundColor = self.themeColor
        
        self.imageLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.imageLayer.contents = CabIcon().cabIcon.cgImage
        
        
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
        
        // getting data from firebase
        
        self.databaseReference.child("travel").child("cabs").observe(FIRDataEventType.value, with: { (snapshot) in
            if !(snapshot.value is NSNull) {
                let dataDictionary = snapshot.value as! [String: AnyObject]
                
                self.cabs = [Cab]()
                for data in dataDictionary {
                    
                    let key = data.key
                    let value = data.value as! NSDictionary
                    
                    let cab = Cab(key: key, name: value["name"] as! String, carVariety: value["carVariety"] as! String, contact: value["contact"] as! String, website: value["website"] as! String)
                    
                    self.cabs.append(cab)
                    
                }
                
                self.loadingImageView.removeFromSuperview()
                
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            
            print("There was some error in retrieving movie theatre data")
            
        }

        
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
        
        self.loadingImageView.frame = self.tableView.frame
        
        self.containerLayer.frame = CGRect(origin: CGPoint(x: self.tableView.center.x - 50, y: self.tableView.frame.height/2 - 50), size: CGSize(width: 100, height: 100))
        
    }
    
    // MARK: Table View Functions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && self.searchController.searchBar.text! != "" {
            return self.filteredCabs.count
        }
        else {
            return self.cabs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cabDetailsCell", for: indexPath) as! CabDetailsTableViewCell
        
        if self.searchController.isActive && self.searchController.searchBar.text! != "" {
            cell.name.text = self.filteredCabs[indexPath.row].name
            cell.carTypes.text = self.filteredCabs[indexPath.row].carVariety
            cell.contact.text = self.filteredCabs[indexPath.row].contact
            cell.website.text = self.filteredCabs[indexPath.row].website
        
        }
        else {
            
            cell.name.text = self.cabs[indexPath.row].name
            cell.carTypes.text = self.cabs[indexPath.row].carVariety
            cell.contact.text = self.cabs[indexPath.row].contact
            cell.website.text = self.cabs[indexPath.row].website
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Search Controller Functions
    
    func filterContentFor(searchText: String, scope: String = "All") {
        self.filteredCabs = self.cabs.filter({ (rest) -> Bool in
            return rest.name.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentFor(searchText: searchController.searchBar.text!)
    }

    
    

}
