//
//  CreditsViewController.swift
//  WalkIN
//
//  Created by Srivinayak Chaitanya Eshwa on 21/12/16.
//  Copyright © 2016 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leadDeveloperImage: UIImageView!
    @IBOutlet weak var leadDeveloperName: UILabel!
    @IBOutlet weak var leadDeveloperEmail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let names: [String] = []
    let roles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creditsCell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = roles[indexPath.row]
        
        return cell
        
    }

}
