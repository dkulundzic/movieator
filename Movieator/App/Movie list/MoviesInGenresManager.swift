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
    private let allGenres = [
        "action",
        "adventure",
        "animation",
        "biography",
        "comedy",
        "crime",
        "documentary",
        "drama",
        "family",
        "fantasy",
        "film-noir",
        "history",
        "horror",
        "music",
        "musical",
        "mystery",
        "romance",
        "sci-fi",
        "short",
        "sport",
        "superhero",
        "thriller",
        "war",
        "western",
        "game-show",
        "reality-tv",
        "talk-show"
    ]
    private let dataController = DataController()
    private lazy var movies: Results<Movie> = dataController.loadMovies()
    private var moviesInGenres: [MoviesInGenres] = []
    private var sortKey: MovieSortKey = .title {
        didSet {
            moviesInGenres.forEach { $0.sortMovies(byKey: sortKey) }
        }
    }
    
    init() {
        moviesInGenres = allGenres.map { genre -> MoviesInGenres in
            let genreMovies = movies.filter { $0.genre.contains(genre) }
            return MoviesInGenres(genre: genre, movies: Array(genreMovies))
        }
    }
    
    func getGenreMovies(for genre: String) -> [Movie] {
        return moviesInGenres.first(where: { $0.genre == genre })?.movies ?? []
    }
    
    func getAvalibleGenres() -> [String] {
        return moviesInGenres.filter { !$0.movies.isEmpty }.map { $0.genre }
    }
    
    func sortMovies(withKey sortKey: MovieSortKey) -> Bool {
        if self.sortKey == sortKey { return false }
        self.sortKey = sortKey
        return true
    }
    
    func getMovies() -> Results<Movie> {
        return movies
    }
}
