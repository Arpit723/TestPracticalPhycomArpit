//
//  Constants.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import Foundation


let commonDateFormatter = DateFormatter()
let News_API_Key = "b0af0e7f69e747c883aa33dbc6c629ca"

enum ServerParam {
    static let baseURL = "https://newsapi.org/v2/top-headlines?"
}


enum UserDefaultKeys: String {
    case isUserLoggedIn
    case loggedInPhoneNumber
}
