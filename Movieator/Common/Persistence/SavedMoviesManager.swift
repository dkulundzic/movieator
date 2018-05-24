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
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("/UserMovies.realm")
    private lazy var realm = try! Realm(fileURL: documentsURL)

    func saveUserMovie(withID movieID: String) {
        let savedMovies = loadUserMovieIDs()
        for movie in savedMovies {
            if movie.id == movieID {return}
        }
        let savedMovie = SavedMovie()
        savedMovie.id = movieID
        do {
            try self.realm.write {
                self.realm.add(savedMovie)
            }
        } catch {
            print("Error saving movie, \(error)")
        }
    }
    
    func deleteSavedMovie(withId movieID: SavedMovie) {
        do {
            try self.realm.write {
                self.realm.delete(movieID)
            }
        } catch {
            print("Error deleting saved movie, \(error)")
        }
    }
    
    func loadUserMovieIDs() -> Results<SavedMovie> {
        return realm.objects(SavedMovie.self)
    }
}
