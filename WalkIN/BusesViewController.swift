//
//  BusesViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 08/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BusesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBInspectable var themeColor: UIColor = UIColor.green
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    var isDestinationSelected: Bool = false
    var isTableViewInDestinationMode: Bool = false
    
    var destination: String = ""
    
    var center: CGFloat = 0.0
    
    // MARK: Loading animation
    let loadingImageView = UIView()
    let containerLayer = CALayer()
    let imageLayer = CALayer()
    
    // MARK: Firebase variables
    
    let databaseReference = FIRDatabase.database().reference()
    
    var buses: [Buses] = []
    var filteredBuses: [Buses] = []
    
    // MARK: View Lifecycle
    
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
        
        
        // setting right bar button item as settings icon
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_icon"), style: .plain, target: self, action: #selector(BusesViewController.goToSettings))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        
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
        self.imageLayer.contents = BusIcon().busIcon.cgImage
        
        
        self.containerLayer.addSublayer(self.imageLayer)
        
        self.loadingImageView.layer.addSublayer(self.containerLayer)
        
        self.view.addSubview(self.loadingImageView)
        
        // getting data from firebase
        
        self.fromButton.isEnabled = false
        
        self.databaseReference.child("travel").child("buses").observe(FIRDataEventType.value, with: { (snapshot) in
            if !(snapshot.value is NSNull) {
                let dataDictionary = snapshot.value as! [String: AnyObject]
                
                self.buses = [Buses]()
                for data in dataDictionary {
                    
                    let key = data.key
                    let value = data.value as! NSDictionary
                    
                    let bus = Buses(key: key, name: value["name"]! as! String, boardingPoint: value["boardingPoint"]! as! String, busType: value["busType"]! as! String, departureTime: value["departure"]! as! String, destination: value["destination"]! as! String)
                    
                    self.buses.append(bus)
                    
                }
                
                self.loadingImageView.removeFromSuperview()
                self.fromButton.isEnabled = true
                
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            
            print("There was some error in retrieving movie theatre data")
            
        }

        // setting table view border
        
//        self.tableView.layer.cornerRadius = 5.0
//        self.tableView.clipsToBounds = true
        
        self.tableView.layer.masksToBounds = true
        self.tableView.layer.borderColor = self.themeColor.cgColor
        self.tableView.layer.borderWidth = 2.0
        
        
        
        
        // refreshing view
        self.isDestinationSelected = false
        self.destination = ""
        self.isTableViewInDestinationMode = false
        self.tableView.isHidden = true
        
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
        
        if self.center == 0.0 {
            self.center = self.tableView.center.x
        }
        
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.isTableViewInDestinationMode {
            return self.filteredBuses.count
        }
        else {
            return self.buses.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !self.isTableViewInDestinationMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "busesDataCell", for: indexPath) as! BusesDataTableViewCell
            
            cell.name.text = self.filteredBuses[indexPath.row].name
            cell.busType.text = self.filteredBuses[indexPath.row].busType
            cell.boardFrom.text = "Board From \(self.filteredBuses[indexPath.row].boardingPoint)"
            cell.departsAt.text = "Departs At \(self.filteredBuses[indexPath.row].departureTime)"
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCell", for: indexPath) as! BusesDestinationTableViewCell
            
            cell.destination.text = self.buses[indexPath.row].destination
            
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isTableViewInDestinationMode {
            tableView.deselectRow(at: indexPath, animated: true)
            self.destination = self.buses[indexPath.row].destination
            self.isDestinationSelected = true
            
            // change from button title
            self.fromButton.setTitle(self.destination, for: UIControlState.normal)
            
            self.filteredBuses = self.buses.filter({ rest in
                return rest.destination == self.destination
            })
            
            self.selectDestination(self)
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.isTableViewInDestinationMode {
            return 50.0
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    @IBAction func selectDestination(_ sender: Any) {
        
        if self.isTableViewInDestinationMode {
            self.tableView.allowsSelection = false
            self.fromButton.setTitle(self.destination, for: UIControlState.normal)
            self.fromButton.isEnabled = true
        }
        else {
            self.tableView.allowsSelection = true
            self.fromButton.isEnabled = false
        }
        
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 0.0
        }, completion: { (finished) in
            
            self.tableView.center.x = -self.center
            self.tableView.alpha = 1.0
            self.isTableViewInDestinationMode = !self.isTableViewInDestinationMode
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: UITableViewScrollPosition.top, animated: false)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.center.x = self.center
            }, completion: nil)
            
        })
        
//        UIView.animate(withDuration: 0.5, animations: {
//            
//            self.tableView.center.x = self.center + self.view.bounds.width
//            
//            
//        }, completion: { (finished) in
//            
//            self.tableView.center.x = -self.center
//            self.tableView.isHidden = false
//            self.isTableViewInDestinationMode = !self.isTableViewInDestinationMode
//            self.tableView.reloadData()
//            self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: UITableViewScrollPosition.top, animated: false)
//            
//            UIView.animate(withDuration: 0.5, animations: {
//                self.tableView.center.x = self.center
//            }, completion: nil)
//        })
        
        
        
        
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

}
