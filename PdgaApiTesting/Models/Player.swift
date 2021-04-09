//
//  Player.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/6/21.
//

import Foundation

struct PlayerQueryStrings {
    static let firstName = "first_name"
    static let lastName = "last_name"
}

enum PlayerProperties: String, CaseIterable {
    case pdga_number = "PDGA #"
    case first_name = "First Name"
    case last_name = "Last Name"
    case classification = "Classification"
    case city = "City"
    case state_prov = "State"
    case country = "Country"
    case rating = "Rating"
    
}

struct PlayerTopLevel: Codable {
    let sessid: String
    let status: Int
    let players: [Player]
}

struct Player: Codable {
    var first_name: String?
    var last_name: String?
    var pdga_number: String?
    var classification: String?
    var city: String?
    var state_prov: String?
    var country: String?
    var rating: String?
}

extension Player {
    func propertiesArray() -> [[String]]? {
        var labelDict: [String : String] = [:]
        
        PlayerProperties.allCases.forEach {
            labelDict.updateValue($0.rawValue, forKey: "\($0)")
        }
        
        let mirror = Mirror(reflecting: self)
        
        var propertiesArray: [[String]] = []
        var propertyArray: [String] = []
        
        mirror.children.forEach {
            propertyArray = []
            
            if $0.label == "first_name" || $0.label == "last_name" { } else {
                if let labelName = $0.label {
                    if let label = labelDict[labelName] {
                        propertyArray.append(label)
                    }
                    
                    let value = $0.value as? String ?? "No Information"
                    propertyArray.append(value)
                    
                    propertiesArray.append(propertyArray)
                }
            }
        }
        propertiesArray.append(["Player Link", ""])
        return propertiesArray
    }
}
