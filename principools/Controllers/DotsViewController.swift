//
//  ViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/11/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//



import UIKit
import RealmSwift

class DotsViewController: UITableViewController {
    
    var dots : Results<Dot>?
    let realm = try! Realm()
    
    var selectedPrinciple : Principle? {
        didSet {
            // everything in here will happen as soon as selectedPrinciple gets assigned a value
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    // Determines number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dots?.count ?? 1
    }
    
    // Populates cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DotItemCell", for: indexPath)
        cell.textLabel?.text = ("\(dots![indexPath.row].name) \(dots![indexPath.row].score)") 
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let dot = dots?[indexPath.row] {
            do {
                try realm.write {
                    dot.score += 1
//                    realm.delete(dot)
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
        
        // what happens when alert bubble opens
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new dot"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - Model Manipulation Methods
    
    
    // = Dot.fetchRequest() is a default value
    // with request is an internal (vs. external) parameter
    func loadItems() {
        
        dots = selectedPrinciple?.dots.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

        
    }
    
    
    
    
}

extension DotsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        dots = dots?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

//MARK: - To-Do
// Text wrapping / truncation for long dots
// 1. Table Swipe Actions
// 1b.  dotArray[indexPath.row].setValue("good/bad", forKey: "value")
// 1b.
//     context.delete(dotArray[indexPath.row]) #removes data from permanent container
//     dotArray.remove(at: indexPath.row) #removes from dotArray used to loadup tableview
