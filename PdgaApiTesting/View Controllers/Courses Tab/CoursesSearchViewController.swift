//
//  CoursesSearchViewController.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/6/21.
//

import UIKit

class CoursesSearchViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //  MARK: - PROPERTIES
    var courses: [Course] = []
    var loginResponse: LoginResponse?
    var searchTerm = ""
    
    //  MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    //  MARK: - METHODS
    func loginToApiServer() {
        ApiController.login { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.loginResponse = response
                    self.fetchWith(searchTerm: self.searchTerm)
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchWith(searchTerm: String) {
        guard let loginResponse = self.loginResponse else { return print("Search canceled. Not logged into API...") }
        print("Searching near \(searchTerm)")
                        
        ApiController.getCoursesNear(zipCode: searchTerm, loginResponse: loginResponse) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let courses):
                    self.courses = courses
                    self.tableView.reloadData()
                    self.searchTerm = ""
                    self.searchBar.text = ""
                    self.searchBar.resignFirstResponder()
                    self.logoutOfApiServer()
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                    self.logoutOfApiServer()
                }
            }
        }
    }
    
    func logoutOfApiServer() {
        guard let loginResponse = self.loginResponse else { return }
        ApiController.logout(loginResponse: loginResponse) { (result) in
            DispatchQueue.main.async {
                switch result  {
                case .success(_):
                    print("\nSuccessfully logged out of server...\n")
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CourseDetailViewController else { return }
            destination.course = courses[indexPath.row]
        }
    }
    
}   //  End of Class

extension CoursesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = courses[indexPath.row].course_name
        cell.detailTextLabel?.text = courses[indexPath.row].city
        
        return cell
    }
}   //  End of Extension

extension CoursesSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped...")
        
        guard let searchTerm = searchBar.text?.lowercased(), !searchTerm.isEmpty else { return print("Search canceled. Could not get search bar text...") }
        self.searchTerm = searchTerm
        loginToApiServer()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel search button clicked.")
        searchBar.text = ""
        self.courses = []
        self.tableView.reloadData()
    }
}   //  End of Extension
