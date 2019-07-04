//
//  MovePrinciplesViewController.swift
//  principools
//
//  Created by DJ Satoda on 7/3/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import RealmSwift

class MovePrinciplesViewController: UITableViewController {
    
    var pools : Results<Pool>?
    var principles : Results<Principle>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return pools?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
