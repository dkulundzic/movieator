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
    //let baseURL = URL(string: "")!
    
    /// Attempts to fetch movie data from the OMDB API by using the provided imdb ID.
    /// - parameter id: The IMDB ID of the wanted movie.
    /// - parameter success: A closure to be invoked when a Movie is successfully retrieved and decoded.
    /// - parameter failure: A closure to be invoked when an error occurred during the movie retrieval.
    func fetchMovie(byId id: String, success: @escaping (Movie) -> Void, failure: @escaping (Error) -> Void) {
        let url = produceURL(forId: id)
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseError = error {
                print("Error getting data, \(responseError)")
                failure(responseError)
            }
//            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
//            print(json)
            
            // if "Response" in data == True - response is valid
            // else if "Response" in data == False - response is not valid i.e. faliure
            if let movieData = data {
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                guard let movie = self.parseJSON(movieData: movieData) else { return }
                success(movie)
            }
            
        }
        dataTask.resume()
    }
    
    func parseJSON(movieData: Data) -> Movie? {
        do {
            let decoder = JSONDecoder()
            let movie = try decoder.decode(Movie.self, from: movieData)
            //print(movie.title)
            return movie
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
