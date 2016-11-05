//
//  UserViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 12/10/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FBSDKLoginKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    let gradientLayer = CAGradientLayer()
    
    let keys = ["Name" , "Email", "Password", "Phone"]
    
    var userData: [String: String] = [:]
    
    var themeColor: UIColor = UIColor.white
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: Firebase References
    let storageRef = FIRStorage.storage().reference(forURL: "gs://walkin-2845c.appspot.com")
    let databaseReference = FIRDatabase.database().reference()
    
    var UID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting table view UI
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        // logout button
        let logoutBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(UserViewController.logoutButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = logoutBarButtonItem
        
        // setting title
        self.title = "Settings"
        
        // adding background gradient
        
        let color1 = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor as CGColor
        let color2 = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0).cgColor as CGColor
        self.gradientLayer.colors = [color1, color2]
        self.gradientLayer.locations = [0.0, 1.0]
        self.backgroundImageView.layer.insertSublayer(self.gradientLayer, at: 0)
        
        // setting name label textColor
        self.nameLabel.textColor = self.themeColor
        
        // setup user details
        
        if let imageData = UserDefaults.standard.object(forKey: "userImage") as? Data {
            self.userImageView.image = UIImage(data: imageData)
        }
        
        if let name = UserDefaults.standard.value(forKey: "name") {
            self.userData["Name"] = (name as? String)!
            
            self.nameLabel.text = (name as? String)!.components(separatedBy: " ").first!
            
            if let email = UserDefaults.standard.value(forKey: "email") {
                self.userData["Email"] = (email as? String)!
            }
            self.userData["Password"] = "(Facebook Login)"
            if let phone = UserDefaults.standard.value(forKey: "phone") {
                self.userData["Phone"] = (phone as? String)!
            }
            
            if let user = FIRAuth.auth()?.currentUser {
                self.UID = user.uid
            }
            
        }
        else {
            self.setupUserDetails()
        }
        
    }
    
    func setupUserDetails() {
        
        // setting up username options
        if let user = FIRAuth.auth()?.currentUser { // if user is logged in
            
            let uid = user.uid
            self.UID = uid
            
            // checking if the values are present in the database
            self.databaseReference.child("users/\(uid)").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                // if values are present in the database
                if !(snapshot.value is NSNull) {
                    
                    let userDict = snapshot.value as! [String: String]
                    self.userData["Name"] = userDict["name"]
                    self.userData["Email"] = userDict["email"]
                    self.userData["Password"] = "(Facebook Login)"// change later on
                    self.userData["Phone"] = userDict["phone"]
                    
                    // setting name label
                    self.nameLabel.text = self.userData["Name"]?.components(separatedBy: " ").first!
                    self.tableView.reloadData()
                    
                    // setting user defaults
                    UserDefaults.standard.set(self.userData["Name"], forKey: "name")
                    UserDefaults.standard.set(self.userData["Email"], forKey: "email")
                    UserDefaults.standard.set(self.userData["Password"], forKey: "password")
                    UserDefaults.standard.set(self.userData["Phone"], forKey: "phone")
                    
                    // user image setup
                    self.setupUserImage(userId: uid)
                }
                    // if not present in the database
                else {
                    let name = user.displayName
                    let email = user.email
                    
                    
                    // populating user data
                    self.userData["Name"] = name
                    self.userData["Email"] = email
                    self.userData["Password"] = "(Facebook Login)"// change later on
                    
                    // adding values to the database
                    self.databaseReference.child("users/\(uid)/name").setValue(name)
                    self.databaseReference.child("users/\(uid)/email").setValue(email)
                    
                    // setting name label
                    self.nameLabel.text = name?.components(separatedBy: " ").first!
                    
                    // setting user defaults
                    UserDefaults.standard.set(self.userData["Name"], forKey: "name")
                    UserDefaults.standard.set(self.userData["Email"], forKey: "email")
                    UserDefaults.standard.set(self.userData["Password"], forKey: "password")
                    UserDefaults.standard.set(self.userData["Phone"], forKey: "phone")
                    
                    // user image setup
                    self.setupUserImage(userId: uid)
                    
                    
                }// end of not present in the database
                
            })
            
            
            
            
        } // end of user logged in functions
        
        
    }
    
    func setupUserImage(userId uid: String) {
        // reference for storing profile picture
        let profilePicRef = self.storageRef.child(uid+"/profile_pic.jpg") // reference for picture storage
        
        // downloading profile pic from firebase if it exists
        profilePicRef.data(withMaxSize: 1024 * 1024, completion: { (data, error) in
            if error != nil {
                // handle error
                print("Could not access firebase storage")
            }
            else if data == nil {
                // if image was not in firebase database, get image from facebook
                if self.userImageView.image == nil {
                    
                    // getting user profile picture
                    let profilePictureRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["width": 300, "height": 300, "redirect": false], httpMethod: "GET")
                    
                    // requesting profile picture
                    profilePictureRequest!.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            // handle error
                            print("profile picture could not be downloaded")
                        }
                        else {
                            
                            let dictionary = result as! NSDictionary
                            let data = dictionary.object(forKey: "data") as! NSDictionary
                            
                            
                            
                            let urlPic = ((data as AnyObject).object(forKey: "url")) as! NSString
                            
                            if let imageData = NSData(contentsOf: NSURL(string: urlPic as String)! as URL) { // if data returned contains image
                                
                                
                                
                                // uploading image
                                profilePicRef.put(imageData as Data, metadata: nil, completion: { (metadata, error2) in
                                    
                                    if error2 != nil {
                                        // handle error
                                        print("Image could not be uploaded")
                                    }
                                    else {
                                        //                                let downloadURL = metadata!.downloadURL()
                                    }
                                    
                                })// image upload ends
                                
                                self.userImageView.image = UIImage(data: imageData as Data)
                                
                                // saving to user defaults
                                let userImageData = UIImageJPEGRepresentation(self.userImageView.image!, 1)
                                UserDefaults.standard.set(userImageData, forKey: "userImage")
                            }
                            
                            
                        }
                        
                    })
                    
                } // end of getting profile pic from facebook and uploading to firebase
            }
            else {
                self.userImageView.image = UIImage(data: data!)
                
                // saving to user defaults
                let userImageData = UIImageJPEGRepresentation(self.userImageView.image!, 1)
                UserDefaults.standard.set(userImageData, forKey: "userImage")
                
            }
        })
        
        
        
        
        
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
        
        // gradient frame
        
        gradientLayer.frame = self.backgroundImageView.frame
        
        // image corner rounding
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2.0
        self.userImageView.clipsToBounds = true
        
        // remove later
        
    }
    
    // MARK: Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.titleLabel.text = self.keys[indexPath.row]
        cell.titleLabel.textColor = self.themeColor
        
        
        cell.textField.text = self.userData[self.keys[indexPath.row]]
        cell.textField.textColor = UIColor(red: 163.0 / 255.0, green: 163.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
        cell.textField.tag = indexPath.row + 300 + 1
        
        cell.editButton.tintColor = self.themeColor
        cell.editButton.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), for: [])
        cell.editButton.tag = indexPath.row + 100 + 1
        cell.editButton.addTarget(self, action: #selector(UserViewController.editButtonSelected(_:)), for: .touchUpInside)
        
        // disabling edit button if facebook login, i.e., if value of password key is (Facebook Login)
        if self.keys[indexPath.row] == "Password" {
            
            cell.textField.isSecureTextEntry = true
            
            if cell.textField.text == "(Facebook Login)" {
                cell.textField.isSecureTextEntry = false
                cell.editButton.isEnabled = false
            }
            
            
        }
        
        if self.keys[indexPath.row] == "Email" {
                cell.editButton.isEnabled = false
        }

        
        // else making the password field secure
        
        
        return cell
    }
    
    func editButtonSelected(_ sender: UIButton) {
        
        if sender.isEnabled {
            if sender.tag < 200 {
                // begin editing
                if let textField = self.tableView.viewWithTag(sender.tag + 200) as? UITextField {
                    textField.isEnabled = true
                    textField.textColor = UIColor.white
                }
                
                // make current cell prominent
                let editingCell = self.tableView.cellForRow(at: IndexPath(row: sender.tag - 101, section: 0)) as! ProfileTableViewCell
                
                let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
                let visibleCells = self.tableView.visibleCells as! [ProfileTableViewCell]
                for cell in visibleCells {
                    
                    if cell !== editingCell {
                        cell.editButton.isEnabled = false
                    }
                    
                    UIView.animate(withDuration: 0.3, animations: {() in
                        cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                        if cell !== editingCell {
                            cell.alpha = 0.3
                        }
                    })
                }
                
                // change tag
                sender.tag += 100
                
                // disable scroll
                self.tableView.isScrollEnabled = false
                
                //change icon from edit icon to save icon
                UIView.transition(with: sender, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    sender.setImage(UIImage(named: "save")?.withRenderingMode(.alwaysTemplate), for: [])
                    }, completion: nil)
                
            }
            else {
                
                // change tag
                sender.tag -= 100
                
                // enable scrolling
                self.tableView.isScrollEnabled = true
                
                // bring back all cells to normal
                let editingCell = self.tableView.cellForRow(at: IndexPath(row: sender.tag - 101, section: 0)) as! ProfileTableViewCell
                let visibleCells = self.tableView.visibleCells as! [ProfileTableViewCell]
                for cell: ProfileTableViewCell in visibleCells {
                    
                    if cell != editingCell {
                        cell.editButton.isEnabled = true
                    }
                    
                    UIView.animate(withDuration: 0.3, animations: {() in
                        cell.transform = CGAffineTransform.identity
                        if cell !== editingCell {
                            cell.alpha = 1.0
                        }
                    })
                }
                
                // end editing
                if let textField = self.tableView.viewWithTag(sender.tag + 200) as? UITextField {
                    textField.isEnabled = false
                    textField.textColor = UIColor(red: 163.0 / 255.0, green: 163.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
                }
                
                
                // change icon from save to edit icon
                
                UIView.transition(with: sender, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { 
                    sender.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), for: [])
                    }, completion: { (completed) in
                        self.tableView.reloadData()
                })
                
                // make changes to the database
                databaseReference.child("users/\(self.UID)").child(editingCell.titleLabel.text!.lowercased()).setValue(editingCell.textField.text!)
                
                // make changes to user defaults
                UserDefaults.standard.set(editingCell.textField.text!, forKey: editingCell.titleLabel.text!.lowercased())
                
                // make changes to user data
                self.userData[editingCell.titleLabel.text!] = editingCell.textField.text!
                
                
                
            }
        }
        
        
    }
    
    // MARK: Logout
    
    func logoutButtonTapped(_ sender: AnyObject) {
        
        // sign out of firebase
        try! FIRAuth.auth()!.signOut()
        
        // sign out of facebook
        FBSDKAccessToken.setCurrent(nil)
        
        // set value of image in user defaults to nil
        UserDefaults.standard.removeObject(forKey: "userImage")
        
        // setting value of user defaults to nil
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "password")
        
        // going back to login screen
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        
        self.present(loginViewController, animated: true, completion: nil)
        
        
    }


}
