//
//  PlayerSearchViewController.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/7/21.
//

import UIKit

class PlayerSearchViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    //  MARK: - PROPERTIES
    var players: [Player] = []
    var loginResponse: LoginResponse?
    var firstName: String?
    var lastName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        copyrightLabel.isHidden = true
    }
    
    //  MARK: - METHODS
    func loginToApiServer() {
        ApiController.login { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.loginResponse = response
                    self.fetchWith(firstName: self.firstName, lastName: self.lastName)
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchWith(firstName: String?, lastName: String?) {
        guard let loginResponse = self.loginResponse else { return print("Search canceled. Not logged into API...") }
        print("Searching for player with name(s): \(firstName ?? "noFirst") \(lastName ?? "noLast")")
                        
        ApiController.getPlayersWith(firstName: self.firstName, lastName: self.lastName, loginResponse: loginResponse) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let players):
                    self.players = players
                    self.tableView.reloadData()
                    self.copyrightLabel.isHidden = false
                    self.firstName = ""
                    self.lastName = ""
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
        if segue.identifier == "toPlayerDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? PlayerDetailViewController else { return }
            destination.player = players[indexPath.row]
        }
    }

}   //  End of Class

extension PlayerSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let first = players[indexPath.row].first_name
        let last = players[indexPath.row].last_name
        let city = players[indexPath.row].city
        let state = players[indexPath.row].state_prov
        
        cell.textLabel?.text = "\(first ?? "") \(last ?? "")"
        cell.detailTextLabel?.text = "\(city ?? ""), \(state ?? "")"
        
        return cell
    }
    
    
}   //  End of Extension

extension PlayerSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button tapped...")
        
        guard let searchTerm = searchBar.text?.lowercased(), !searchTerm.isEmpty else { return print("Search canceled. Could not get search bar text...") }
        
        let firstAndLast = searchTerm.createTwoNames()
        self.firstName = firstAndLast.first
        self.lastName = firstAndLast[1]
        
        loginToApiServer()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel search button clicked.")
        searchBar.text = ""
        self.players = []
        self.tableView.reloadData()
        copyrightLabel.isHidden = true
    }
}   //  End of Extension
