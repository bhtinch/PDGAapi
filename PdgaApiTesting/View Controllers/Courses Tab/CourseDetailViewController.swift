//
//  CourseDetailViewController.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/6/21.
//

import UIKit
import SafariServices

class CourseDetailViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //  MARK: - PROPERTIES
    var course: Course?
    var courseProperties: [[String]] = []
    
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
        guard let course = course,
              let propArray = course.propertiesArray(),
              let tableView = self.tableView else { return }
        
        self.title = course.course_name
        
        self.courseProperties = propArray
        tableView.reloadData()
    }
    
    func presentSafariWith(URLString: String) {
        guard let linkURL = URL(string: URLString) else { return }
        let vc = SFSafariViewController(url: linkURL)
        present(vc, animated: true, completion: nil)
    }
    
}   //  End of Class

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let linkCell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath) as? LinkTableViewCell else { return UITableViewCell() }
        
        let label = courseProperties[indexPath.row][0]
        
        if label == "Course Link" {
            let linkNode = courseProperties[indexPath.row][1]
            print("\(ApiController.nodeURL)/\(linkNode)")
            
            linkCell.linkButton.setTitle(course?.course_name ?? "Course Link", for: .normal)
            
            linkCell.tapAction = { _ in
                self.presentSafariWith(URLString: "\(ApiController.nodeURL)/\(linkNode)")
            }
            return linkCell
            
        } else {
            let value = courseProperties[indexPath.row][1]
            cell.textLabel?.text = "\(label):   \(value)"
            return cell
        }
    }
}   //  End of Extension
