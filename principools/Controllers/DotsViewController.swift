//
//  ViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/11/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//



import UIKit
import RealmSwift
import SwipeCellKit

class DotsViewController: UITableViewController {
    
    var dots : Results<Dot>?
    let realm = try! Realm()
    
    var selectedPrinciple : Principle? {
        didSet {
            // everything in here will happen as soon as selectedPrinciple gets assigned a value
            print("selectedPrinciple set")
            loadDots()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        tableView.rowHeight = 80
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    // Determines number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dots?.count ?? 1
    }
    
    // Populates cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        let scoreString = String(format: "%.0f", dots![indexPath.row].score)
            
        cell.textLabel?.text = ("\(dots![indexPath.row].name) (\(scoreString))")
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let dot = dots?[indexPath.row] {
            do {
                
                if dot.score != 3 {
                    try realm.write {
                        dot.score += 1
                    }
                } else if dot.score == 3 {
                    try realm.write {
                        dot.score = -3
                    }
                }
                
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Dot", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Dot", style: .default) { (action) in
             // What will happen once user clicks add item button on our UIAlert
            
            if let currentPrinciple = self.selectedPrinciple {
                do {
                    try self.realm.write {
                        let newDot = Dot()
                        newDot.name = textField.text!
                        newDot.dateCreated = Date()
                        currentPrinciple.dots.append(newDot)
                        
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // what happens when alert bubble opens
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new dot"
            alertTextField.autocapitalizationType = .sentences
            alertTextField.autocorrectionType = .yes
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - Model Manipulation Methods
    
    
    // = Dot.fetchRequest() is a default value
    // with request is an internal (vs. external) parameter
    func loadDots() {
        
        dots = selectedPrinciple?.dots.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

        
    }
    
    //MARK: - Delete Data from Swipe
    func updateModel(at indexPath: IndexPath) {
        if let dotForDeletion = self.dots?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(dotForDeletion)
                    print("Dot deleted succesfully")
                    tableView.reloadData()
                }
            } catch {
                print("Error deleting pool, \(error)")
            }
        }
    }
    
    
    
}

extension DotsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = UIColor.black
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        dots = dots?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }

    // triggers when text is changed AND text goes to zero
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadDots()

            // DispatchQueue Assigns projects to different threads
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

extension DotsViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
        }
        
        let renameAction = SwipeAction(style: .default, title: "Rename") { action, indexPath in
            // handle action by updating model with deletion
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Rename Dot", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Rename Dot", style: .default) { (action) in
                
                if let poolForRenaming = self.dots?[indexPath.row] {
                    do {
                        try self.realm.write {
                            poolForRenaming.name = textField.text!
                            print("Success renaming dot")
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Error renaming dot, \(error)")
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addTextField { (alertTextField) in
                alertTextField.text = self.dots?[indexPath.row].name
                alertTextField.autocapitalizationType = .sentences
                alertTextField.autocorrectionType = .yes
                textField = alertTextField
            }
            
            alert.addAction(action)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        return  (orientation == .right ? [renameAction, deleteAction] : nil)
        
    }
    
    
}

//MARK: - To-Do
// Text wrapping / truncation for long dots
// 1. Table Swipe Actions
// 1b.  dotArray[indexPath.row].setValue("good/bad", forKey: "value")
// 1b.
