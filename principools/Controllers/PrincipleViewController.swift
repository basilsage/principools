//
//  PrincipleViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/13/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import CoreData

class PrincipleViewController: UITableViewController {
    
    var principleArray = [Principle]()
    
    var selectedPool : Pool? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    
    
    
    //MARK: - TableView Datasource Methods
    // Setup data source to display all categories inside our persistent container
    
    // Determine number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return principleArray.count
    }
    
    // Populate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrincipleItemCell", for: indexPath)
        cell.textLabel?.text = principleArray[indexPath.row].name
        
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
            destinationVC.selectedPrinciple = principleArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    // save & load
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Principle> = Principle.fetchRequest(),predicate: NSPredicate? = nil) {
        
        let poolPredicate = NSPredicate(format: "parentPool.name MATCHES %@", selectedPool!.name!)
        
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [poolPredicate, additionalPredicate])
        } else {
            request.predicate = poolPredicate
        }
        
        do {
            principleArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Principle", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Principle", style: .default) { (action) in
            
            let newPrinciple = Principle(context: self.context)
            newPrinciple.name = textField.text!
            newPrinciple.parentPool = self.selectedPool
            self.principleArray.append(newPrinciple)
            
            self.saveItems()
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
        let request : NSFetchRequest<Principle> = Principle.fetchRequest()
        
        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
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
