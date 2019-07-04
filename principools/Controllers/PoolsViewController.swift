//
//  PoolsViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/14/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class PoolsViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    var pools : Results<Pool>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello, world!")
        let realmFilePath = Realm.Configuration.defaultConfiguration.fileURL
        print("Realm File Path",realmFilePath!)
        
        loadPools()
        
        tableView.rowHeight = 80
        tableView.separatorColor = FlatPowderBlue()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Pool", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Pool", style: .default) { (action) in
            let newPool = Pool()
            newPool.name = textField.text!
            
            // no longer need to append to an array, because Realm uses auto-updating container
            
            self.savePools(pool: newPool)
            print("Saved")
            self.tableView.reloadData()
            print("Reloaded")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new pool"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // if pools.count = nil, then return 1
        return pools?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = pools?[indexPath.row].name ?? "No pools added yet"
        
        if let color = FlatSkyBlue().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(pools!.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPrinciples", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PrincipleViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPool = pools?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func savePools(pool: Pool) {
        do {
            try realm.write {
                realm.add(pool)
            }
        } catch {
            print("Error saving \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadPools() {
        
         pools = realm.objects(Pool.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Pools
    func deletePool(at indexPath: IndexPath) {
       
        let alert = UIAlertController(title: "Delete Pool", message: "Are you sure?", preferredStyle: .alert)
        
        // dismiss stats  window
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // reset total savings to $0
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            if let poolForDeletion = self.pools?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(poolForDeletion)
                        print("Success deleting pool")
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error deleting pool, \(error)")
                }
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
        
        
    }

    
}

//MARK: - Extension: Search Bar
extension PoolsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        pools = pools?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    // triggers when text is changed AND text goes to zero
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadPools()
            
            // DispatchQueue Assigns projects to different threads
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//MARK: - Extension: Swipe Cells
extension PoolsViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.deletePool(at: indexPath)
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return  (orientation == .right ? [deleteAction] : nil)
        
    }
    
    
}
