//
//  PrincipleViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/13/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class PrincipleViewController: UITableViewController {
    
    
    var principles : Results<Principle>?
    let realm = try! Realm()
    
    var indexPathForMoveAction : IndexPath? 
    
    
    var selectedPool : Pool? {
        didSet {
            loadPrinciples()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - TableView Datasource Methods
    // Setup data source to display all categories inside our persistent container
    
    // Determine number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return principles?.count ?? 1
    }
    
    // Populate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = principles?[indexPath.row].name ?? "No principles added yet"
        
//        let principleName = principles?[indexPath.row].name

        
        
//        let scores : Float = realm.objects(Principle).reduce(0) { sum, dot in
//            return sum + dot.score.sum("score")
//        }
//
//        print(scores)
//
//        cell.textLabel?.text = String(averageDotScore)
        
        return cell
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    // Leave this for now
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDots", sender: self)
        
    }
    
    // triggered just before we perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDots" {
            print("go to dots segue preparing")
            let destinationVC = segue.destination as! DotsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedPrinciple = principles?[indexPath.row]
                print("destination vc selected principle set")
            }
        } else {
            print("go to move principles segue preparing")
            let destinationVC = segue.destination as! MovePrinciplesViewController
            
            //bug is because there is no indexpath selected, unlike didSelectRowAt.
            
            destinationVC.selectedPrinciple = principles?[(indexPathForMoveAction?.row)!]
            destinationVC.poolToBeVacated = selectedPool
            print("destination vc selected principle set")
            }
    }

    //MARK: - Data Manipulation Methods
    // save & load

    
    func loadPrinciples() {

        principles = selectedPool?.principles.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Principle", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Principle", style: .default) { (action) in
            
            if let currentPool = self.selectedPool {
                
                do {
                    try self.realm.write {
                        let newPrinciple = Principle()
                        newPrinciple.name = textField.text!
                        currentPool.principles.append(newPrinciple)
                    }
                } catch {
                    print("Error saving new principle \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new principle"
            alertTextField.autocapitalizationType = .sentences
            alertTextField.autocorrectionType = .yes
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Delete Data from Swipe
    func deletePrinciple(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Delete Principle", message: "Are you sure?", preferredStyle: .alert)
        
        // dismiss stats  window
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // reset total savings to $0
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
            if let principleForDeletion = self.principles?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(principleForDeletion)
                        print("Success deleting principle")
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

extension PrincipleViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.black
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        principles = principles?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    // triggers when text is changed AND text goes to zero
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadPrinciples()
            
            // DispatchQueue Assigns projects to different threads
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

extension PrincipleViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let moveAction = SwipeAction(style: .default, title: "Move") { action, indexPath in
            // handle action by updating model with new classification
            
            self.indexPathForMoveAction = indexPath
            
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            self.navigationItem.backBarButtonItem = backItem
            
            self.performSegue(withIdentifier: "goToMovePrinciples", sender: self)
            print("move segue triggered")
            
            
        }
        
        let renameAction = SwipeAction(style: .default, title: "Rename") { action, indexPath in
            // handle action by updating model with deletion
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Rename Principle", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Rename Principle", style: .default) { (action) in
                
                if let poolForRenaming = self.principles?[indexPath.row] {
                    do {
                        try self.realm.write {
                            poolForRenaming.name = textField.text!
                            print("Success renaming principle")
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error renaming principle, \(error)")
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addTextField { (alertTextField) in
                alertTextField.text = self.principles?[indexPath.row].name
                alertTextField.autocapitalizationType = .sentences
                alertTextField.autocorrectionType = .yes
                textField = alertTextField
            }
            
            alert.addAction(action)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deletePrinciple(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return  (orientation == .right ? [deleteAction, renameAction, moveAction] : nil)
        
    }
    
    
}

