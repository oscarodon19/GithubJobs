//
//  Service.swift
//  GithubJobs
//
//  Created by Oscar Odon on 20/03/2021.
//

import Foundation

class Service {
    static let shared = Service()
    
    func getResults(description: String, completed: @escaping (Result<[Job], ErrorMessage>) -> Void) {
            let urlString = "https://jobs.github.com/positions.json?description=\(description.replacingOccurrences(of: " ", with: "+"))"
            guard let url = URL(string: urlString) else {return}
        
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let _ = error {
                    completed(.failure(.invalidData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode([Job].self, from: data)
                    completed(.success(results))
                } catch {
                    completed(.failure(.invalidData))
                }
            }
            task.resume()
        }
}
