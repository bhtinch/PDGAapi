//
//  UIClasses.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/8/21.
//

import Foundation
import UIKit

class RoundedColorLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 4
        self.backgroundColor = .green
        self.textColor = .white
    }
}

class EventDateLabel: RoundedColorLabel {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
