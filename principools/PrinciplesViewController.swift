//
//  ViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/11/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit

class PrinciplesViewController: UITableViewController {
    
    let principleArray = ["Play to win", "Work hard", "Be open to criticism"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Tableview Datasource Methods
    
    // Populates cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrincipleItemCell", for: indexPath)
        cell.textLabel?.text = principleArray[indexPath.row]
        return cell
        
    }
    
    // Determines number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return principleArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(principleArray[indexPath.row])
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

