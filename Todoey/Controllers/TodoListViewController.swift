//
//  ViewController.swift
//  Todoey
//
//  Created by John Fake on 7/11/18.
//  Copyright © 2018 John Fake. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    // collection of results of the Item
    var todoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        // as soon as selectedCategory gets set by category view list
        didSet {
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage:CGFloat(CGFloat(indexPath.row) / CGFloat(todoItems!.count) ))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No item added"
        }
         return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                
            try realm.write {
                item.done = !item.done
                //realm.delete(item)
                }
            }catch {
               print("Error saving done status \(error)")
            }
        }
//        todoItems?[indexPath.row].done  = !todoItems[indexPath.row].done
//
//        saveItems()
        
        tableView.reloadData()

    }
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item",  style: .default) { (action) in
            /// what will happen once the user clicks the Add Item button on our UIAlert
            
            

            if let currentCategory = self.selectedCategory  {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                   print ("Error saving new items, \(error)")
                }
                
            }
         self.tableView.reloadData()
        }
       
        alert.addTextField { (alertTextField) in alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    }
    
    // MARK: Model Manipulation
    //MARK: Delete Data From Sipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch  {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    
    // default value used with call with no parameter
    
    func loadItems(){
        todoItems =  selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         //todoItems = todoItems?.filter("title CONTAINS[cd] '\(searchBar.text!)'").sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title BEGINSWITH[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0  {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
