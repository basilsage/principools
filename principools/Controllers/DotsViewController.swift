//
//  ViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/11/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//



import UIKit
import CoreData

class DotsViewController: UITableViewController {
    
    var dotArray = [Dot]()
    
    var selectedPrinciple : Principle? {
        didSet {
            // everything in here will happen as soon as selectedPrinciple gets assigned a value
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //file path to SQLite database
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    // Determines number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dotArray.count
    }
    
    // Populates cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DotItemCell", for: indexPath)
        cell.textLabel?.text = "\(dotArray[indexPath.row].body!), \(dotArray[indexPath.row].score)"
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dotArray[indexPath.row])
        
        dotArray[indexPath.row].score += 1
        print("Body: \(dotArray[indexPath.row].body ?? ""), Score: \(dotArray[indexPath.row].score)")
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Dot", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Dot", style: .default) { (action) in
             // What will happen once user clicks add item button on our UIAlert
            
            
            let newDot = Dot(context: self.context)
            newDot.body = textField.text!
            newDot.parentPrinciple = self.selectedPrinciple
            self.dotArray.append(newDot)
            
            self.saveItems()
            
            self.tableView.reloadData()
            
        }
        
        // what happens when alert bubble opens
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new dot"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    
    
    // = Dot.fetchRequest() is a default value
    // with request is an internal (vs. external) parameter
    func loadItems(with request: NSFetchRequest<Dot> = Dot.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let principlePredicate = NSPredicate(format: "parentPrinciple.name MATCHES %@", selectedPrinciple!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [principlePredicate, additionalPredicate])
        } else {
            request.predicate = principlePredicate
        }
        
        do {
            dotArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
}

extension DotsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Dot> = Dot.fetchRequest()
        
        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "body CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "body", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        
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

//MARK: - To-Do
// Text wrapping / truncation for long dots
// 1. Table Swipe Actions
// 1b.  dotArray[indexPath.row].setValue("good/bad", forKey: "value")
// 1b.
//     context.delete(dotArray[indexPath.row]) #removes data from permanent container
//     dotArray.remove(at: indexPath.row) #removes from dotArray used to loadup tableview
