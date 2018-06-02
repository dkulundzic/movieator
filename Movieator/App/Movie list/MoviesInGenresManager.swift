//
//  MoviesInGenresManager.swift
//  Movieator
//
//  Created by Matej Korman on 02/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit
import RealmSwift

class MoviesInGenresManager {
    private let allGenres = ["action", "adventure", "animation", "biography", "comedy", "crime", "documentary", "drama", "family", "fantasy", "film-noir", "history", "horror", "music", "musical", "mystery", "romance", "sci-fi", "short", "sport", "superhero", "thriller", "war", "western", "game-show", "reality-tv", "talk-show"]
    private let dataController = DataController()
    private lazy var movies: Results<Movie> = dataController.loadMovies()
    private var moviesInGenres: [MoviesInGenres] = []
    private var sort = ""
    {
        didSet {
            for movies in moviesInGenres {
                movies.sortMovies(byKey: sort)
            }
        }
    }

    init() {
        for genre in allGenres {
            moviesInGenres.append(MoviesInGenres(genre: genre))
            for movie in movies {
                if movie.genre.lowercased().range(of: genre) != nil {
                    moviesInGenres.last?.movies.append(movie)
                }
            }
        }
    }
    
    func getGenreMovies(for genre: String) -> [Movie] {
        if let genreMovies = moviesInGenres.first(where: { $0.genre == genre }) {
            return genreMovies.movies
        }
        return []
    }
    
    func getAvalibleGenres() -> [String] {
        var avalibleGenres: [String] = []
        for genre in moviesInGenres {
            if !genre.movies.isEmpty {
                avalibleGenres.append(genre.genre)
            }
        }
        return avalibleGenres
    }
    
    func setSort(withKey sortKey: String) -> Bool {
        if sort == sortKey { return false }
        sort = sortKey
        return true
    }
    
    func getMovies() -> Results<Movie> {
        return movies
    }
}
