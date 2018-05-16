//
//  MoviePosterFetcher.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MoviePosterFetcher {
    func fetchMoviePoster(with url: String, success: @escaping (Data) -> Void  , failure: @escaping (Error) -> Void) {
        guard let url = URL(string: url) else {
            fatalError("Error creating url for movie poster.")
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseError = error {
                DispatchQueue.main.async { failure(responseError) }
                return
            }
            
            if let responseData = data {
                DispatchQueue.main.async { success(responseData) }
            } else {
                print("No data received.")
            }
        }
        dataTask.resume()
    }
    
    
}
