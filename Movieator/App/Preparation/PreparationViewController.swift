//
//  PreparationViewController.swift
//  Movieator
//
//  Created by Matej Korman on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class PreparationViewController : UIViewController {
    
    var movieIDs : [String] = []
    
    let movieFetcher = MovieFetcher()
    
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
        getIds()
        for id in movieIDs {
            if id.count > 0 {
                movieFetcher.fetchMovie(byId: id, success: movieReceived, failure: movieNotReceived)
            }
        }
    }
    
    func getIds() {
        if let filePath = Bundle.main.path(forResource: "movie_ids", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                movieIDs = contents.components(separatedBy: .newlines)
            } catch {
                print("Contenst could not be loaded, \(error)")
            }
        } else {
            print("File not found.")
        }
    }
}
