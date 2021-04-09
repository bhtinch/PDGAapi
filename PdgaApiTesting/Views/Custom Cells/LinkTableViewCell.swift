//
//  CourseLinkTableViewCell.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/7/21.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    //  MARK: - OUTLETS
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var linkLabel: UILabel!
    
    //  MARK: - PROPERTIES
    var tapAction: ((UITableViewCell) -> Void)?
    
    //  MARK: - ACTIONS
    @IBAction func linkButtonTapped(_ sender: Any) {
        tapAction?(self)
    }
}
