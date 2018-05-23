//
//  CategoryViewController.swift
//  Film Inspector
//
//  Created by Yassine Sabeq on 5/19/18.
//  Copyright © 2018 Yassine Sabeq. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    var categoryLogos : [String : String] = ["Action" : "icons8-action-filled-100", "Comedy" : "icons8-comedy-96", "Drama" : "icons8-drama-96", "War" : "icons8-battle-96", "Romance" : "icons8-romance-80", "Musical" : "icons8-musical-80", "Thriller" : "icons8-thriller-80", "Crime" : "icons8-crime-96", "Science Fiction" : "icons8-bot-80"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellReuseIdentifier: "customCategoryCell")
        
        tableView.estimatedRowHeight = 90
        
        loadCategory()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCategoryCell", for: indexPath) as! CategoryViewCell
        
        let category = categoryArray[indexPath.row]
 
        cell.categoryLabel.text = category.name
        
        switch category.name {
        case "Action" : cell.categoryLogo.image = UIImage(named: categoryLogos["Action"]!)
        case "Comedy" : cell.categoryLogo.image = UIImage(named: categoryLogos["Comedy"]!)
        case "Drama" : cell.categoryLogo.image = UIImage(named: categoryLogos["Drama"]!)
        case "War" : cell.categoryLogo.image = UIImage(named: categoryLogos["War"]!)
        case "Science fiction" : cell.categoryLogo.image = UIImage(named: categoryLogos["Science Fiction"]!)
        case "Romance" : cell.categoryLogo.image = UIImage(named: categoryLogos["Romance"]!)
        case "Crime" : cell.categoryLogo.image = UIImage(named: categoryLogos["Crime"]!)
        case "Musical" : cell.categoryLogo.image = UIImage(named: categoryLogos["Musical"]!)
        case "Thriller" : cell.categoryLogo.image = UIImage(named: categoryLogos["Thriller"]!)
        default : cell.categoryLogo.image = UIImage(named: "")
        }
        
        return cell
    }
    
    //MARK: - ADD New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Movie Categories", message: "Please enter a category name", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category..."
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
 
    //MARK: - DATA Manipulaton Methods
    
    func saveCategory() {
        
        do{
            try context.save()
        } catch {
            print("error saving categories, \(error)")
        }
        
        tableView.reloadData()
    }

    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            try categoryArray = context.fetch(request)
        } catch {
            print("Error fetching categories, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToMovies", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MovieViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryArray[indexPath.row]
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
