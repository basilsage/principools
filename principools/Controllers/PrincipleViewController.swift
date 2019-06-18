//
//  PrincipleViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/13/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import RealmSwift

class PrincipleViewController: UITableViewController {
    
    var principles : Results<Principle>?
    let realm = try! Realm()
    
    var selectedPool : Pool? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    
    
    
    //MARK: - TableView Datasource Methods
    // Setup data source to display all categories inside our persistent container
    
    // Determine number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return principles?.count ?? 1
    }
    
    // Populate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrincipleItemCell", for: indexPath)
        cell.textLabel?.text = principles?[indexPath.row].name ?? "No principles added yet"
        
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

    
    func loadItems() {

        principles = selectedPool?.principles.sorted(byKeyPath: "name", ascending: true)

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
            
            loadItems()
            
            // DispatchQueue Assigns projects to different threads
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
