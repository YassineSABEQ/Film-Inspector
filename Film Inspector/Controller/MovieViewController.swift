//
//  MovieViewController.swift
//  Film Inspector
//
//  Created by Yassine Sabeq on 5/20/18.
//  Copyright © 2018 Yassine Sabeq. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController: UITableViewController {

    var movieArray = [Movie]()
    
    var selectedCategory : Category? {
        didSet {
            loadMovie()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedCategory?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        let movie = movieArray[indexPath.row]
        
        cell.textLabel?.text = movie.name

        return cell
    }
    
    //MARK: - DATA Manipulaton Methods
    
    func saveMovie() {
        
        do{
            try context.save()
        } catch {
            print("error saving movie, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadMovie(with request: NSFetchRequest<Movie> = Movie.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            movieArray = try context.fetch(request)
        } catch {
            print("Error loading movies, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - ADD New Movies
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Movie", message: "Please enter a movie name", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Movie..."
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Movie", style: .default) { (action) in
            
            let newMovie = Movie(context: self.context)
            newMovie.name = textField.text
            newMovie.parentCategory = self.selectedCategory
            self.movieArray.append(newMovie)
            
            self.saveMovie()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetails", sender: self) //in the storyboard, if you link the segue from the controller to the destination controller, you won't need performSegue, just prepare. that's why it called twice earlier. besides, func prepare ... loaded before viewdidload of the destination controller. that's why the outlets var are null before viewdidload did load xd
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToDetails"){
            
        let destinationVC = segue.destination as! MovieDetailsViewController
            
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedMovie = self.movieArray[indexPath.row]
        }
        }
    }
}
    
    //MARK: - SearchBar Methods
    
    extension MovieViewController : UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            let request : NSFetchRequest<Movie> = Movie.fetchRequest()
            
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
          loadMovie(with: request, predicate: predicate)
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            if searchBar.text?.count == 0 {
                loadMovie()

                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
    }
