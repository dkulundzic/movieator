//
//  PreparationViewController.swift
//  Movieator
//
//  Created by Matej Korman on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class PreparationViewController : UIViewController {
    let movieFetcher: MovieFetcher = MovieFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
    }
    
    func movieReceived(movie: Movie) {
        //Saving movies
        print(movie.title)
        print("Saving movies")
    }
    
    func movieNotReceived(error: Error) {
        //Movie not recieved
        
        print("Movie not recieved")
    }
    
    func getMovies() {
        let movieIDs = getIds()
        for id in movieIDs {
            movieFetcher.fetchMovie(byId: id, success: { [weak self] movie in
                self?.movieReceived(movie: movie)
                }, failure: { [weak self] error in
                    print(error.localizedDescription)
                    self?.movieNotReceived(error: error)
            })            
        }
    }
        
    func getIds() -> [String] {
        if let filePath = Bundle.main.path(forResource: "movie_ids", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let movieIDs = contents.components(separatedBy: .newlines)
                return movieIDs
            } catch {
                return []
            }
        } else {
            return []
        }
    }
}
