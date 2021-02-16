//
//  HomeViewController.swift
//  PartnerUp
//
//  Created by Joshua Chuang on 1/3/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: Outlet variables
    @IBOutlet weak var shapeTableView: UITableView!
    
    // MARK: Other Variables
    
    let searchController = UISearchController()
    var shapeList = [Shape]()
    var filteredShapes = [Shape]()
    var placeholderText = "Graduated from Lorem Ipsum high school. Specialties include dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor. Achievements include incididunt ut labore award, President of dolore magna club."
    
    // MARK: Loading function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        shapeList = initList()
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        shapeTableView.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        shapeTableView.delegate = self
        shapeTableView.dataSource = self
        initSearchController()
    }
    
    // MARK: Action functions
    
    /// Customizes the Search Bar
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Computer Science", "Engineering", "Business", "Biology"]
        searchController.searchBar.delegate = self
        
    }
    
    /// Creates a fixed list of users that shows up in the Home Page
    func initList() -> [Shape] {
        var tempList: [Shape] = []
        
        let josh = Shape(name: "Joshua Chuang", imageName: "joshImage", major: "Computer Science", city: "Cypress", bio: placeholderText)
        tempList.append(josh)
        let frank = Shape(name: "Frank Deeprompt", imageName: "joshImage", major: "Engineering", city: "Cypress", bio: placeholderText)
        tempList.append(frank)
        let david = Shape(name: "David Lee", imageName: "joshImage", major: "Business", city: "Cypress", bio: placeholderText)
        tempList.append(david)
        let moses = Shape(name: "Moses Kao", imageName: "joshImage", major: "Biology", city: "Cypress", bio: placeholderText)
        tempList.append(moses)
        let meisen = Shape(name: "Meisen Wang", imageName: "joshImage", major: "Computer Science", city: "Cypress", bio: placeholderText)
        tempList.append(meisen)
        let emma = Shape(name: "Emma Lee", imageName: "joshImage", major: "Computer Science", city: "Cypress", bio: placeholderText)
        tempList.append(emma)
        let lydia = Shape(name: "Lydia Lee", imageName: "joshImage", major: "Business", city: "Cypress", bio: placeholderText)
        tempList.append(lydia)

        return tempList
    }
    
    
    // MARK: Helper functions
    
    // Checks if there is a current user.
        // If yes, automatically loads home page.
        // If not, loads the login/signup screen
    func validateAuth(){
        if Auth.auth().currentUser == nil{
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.viewController) as! ViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = viewController
        }
    }
    
    /// Updates the results of the search in realtime
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let selectedScopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, selectedScopeButton: selectedScopeButton)
    }
    
    /// Filters the search by certain categories
    func filterForSearchTextAndScopeButton(searchText: String, selectedScopeButton: String = "All"){
        filteredShapes = shapeList.filter{
            shape in
            let scopeMatch = (selectedScopeButton == "All" || shape.major.lowercased().contains(selectedScopeButton.lowercased()))
            if(searchController.searchBar.text != ""){
                let searchTextMatch = shape.major.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            }
            else{
                return scopeMatch
            }
        }
        shapeTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: TableView components
    // Protocol stubs to set up the tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return filteredShapes.count
        }
        return shapeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        let thisShape: Shape!
        
        if(searchController.isActive){
            thisShape = filteredShapes[indexPath.row]
        }
        else{
            thisShape = shapeList[indexPath.row]
        }
        
        tableViewCell.setShape(shape: thisShape)
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue") {
            let indexPath = self.shapeTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? HomeDetailViewController
            
            let selectedShape: Shape!
            
            if(searchController.isActive){
                selectedShape = filteredShapes[indexPath.row]
            }
            else{
                selectedShape = shapeList[indexPath.row]
            }
            
            tableViewDetail?.selectedShape = selectedShape
            
            self.shapeTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
