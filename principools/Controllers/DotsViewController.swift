//
//  ViewController.swift
//  principools
//
//  Created by DJ Satoda on 6/11/19.
//  Copyright © 2019 DJ Satoda. All rights reserved.
//



import UIKit

class DotsViewController: UITableViewController {
    
    var dotArray = [Dot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let newDot = Dot()
        newDot.body = "Ate at Iza Ramen"
        dotArray.append(newDot)
        
        let newDot2 = Dot()
        newDot2.body = "Went to CDMX > EU"
        dotArray.append(newDot2)

    }
    
    //MARK: - Tableview Datasource Methods
    
    // Populates cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DotItemCell", for: indexPath)
        cell.textLabel?.text = "\(dotArray[indexPath.row].body), \(dotArray[indexPath.row].score)"
        return cell
        
    }
    
    // Determines number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dotArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dotArray[indexPath.row])
        
        dotArray[indexPath.row].score += 1
        print("Body: \(dotArray[indexPath.row].body), Score: \(dotArray[indexPath.row].score)")
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Dot", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Dot", style: .default) { (action) in
             // What will happen once user clicks add item button on our UIAlert
            
            let newDot = Dot()
            newDot.body = textField.text!
            
        }
        
        // what happens when alert bubble opens
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new dot"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
}

//MARK: - To-Do
// Text wrapping / truncation for long dots
// Table Swipe Actions
