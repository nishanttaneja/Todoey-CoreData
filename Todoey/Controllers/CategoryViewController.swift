//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nishant Taneja on 10/09/20.
//  Copyright © 2020 Nishant Taneja. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    // IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // Initialise
    private var categories = [Category]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Override View Method
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {}
    
    //MARK:- CoreData
    /// This function is used to fetch categories.
    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request);
            tableView.reloadData()
        }
        catch {print("error loading categories")}
    }
}

//MARK:- TableView Delegate|DataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}
