//
//  SavedMoviesManager.swift
//  Movieator
//
//  Created by Matej Korman on 21/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation
import RealmSwift

class SavedMoviesManager {    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("/UserMovies.realm")
    lazy var idRealm = try! Realm(fileURL: documentsURL)

    func saveUserMovie(withID movieID: String) {
        let savedMovie = SavedMovie()
        savedMovie.id = movieID
        do {
            try self.idRealm.write {
                self.idRealm.add(savedMovie)
            }
        } catch {
            print("Error saving movie, \(error)")
        }
    }
    
    func loadUserMovieIDs() -> [String] {
        let movies = idRealm.objects(SavedMovie.self)
        let movieIDs = convertToString(movies: movies)
        return Array(movieIDs)
    }
    
    func convertToString(movies: Results<SavedMovie>) -> [String] {
        var moviesString: [String] = []
        for movie in movies {
            moviesString.append(movie.id)
        }
        return moviesString
    }
}
