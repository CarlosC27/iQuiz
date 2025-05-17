//
//  NetworkService.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/14/25.
//

import Foundation
import Network

class NetworkService {
    static let shared = NetworkService()
    
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isConnected = false
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: monitorQueue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func downloadQuizzes(from urlString: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        if !isConnected {
            completion(.failure(NSError(domain: "Network Unavailable", code: 1, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 2, userInfo: nil)))
                return
            }
            
            do {
                let quizzes = try JSONDecoder().decode(QuizzesNetworkModel.self, from: data)
                let quizDictionaries = quizzes.map { $0.toDictionary() }
                completion(.success(quizDictionaries))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
