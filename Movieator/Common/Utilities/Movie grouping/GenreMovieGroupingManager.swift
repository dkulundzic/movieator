//
//  MoviesInGenresManager.swift
//  Movieator
//
//  Created by Matej Korman on 02/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit
import RealmSwift

enum Genre: String, EnumCollection {
    case action
    case adventure
    case animation
    case biography
    case comedy
    case crime
    case documentary
    case drama
    case family
    case fantasy
    case filmNoir = "film-noir"
    case history
    case horror
    case music
    case musical
    case mystery
    case romance
    case sciFi = "sci-fi"
    case short
    case sport
    case superhero
    case thriller
    case war
    case western
    case gameShow = "game-show"
    case realityTv = "reality-tv"
    case talkShow = "talk-show"
    
    static func allCases() -> [String] {
        return Array(Genre.cases).map({ $0.rawValue })
    }
}

class GenreMovieGroupingManager {
    private let dataController = DataController()
    private lazy var movies: Results<Movie> = dataController.loadMovies()
    private var moviesInGenres: [GenreMovieGrouping] = []
    private var sortKey: MovieSortKey?
    private var realmToken = NotificationToken()
    var dataChanged: (() -> Void)?

    init() {
        groupMoviesInGenres()
        realmToken = movies.observe { realm in
            self.groupMoviesInGenres()
            self.dataChanged?()
        }
    }
    
    func getGenreMovies(for genre: String) -> [Movie] {
        return moviesInGenres.first(where: { $0.genre == genre })?.movies ?? []
    }
  
    func getAvailableGenres() -> [String] {
        return moviesInGenres.filter { !$0.movies.isEmpty }.map { $0.genre }
    }
    
    func sortMovies(withKey sortKey: MovieSortKey) -> Bool {
        guard self.sortKey != sortKey else { return false }
        self.sortKey = sortKey
        moviesInGenres.forEach { $0.sortMovies(byKey: sortKey) }
        return true
    }
    
    func saveNewMovie(movie: Movie) {
        dataController.saveMovies(movie: movie)
    }
}

// MARK: - Private Methods
private extension GenreMovieGroupingManager {
    func groupMoviesInGenres() {
        moviesInGenres = Genre.allCases().map { genre -> GenreMovieGrouping in
            let genreMovies = movies.filter { $0.genre.lowercased().contains(genre) }
            return GenreMovieGrouping(genre: genre, movies: Array(genreMovies))
        }
    }
}
