//
//  File.swift
//  
//
//  Created by Yannick Jacques on 2022-05-10.
//

import Foundation
import KillSwitchCoreKit

public final class KillSwitchApiService {
    
    public enum ApiError: Error {
        case invalidPayload
        case invalidURL
        case invalidResponse
    }
    
    public init() {
    }
    
    func buildUrlQuery(from host: String, scheme: String = "http", path: String?, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        
        if var path = path {
            if !path.starts(with: "/") {
                path = "/" + path
            }
            urlComponents.path = path
        }
        
        urlComponents.queryItems = parameters.compactMap { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        return urlComponents.url
    }

    public func fetchKillswitches(parameters: [String: String] = [:], completion: @escaping ([String: KillswitchPayload], Error?) -> Void) {
        guard let url = buildUrlQuery(from: "localhost:8080", scheme: "http", path: "/killswitch/available", parameters: parameters) else {
            completion([:], ApiError.invalidURL)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion([:], error)
                return
            }

            guard let data = data else {
                completion([:], ApiError.invalidResponse)
                return
            }

            do {
                let result = try JSONDecoder().decode([String: KillswitchPayload].self, from: data)
                completion(result, nil)
            } catch {
                completion([:], error)
            }
        }.resume()
    }
}
