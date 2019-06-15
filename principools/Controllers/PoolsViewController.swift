//
//  PoolsViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/14/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//

import UIKit
import CoreData

class PoolsViewController: UITableViewController {
    
    var poolArray = [Pool]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello, world!")
        loadItems()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Pool", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Pool", style: .default) { (action) in
            let newPool = Pool(context: self.context)
            newPool.name = textField.text!
            self.poolArray.append(newPool)
            
            self.saveItems()
            self.tableView.reloadData()
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
        return poolArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PoolItemCell", for: indexPath)
        cell.textLabel?.text = poolArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPrinciples", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PrincipleViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPool = poolArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Pool> = Pool.fetchRequest(),predicate: NSPredicate? = nil) {
        
        request.predicate = predicate
        
        do {
            poolArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

extension PoolsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Pool> = Pool.fetchRequest()
        
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
