//
//  TouristSpotDetailsViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 28/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class TouristSpotDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var touristSpot: TouristSpot!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBInspectable var themeColor: UIColor = UIColor.red
    
    let sectionTitles = ["Description", "Timings", "Address", "Entry Fee", "Do's and Don'ts"]
    
    var sectionDetails: [String] = ["", "", "", "", ""]
    
    let gradientLayer = CAGradientLayer()
    
    let generalImage: UIImage = UIImage(named: "generalTouristSpot")!
    
    // MARK: Firebase variables
    
    let storageReference = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    let databaseReference = FIRDatabase.database().reference()
    
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up background gradient
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor(red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2]
        self.gradientLayer.locations = [0.0, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 0.8, y: 0.8)
        self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.backgroundImageView.layer.addSublayer(self.gradientLayer)
        
        // setting up title
        self.title = self.touristSpot.name
        
        // setting right bar button item as settings icon
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_icon"), style: .plain, target: self, action: #selector(TouristSpotDetailsViewController.goToSettings))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // getting current database value for the given tourist spot
        let touristReference = self.databaseReference.child("touristSpots").child(self.touristSpot.key)
        touristReference.observe(FIRDataEventType.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                print("Error getting current data")
            }
            else {
                let value = snapshot.value as! [String: AnyObject]
                
                self.touristSpot = TouristSpot(key: self.touristSpot.key, name: value["name"] as! String, tdescription: value["description"] as! String, timings: value["timings"] as! String, entryFee: value["entryFee"] as! String, address: value["address"] as! String, dosAndDonts: value["dos_and_donts"] as! String, images: value["images"] as! Int)
                
                // populating section details
                self.sectionDetails = [String]()
                self.sectionDetails.append(value["description"] as! String)
                self.sectionDetails.append(value["timings"] as! String)
                self.sectionDetails.append(value["address"] as! String)
                self.sectionDetails.append(value["entryFee"] as! String)
                self.sectionDetails.append(value["dos_and_donts"] as! String)
                
                self.tableView.reloadData()
                
            }
        })
        
        // increase views
        touristReference.child("views").runTransactionBlock({ (currentData) -> FIRTransactionResult in
            
            var value =  currentData.value as? Int
            
            if value == nil {
                value = 0
            }
            currentData.value = value! + 1
            
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if error != nil {
                print(error.debugDescription)
            }
        }

        // configuring page control
        
        self.pageControl.numberOfPages = self.touristSpot.images == 0 ? 1 : self.touristSpot.images
        
        if self.touristSpot.images <= 1 {
            self.pageControl.isHidden = true
        }
        
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = self.themeColor
        self.pageControl.addTarget(self, action: #selector(TouristSpotDetailsViewController.changePage(_sender:)), for: UIControlEvents.valueChanged)
        
        // configuring scroll view
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(self.pageControl.numberOfPages), height: UIScreen.main.bounds.width / 2.0)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientLayer.frame = self.backgroundImageView.bounds
        
        // loading images for scroll view
        
        var imageReference = self.storageReference.child("touristSpots")
        if self.touristSpot.images == 0 { // if there are no images then use general images
            
            // adding to scroll view
            var frame = CGRect.zero
            
            frame.origin.x = 0.0
            
            frame.size = self.scrollView.frame.size
            
            self.scrollView.isPagingEnabled = true
            
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .scaleToFill
            imageView.image = self.generalImage
            
            self.scrollView.addSubview(imageView)
            
        }
        else { // else download images of the restaurant
            
            imageReference = imageReference.child(self.touristSpot.key)
            
            for i in 1...self.touristSpot.images { // downloading the number of images in the database
                
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
                }) //end of firebase downloading
                
            } // end of for loop
            
        } // end of else downloading images
        
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


    // MARK: Page Control
    func changePage(_sender: AnyObject) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            let destinationViewController = segue.destination as! UserViewController
            destinationViewController.themeColor = self.themeColor
        }
    }
    
    // MARK: Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label: UILabel = UILabel()
        let attributedText = NSMutableAttributedString(string: "  " + self.sectionTitles[section])
        
        attributedText.addAttributes([NSForegroundColorAttributeName: self.themeColor], range: NSRange(location: 0, length: attributedText.length))
        
        
        label.attributedText = attributedText
        label.backgroundColor = UIColor.black
        
        return label
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "touristSpotDetailsCell", for: indexPath) as! TouristSpotDetailsTableViewCell
        
        cell.detailsLabel.text = self.sectionDetails[indexPath.section]
        cell.detailsLabel.textColor = UIColor.white
        
        return cell
    }
    
    
}
