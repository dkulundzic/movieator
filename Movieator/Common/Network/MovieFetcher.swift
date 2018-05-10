//
//  MovieFetcher.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

class MovieFetcher {
    private let apiKey = "dc86f926"
    let baseURL = URL(string: "")!
    
    /// Attempts to fetch movie data from the OMDB API by using the provided imdb ID.
    /// - parameter id: The IMDB ID of the wanted movie.
    /// - parameter success: A closure to be invoked when a Movie is successfully retrieved and decoded.
    /// - parameter failure: A closure to be invoked when an error occurred during the movie retrieval.
    func fetchMovie(byId id: String, success: (Movie) -> Void, failure: (Error) -> Void) {
        let url = produceURL(forId: id)
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
        }
    }

    private func produceURL(forId id: String) -> URL {
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=\(apiKey)i=\(id)") else {
            fatalError("Error creating OMDB API url with the id \(id).")
        }
        return url
    }
}
