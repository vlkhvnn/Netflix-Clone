//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Alikhan Tangirbergen on 17.09.2023.
//

import Foundation
import Alamofire
struct Constants {
    static let API_KEY = "43ded7021f1ee5aef9956a51c88fc840"
    static let baseURL = "https://www.themoviedb.org"
    static let AuthKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0M2RlZDcwMjFmMWVlNWFlZjk5NTZhNTFjODhmYzg0MCIsInN1YiI6IjY1MDYxZWUzMzczYWMyMDBhY2Q2NTA2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1ypeN4WnlmQvbnXGWI64bF5xcD1aGcLDCYF69Z6Xi2E"
}

class APICaller {
    static let shared = APICaller()
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": Constants.AuthKey
        ]
        
        AF.request("https://api.themoviedb.org/3/trending/movie/day?language=en-US", headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let trendingMoviesResponse = try decoder.decode(TrendingMoviesResponse.self, from: data)
                            completion(.success(trendingMoviesResponse.results))
                            
                        } catch {
                            completion(.failure(error)) // Pass the error to the completion handler
                        }
                        
                    } else {
                        let error = NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getTrendingTV(completion: @escaping (Result<[TV], Error>) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": Constants.AuthKey
        ]
        
        AF.request("https://api.themoviedb.org/3/trending/tv/day?language=en-US", headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let trendingTVsResponse = try decoder.decode(TrendingTVsResponse.self, from: data)
                            completion(.success(trendingTVsResponse.results))
                            
                        } catch {
                            completion(.failure(error)) // Pass the error to the completion handler
                        }
                        
                    } else {
                        let error = NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON response"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

}
