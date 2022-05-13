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
        case invalidConfig
        case invalidPayload
        case invalidURL
        case invalidResponse
    }
    
    public init() {
    }

    public func fetchKillswitches(parameters: [String: String] = [:], completion: @escaping ([String: KillswitchPayload], Error?) -> Void) {
        guard
            let host = KSKitConfig.shared.host,
            let scheme = KSKitConfig.shared.scheme
        else {
            completion([:], ApiError.invalidConfig)
            return
        }
        
        guard let url = buildUrlQuery(from: host, scheme: scheme, port: KSKitConfig.shared.port, path: "/killswitch/available", parameters: parameters) else {
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

// MARK: - Private
extension KillSwitchApiService {
    
    func buildUrlQuery(from host: String, scheme: String = "https", port: Int?, path: String?, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.port = port
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
}
