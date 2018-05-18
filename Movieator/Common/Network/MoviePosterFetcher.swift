//
//  MoviePosterFetcher.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

enum MoviePosterFetcherError: LocalizedError {
    case invalidURLString
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURLString:
            return "Error creating URL for movie poster."
        case .noData:
            return "No data received."
        }
    }
}

class MoviePosterFetcher {
    func fetchMoviePoster(with url: String, success: @escaping (Data) -> Void  , failure: @escaping (Error) -> Void) {
        guard let url = URL(string: url) else {
            DispatchQueue.main.async { failure(MoviePosterFetcherError.invalidURLString) }
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseError = error {
                DispatchQueue.main.async { failure(responseError) }
                return
            }
            
            if let responseData = data {
                DispatchQueue.main.async { success(responseData) }
            } else {
                DispatchQueue.main.async { failure(MoviePosterFetcherError.noData) }
            }
        }
        dataTask.resume()
    }
}
