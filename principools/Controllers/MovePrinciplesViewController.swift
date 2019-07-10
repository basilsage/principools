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
    
    var selectedPrinciple : Principle? {
        didSet {
            // everything in here will happen as soon as selectedPrinciple gets assigned a value
            print("Principle to be moved has been selected")
        }
    }
    
    var poolToBeVacated : Pool? {
        didSet {
            // everything in here will happen as soon as selectedPrinciple gets assigned a value
            print("Pool to be vacated has been selected")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPools()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            try self.realm.write {
                
                pools?[indexPath.row].principles.append(selectedPrinciple!)
                poolToBeVacated?.principles.remove(at: 0)

                
            }
        } catch {
            print("Error moving principle \(error)")
        }
        
        print("DISMISSED SIR")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pools?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = pools?[indexPath.row].name ?? "No pools added yet"
        
        
        return cell
    }
    
    func loadPools() {
        
        pools = realm.objects(Pool.self)
        
        tableView.reloadData()
    }
    
}
