//
//  SwipeTableViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/18/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - TableVIew Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell

    }
    
    // handles what happens when user actually swipes cell
        

    
    func updateModel(at indexPath: IndexPath) {
        // update data model
    }

}
