//
//  User.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 28/04/24.
//

import Foundation
import CoreLocation

struct User: Codable {
    let userId: String
    let name: String
    let email: String
    let mobileNumber: String
    let currentLocation: [String: Double]
}
