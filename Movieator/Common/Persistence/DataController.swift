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
        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)

        backgroundQueue.async {
            print("Dispatched to background queue")
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.add(movie)
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
