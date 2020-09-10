//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Nishant Taneja on 10/09/20.
//  Copyright © 2020 Nishant Taneja. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    //MARK:- Initialise
    private var categories = [Category]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK:- IBAction
    /// When + UIBarButtonItem (rightBarButtonItem) is pressed, an UIAlertController is displayed to create new Category.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if textField.text != nil || textField.text != "" {
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "New category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- TableView Delegate|DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CategoryToItemScene", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- CoreData
    /// This function is used to fetch categories.
    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        }
        catch {print("error loading categories")}
    }
    /// This function saves newly created Category.
    private func saveCategories() {
        do {
            try context.save()
            tableView.reloadData()
        }
        catch {print("error saving new category")}
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "CategoryToItemScene" {print("unidentified segue identifier"); return}
        // Update NavigationBar Title
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            let itemTableViewController = segue.destination
            itemTableViewController.navigationItem.title = self.categories[selectedIndexPath.row].name
        }
    }
}

