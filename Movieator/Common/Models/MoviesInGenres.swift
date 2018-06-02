//
//  MoviesInGenres.swift
//  Movieator
//
//  Created by Matej Korman on 02/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

class MoviesInGenres{
    var genre = ""
    var movies: [Movie] = []
    
    init(genre: String) {
        self.genre = genre
    }
    
    func sortMovies(byKey key: String) {
        switch key {
        case "releaseDate":
            movies = movies.sorted { (lhs, rhs) -> Bool in
                return lhs.releaseDate > rhs.releaseDate
            }
        case "imdbRating":
            movies = movies.sorted { (lhs, rhs) -> Bool in
                return lhs.imdbRating > rhs.imdbRating
            }
        case "metascore":
            movies = movies.sorted { (lhs, rhs) -> Bool in
                return lhs.metascore > rhs.metascore
            }
        default:
            movies = movies.sorted { (lhs, rhs) -> Bool in
                return lhs.title < rhs.title
            }
        }
    }
}
