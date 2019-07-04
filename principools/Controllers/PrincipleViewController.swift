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
    
    var selectedPool : Pool? {
        didSet {
            loadPrinciples()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        

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
        let destinationVC = segue.destination as! DotsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPrinciple = principles?[indexPath.row]
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
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new principle"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Delete Data from Swipe
    func updateModel(at indexPath: IndexPath) {
        if let principleForDeletion = self.principles?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(principleForDeletion)
                }
            } catch {
                print("Error deleting pool, \(error)")
            }
        }
    }
    
}

extension PrincipleViewController: UISearchBarDelegate {
    
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
            
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Expired") { action, indexPath in
            // handle action by updating model with deletion
            
            
        }
        
        return  (orientation == .right ? [moveAction, deleteAction] : nil)
        
    }
    
    
}
