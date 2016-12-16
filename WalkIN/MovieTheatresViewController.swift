//
//  MovieTheatresViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 22/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class MovieTheatresViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let gradientLayer = CAGradientLayer()
    
    var themeColor: UIColor = UIColor(red: 93.0/255.0, green: 57.0/255.0, blue: 196.0/255.0, alpha: 1.0)
    var trending: Bool = false
    
    // MARK: Loading animation
    let loadingImageView = UIView()
    let containerLayer = CALayer()
    let imageLayer = CALayer()
    
    // MARK: Firebase variables
    
    let storageReference = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    let databaseReference = FIRDatabase.database().reference()
    
    var movieTheatres: [MovieTheatre] = []
    
    var images: [String: UIImage] = [:]
    
    var detailsHidden: [Bool] = []
    
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting navigation bar as transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = self.themeColor

        // setting up background gradient
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor(red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2, color1]
        self.gradientLayer.locations = [0.0, 0.2, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundImageView.layer.addSublayer(self.gradientLayer)
        
        // setting title
        self.title = "Movie Theatres"
        
        // setting right bar button item as settings icon
        let settingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting_icon"), style: .plain, target: self, action: #selector(MovieTheatresViewController.goToSettings))
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
        
        // setting back button to be empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // disabling settings view for guest users
        if isGuest {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // adding loading view
        
        self.loadingImageView.backgroundColor = UIColor(red: 107.0/255.0, green: 48.0/255.0, blue: 209.0/255.0, alpha: 1.0)
        
        self.imageLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.imageLayer.contents = MovieTheatresIcon().movieTheatreIcon.cgImage
        
        
        self.containerLayer.addSublayer(self.imageLayer)
        
        self.loadingImageView.layer.addSublayer(self.containerLayer)
        
        self.view.addSubview(self.loadingImageView)
        
        
        // load movie theatres data
       
        if self.trending {
            
            self.databaseReference.child("entertainment").child("trendingMovieTheatres").observe(FIRDataEventType.value, with: { (snapshot) in
                if !(snapshot.value is NSNull) {
                    let dataDictionary = snapshot.value as! [String: AnyObject]
                    
                    self.movieTheatres = [MovieTheatre]()
                    self.detailsHidden = [Bool]()
                    for data in dataDictionary {
                        
                        let key = data.key
                        let value = data.value as! [String: String]
                        
                        let movieTheatre = MovieTheatre(key: key, name: value["name"]!, contact: value["contact"]!, address: value["address"]!, ac_non: value["ac_non"]!)
                        
                        self.movieTheatres.append(movieTheatre)
                        self.detailsHidden.append(false)
                        
                    }
                    
                    self.loadingImageView.removeFromSuperview()
                    
                    self.collectionView.reloadData()
                    
                }
                
            }) { (error) in
                
                print("There was some error in retrieving movie theatre data")
                
            }

            
        }
        else {
            
            self.databaseReference.child("entertainment").child("movieTheatres").observe(FIRDataEventType.value, with: { (snapshot) in
                if !(snapshot.value is NSNull) {
                    let dataDictionary = snapshot.value as! [String: AnyObject]
                    
                    self.movieTheatres = [MovieTheatre]()
                    self.detailsHidden = [Bool]()
                    for data in dataDictionary {
                        
                        let key = data.key
                        let value = data.value as! [String: String]
                        
                        let movieTheatre = MovieTheatre(key: key, name: value["name"]!, contact: value["contact"]!, address: value["address"]!, ac_non: value["ac_non"]!)
                        
                        self.movieTheatres.append(movieTheatre)
                        self.detailsHidden.append(false)
                        
                    }
                    
                    self.loadingImageView.removeFromSuperview()
                    
                    self.collectionView.reloadData()
                    
                }
                
            }) { (error) in
                
                print("There was some error in retrieving movie theatre data")
                
            }

            
        }
        
        
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientLayer.frame = self.backgroundImageView.bounds
        
        self.loadingImageView.frame = self.collectionView.frame
        
        self.containerLayer.frame = CGRect(origin: CGPoint(x: self.collectionView.center.x - 50, y: self.collectionView.frame.height/2 - 50), size: CGSize(width: 100, height: 100))
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

    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieTheatres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieTheatresCollectionViewCell", for: indexPath) as! MovieTheatresCollectionViewCell
        
        cell.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        
        cell.detailsView.layer.cornerRadius = 5.0
        cell.detailsView.clipsToBounds = true
        
        cell.detailsView.center.y = (self.collectionView.bounds.height - 40) - (cell.detailsView.bounds.height / 2) + 5
        
        cell.tableView.tag = indexPath.row + 100
        cell.tableView.dataSource = self
        cell.tableView.delegate = self
        
        cell.showHideDetailsButton.tag = indexPath.row + 200
        
        cell.titleLabel.text = self.movieTheatres[indexPath.row].name
        
        cell.showHideDetailsButton.addTarget(self, action: #selector(MovieTheatresViewController.showHideTheatreDetails(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let castedCell = cell as! MovieTheatresCollectionViewCell
        
        
        
        if self.detailsHidden[indexPath.row] {
            castedCell.detailsView.center.y = (self.collectionView.bounds.height - 40) + (castedCell.detailsView.bounds.height / 2) - 43
            castedCell.showHideDetailsButton.setTitle("Show details", for: UIControlState.normal)
        }
        else {
            castedCell.detailsView.center.y = (self.collectionView.bounds.height - 40) - (castedCell.detailsView.bounds.height / 2) + 5
            castedCell.showHideDetailsButton.setTitle("Hide details", for: UIControlState.normal)
        }
        
        if let image = self.images[self.movieTheatres[indexPath.row].key] {
            castedCell.movieTheatreImage.image = image
        }
        else {
            let imageReference = self.storageReference.child("movieTheatres")
            
            imageReference.child(self.movieTheatres[indexPath.row].key + ".jpg").data(withMaxSize: 1024 * 1024, completion: { (data, error) in
                if error == nil {
                    let image = UIImage(data: data!)
                    castedCell.movieTheatreImage.image = image
                    self.images[self.movieTheatres[indexPath.row].key] = image
                }
                else {
                    print(error.debugDescription)
                }
            })
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: Collection View Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = self.collectionView.bounds.height
        
        return CGSize(width: width - 40.0, height: height - 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    // MARK: Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTheatreDetailsTableViewCell", for: indexPath) as! MovieTheatreDetailsTableViewCell
        
        let index = tableView.tag - 100
        
        if indexPath.row == 0 {
            cell.detailTitle.text = "Contact"
            cell.detailsLabel.text = self.movieTheatres[index].contact
        }
        else if indexPath.row == 1 {
            cell.detailTitle.text = "Address"
            cell.detailsLabel.text = self.movieTheatres[index].address
        }
        else {
            cell.detailTitle.text = "AC/NON-AC"
            cell.detailsLabel.text = self.movieTheatres[index].ac_non ? "Yes" : "No"
        }
        
        return cell
    }
    
    // MARK: Animation
    
    func showHideTheatreDetails(_ sender: UIButton!) {
        let superView = sender.superview!
        
        if sender.titleLabel?.text == "Hide details" {
            
            self.detailsHidden[sender.tag - 200] = true
            
            self.collectionView.isScrollEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: { 
                superView.center.y = (self.collectionView.bounds.height - 40) + (superView.bounds.height / 2) - 43
                }, completion: { (finished) in
                    sender.setTitle("Show details", for: UIControlState.normal)
                    self.collectionView.isScrollEnabled = true
            })
        }
        else if sender.titleLabel?.text == "Show details" {
            
            self.detailsHidden[sender.tag - 200] = false
            
            self.collectionView.isScrollEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                superView.center.y = (self.collectionView.bounds.height - 40) - (superView.bounds.height / 2) + 5
                }, completion: { (finished) in
                    sender.setTitle("Hide details", for: UIControlState.normal)
                    self.collectionView.isScrollEnabled = true
            })
        }

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
