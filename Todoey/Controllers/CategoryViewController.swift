//
//  CategoryViewController.swift
//  Todoey
//
//  Created by sodapeng on 1/8/18.
//  Copyright © 2018 sodapeng. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name
        if let cellColor = categoryArray[indexPath.row].color {
            cell.backgroundColor = UIColor(hexString: cellColor)
        }
        else {
            cell.backgroundColor = UIColor(hexString: "1D9BF6")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        do {
            try context.save()
        }catch {
            print("Error in save category \(error)")
        }
        
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newData = Category(context: self.context)
            newData.name = textField.text!
            newData.color = UIColor.randomFlat.hexValue()
            self.categoryArray.append(newData)
            self.saveCategories()
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - Delete Category
    override func updateModel(at indexPath: IndexPath) {
        context.delete(self.categoryArray[indexPath.row])
        categoryArray.remove(at: indexPath.row)
        saveCategories()
    }
    

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
    }

}

//MARK: - Swipe Cell Delegate Methods


