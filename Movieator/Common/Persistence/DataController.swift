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
    let realm = try! Realm()
    
    func saveMovies(movie: Movie) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(movie)
                }
            } catch {
                print("Error saving movie, \(error)")
            }
        }
    }
    
    func loadMovies() -> Results<Movie> {
        return realm.objects(Movie.self)
    }
}
