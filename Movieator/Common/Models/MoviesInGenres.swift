//
//  MoviesInGenres.swift
//  Movieator
//
//  Created by Matej Korman on 02/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

enum MovieSortKey: String {
    case releaseDate
    case imdbRating
    case metascore
    case title
    
    var filter: (Movie, Movie) -> Bool {
        switch self {
        case .releaseDate:
            return { lhs, rhs -> Bool in
                return lhs.releaseDate > rhs.releaseDate
            }
        case .imdbRating:
            return { lhs, rhs -> Bool in
                return lhs.imdbRating > rhs.imdbRating
            }
        case .metascore:
            return { lhs, rhs -> Bool in
                return lhs.metascore > rhs.metascore
            }
        case .title:
            return { lhs, rhs -> Bool in
                return lhs.title > rhs.title
            }
        }
    }
}

class MoviesInGenres {
    var genre = ""
    var movies: [Movie] = []
    
    init(genre: String, movies: [Movie] = []) {
        self.genre = genre
        self.movies = movies
    }
    
    func sortMovies(byKey key: MovieSortKey) {
        movies = movies.sorted(by: key.filter)
    }
}
