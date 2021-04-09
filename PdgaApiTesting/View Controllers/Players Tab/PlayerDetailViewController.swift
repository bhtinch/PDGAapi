//
//  PlayerDetailViewController.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/7/21.
//

import UIKit
import SafariServices

class PlayerDetailViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //  MARK: - PROPERTIES
    var player: Player?
    var playerProperties: [[String]] = []
    var pdgaNubmer: String?

    //  MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    }
    
    //  MARK: - METHODS
    func updateView() {
        guard let player = player,
              let propArray = player.propertiesArray(),
              let tableView = self.tableView else { return }
        
        self.title = "\(player.first_name ?? "") \(player.last_name ?? "")"
        
        self.playerProperties = propArray
        tableView.reloadData()
    }
    
    func presentSafariWith(URLString: String) {
        guard let linkURL = URL(string: URLString) else { return }
        let vc = SFSafariViewController(url: linkURL)
        present(vc, animated: true, completion: nil)
    }
}   //  End of Class

extension PlayerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let linkCell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as? LinkTableViewCell else { print("bad cell"); return UITableViewCell() }
        
        let label = playerProperties[indexPath.row][0]
        
        if label == "PDGA #" { self.pdgaNubmer = playerProperties[indexPath.row][1] }
        
        if label == "Player Link" {
            let linkNode = self.pdgaNubmer ?? ""
            print("\(ApiController.playerURL)/\(linkNode)")
            
            linkCell.linkButton.setTitle("\(player?.first_name ?? "Player") \(player?.last_name ?? "Profile")" , for: .normal)
            
            linkCell.tapAction = { _ in
                self.presentSafariWith(URLString: "\(ApiController.playerURL)/\(linkNode)")
            }
            return linkCell
            
        } else {
            let value = playerProperties[indexPath.row][1]
            cell.textLabel?.text = "\(label):   \(value)"
            return cell
        }
    }
}   //  End of Extension
