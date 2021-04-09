//
//  Course.swift
//  PdgaApiTesting
//
//  Created by Benjamin Tincher on 4/6/21.
//

import Foundation

struct CourseQueryStrings {
    static let courseName = "course_name"
    static let postalCode = "postal_code"
    static let city = "city"
    static let stateAbbrev = "state_prov"
}

enum CourseProperties: String, CaseIterable {
    case course_name = "Course Name"
    case distance = "Distance"
    case postal_code = "Zip Code"
    case city = "City"
    case state_province = "State"
    case basket_types = "Basket Type"
    case fees = "Fees"
    case tee_types = "Tee Type"
    case course_node_nid = "Course Link"
}

struct CourseTopLevel: Codable {
    let sessid: String
    let status: Int
    let courses: [Course]
}

struct Course: Codable {
    var course_name: String?
    var distance: String?
    var postal_code: String?
    var city: String?
    var state_province: String?
    var basket_types: String?
    var fees: String?
    var tee_types: String?
    var course_node_nid: String?
}

extension Course {
    func propertiesArray() -> [[String]]? {
        var labelDict: [String : String] = [:]
        
        CourseProperties.allCases.forEach {
            labelDict.updateValue($0.rawValue, forKey: "\($0)")
        }
        
        let mirror = Mirror(reflecting: self)
        
        var propertiesArray: [[String]] = []
        var propertyArray: [String] = []
        
        mirror.children.forEach {
            propertyArray = []
            
            if $0.label == "course_name" { } else {
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
        return propertiesArray
    }
}
