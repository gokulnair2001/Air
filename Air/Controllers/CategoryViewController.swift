//
//  CategoryViewController.swift
//  Air
//
//  Created by Gokul Nair on 19/08/20.
//  Copyright © 2020 Gokul Nair. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    var categories = [Category]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadCategories()
        
       
        
        //MARK:- Onboarding Stuffs
        if core.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(identifier: "onboarding") as! OnBoardingViewController
            present(vc, animated: true)
        }
    }
    
    
    
}

//MARK:- TableView Methods

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AirViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            tableView.reloadData()
            saveCategories()
            
        }
    }
    
}


//MARK: - Data Manipulation Methods
extension CategoryViewController {
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}


//MARK:- Add Btn Methods

extension CategoryViewController {
    
    @IBAction func addCategoryBtn(_ sender: Any) {
        
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
        alert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text != "" && textField.text?.count != 0{
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
                self.saveCategories()}
            else {
                print("Empty")
            }
         
        
            
        })
               
              // alert.addAction(action)
               
               alert.addTextField { (field) in
                   textField = field
                   textField.placeholder = "Add a new category"
               }
               
               present(alert, animated: true, completion: nil)
    }
}

//MARK:-  Onboarding Code

class core{
    
    static let shared = core()
    
    func isNewUser()->Bool {
        return !UserDefaults.standard.bool(forKey: "onboarding")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "onboarding")
    }
}


