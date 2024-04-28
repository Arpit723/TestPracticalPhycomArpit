//
//  APIService.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import Foundation


class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    
    func request<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        // Perform the API request with the provided endpoint, method, and parameters
        
        guard let url = URL(string: endpoint) else {
            print("bad url request")
            return
        }
        // Assuming you're using URLSession to make the API request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                // Handle the API response
                // Assuming you have a generic JSONDecoder to decode the API response
                let decoder = JSONDecoder()
                // Check if the token has expired
                // Decode the API response data
//                print("Response \(response)")
                if let data = data {
                    do {
                        let outputStr  = String(data: data, encoding: String.Encoding.utf8) as! String
//                        print("outputStr \(outputStr)")
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
}
