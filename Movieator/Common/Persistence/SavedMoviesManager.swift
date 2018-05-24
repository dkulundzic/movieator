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
    
    func loadUserMovieIDs() -> [String] {
        let movieIDs = realm.objects(SavedMovie.self).map { savedMovie -> String in
            return savedMovie.id
        }
        return Array(movieIDs)
    }
}
