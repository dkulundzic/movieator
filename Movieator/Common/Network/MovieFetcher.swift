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
    
    func fetchMovie(byId id: String, success: @escaping (Movie) -> Void, failure: @escaping (LocalizedError) -> Void) {
        let url = produceURL(forId: id)
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseError = error {
                DispatchQueue.main.async { failure(MovieFetcherError.generic(responseError)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { failure(MovieFetcherError.invalidData) }
                return
            }
            
            if let movie = self.parseJSON(movieData: data) {
                DispatchQueue.main.async { success(movie) }
            } else if let error = self.parseJSON(errorData: data) {
                DispatchQueue.main.async { failure(error) }
            } else {
                DispatchQueue.main.async { failure(MovieFetcherError.invalidData) }
            }
        }
        dataTask.resume()
    }
    
    func parseJSON(movieData: Data) -> Movie? {
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_US")
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
            return try JSONDecoder().decode(ResponseError.self, from: errorData)
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
