//
//  MovieFetcher.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

enum MovieFetcherError: LocalizedError {
    case invalidData
    case generic(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data received from the server."
        case .generic(let error):
            return error.localizedDescription
        }
    }
}

class MovieFetcher {
    private let apiKey = "dc86f926"
    //let baseURL = URL(string: "")!
    
    /// Attempts to fetch movie data from the OMDB API by using the provided imdb ID.
    /// - parameter id: The IMDB ID of the wanted movie.
    /// - parameter success: A closure to be invoked when a Movie is successfully retrieved and decoded.
    /// - parameter failure: A closure to be invoked when an error occurred during the movie retrieval.
    func fetchMovie(byId id: String, success: @escaping (Movie) -> Void, failure: @escaping (LocalizedError) -> Void) {
        let url = produceURL(forId: id)
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseError = error {
                print("Error getting data, \(responseError)")
                return failure(
                    MovieFetcherError.generic(responseError)
                )
            }
            
            guard let data = data else {
                return failure(MovieFetcherError.invalidData)
            }
            
            if let movie = self.parseJSON(movieData: data) {
                success(movie)
            } else if let error = self.parseJSON(errorData: data) {
                failure(error)
            } else {
                failure(MovieFetcherError.invalidData)
            }
        }
        dataTask.resume()
    }
    
    func parseJSON(movieData: Data) -> Movie? {
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let movie = try decoder.decode(Movie.self, from: movieData)
            return movie
        } catch  {
            print("Error parsing JSON, \(error)")
            return nil
        }
    }
    
    func parseJSON(errorData: Data) -> ResponseError? {
        do {
            let decoder = JSONDecoder()
            let error = try decoder.decode(ResponseError.self, from: errorData)
            return error
        } catch  {
            print("Error parsing JSON, \(error)")
            return nil
        }
    }
    
    private func produceURL(forId id: String) -> URL {
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(id)") else {
            fatalError("Error creating OMDB API url with the id \(id).")
        }
        return url
    }
}
