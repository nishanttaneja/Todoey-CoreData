//
//  ItemTableViewController.swift
//  Todoey
//
//  Created by Nishant Taneja on 10/09/20.
//  Copyright © 2020 Nishant Taneja. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
    // Initialise
    var items = [Item]()
    var parentCategory: Category? {
        didSet {loadItems()}
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK:- IBOutlet | IBAction
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// When + UIBarButtonItem (rightBarButtonItem) is pressed, an UIAlertController is displayed to create new Category.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if textField.text != nil || textField.text != "" {
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.parentCategory
                self.items.append(newItem)
                self.saveItems()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "New Item"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Override ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // NavigationItem Title
        navigationItem.title = parentCategory?.title
        // SearchBar Delegate
        searchBar.delegate = self
    }

    //MARK:- TableView Delegate|DataSource
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK:- CoreData
    /// This function is used to fetch categories.
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", parentCategory!.title!)
        if let additionalPredicate = predicate {request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])}
        else {request.predicate = categoryPredicate}
        do {
            items = try context.fetch(request)
            tableView.reloadData()
        }
        catch {print("error loading items")}
    }
    /// This function saves newly created Category.
    private func saveItems() {
        do {
            try context.save()
            tableView.reloadData()
        }
        catch {print("error saving new items")}
    }
}

//MARK:- SearchBar Delegate
extension ItemTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filterStringPredicate: NSPredicate?
        if searchText.count > 0 {filterStringPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)}
        loadItems(predicate: filterStringPredicate)
    }
}
