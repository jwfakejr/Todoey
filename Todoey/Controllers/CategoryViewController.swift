//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Fake on 7/13/18.
//  Copyright © 2018 John Fake. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    // initialize new access point to realm
    let realm = try! Realm()
    
    // Results are returned from realm
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadCategories()
         tableView.separatorStyle = .none
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


  
    
    // MARK : - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // if categories is nill...then fill cell with No Categories added yetD
        
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No Categories added yet"
            cell.backgroundColor = UIColor(hexString: category.bgColor ?? "1D9BF6")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // nil coalescing operator
            return categories?.count ?? 1
    }
    
    
    // MARK : - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Maniputlation Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item",  style: .default) { (action) in
            /// what will happen once the user clicks the Add Item button on our UIAlert
            
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.bgColor = UIColor.randomFlat.hexValue()

            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
           
        }
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch  {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: Delete Data From Sipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch  {
                print("Error deleting category, \(error)")
            }
        }
    }
    // default value used with call with no parameter
    func loadCategories(){
        // fetch all objects that are the Category data type
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}

