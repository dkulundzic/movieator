//
//  DataController.swift
//  Movieator
//
//  Created by Matej Korman on 11/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation
import RealmSwift

class DataController {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("/Movies.realm")
    lazy var realm = try! Realm(fileURL: documentsURL)
    
    func saveMovies(movie: Movie) {
        do {
            try self.realm.write {
                self.realm.add(movie)
            }
        } catch {
            print("Error saving movie, \(error)")
        }
    }
    
    func loadMovies() -> Results<Movie> {
        return realm.objects(Movie.self)
    }
    
    func loadMovies(with movieIDs: Results<SavedMovie>) -> Results<Movie> {
        let movieIDsArray = Array(movieIDs.map { $0.id })
        let predicate = NSPredicate(format: "imdbID IN %@", movieIDsArray)
        return realm.objects(Movie.self).filter(predicate)
    }
}
