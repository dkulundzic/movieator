//
//  Movie.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: Object, Codable {
    @objc dynamic var title: String = ""
    @objc dynamic var rated: String = ""
    @objc dynamic var releaseDate: Date = Date()
    @objc dynamic var runtime: String = ""
    @objc dynamic var genre: String = ""
    @objc dynamic var director: String = ""
    @objc dynamic var writer: String = ""
    @objc dynamic var actors: String = ""
    @objc dynamic var plot: String = ""
    @objc dynamic var language: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var awards: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var metascore: Int = 0
    @objc dynamic var imdbRating: Double = 0
    @objc dynamic var imdbVotes: Int = 0
    @objc dynamic var imdbID: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var production: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case rated = "Rated"
        case releaseDate = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case metascore = "Metascore"
        case imdbRating
        case imdbVotes
        case imdbID
        case type = "Type"
        case production = "Production"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        self.title = try container.decode(String.self, forKey: .title)
        self.rated = try container.decode(String.self, forKey: .rated)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        self.runtime = try container.decode(String.self, forKey: .runtime)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.director = try container.decode(String.self, forKey: .director)
        self.writer = try container.decode(String.self, forKey: .writer)
        self.actors = try container.decode(String.self, forKey: .actors)
        self.plot = try container.decode(String.self, forKey: .plot)
        self.language = try container.decode(String.self, forKey: .language)
        self.country = try container.decode(String.self, forKey: .country)
        self.awards = try container.decode(String.self, forKey: .awards)
        self.poster = try container.decode(String.self, forKey: .poster)
        
        if let metascore = try Int(container.decode(String.self, forKey: .metascore)) {
            self.metascore = metascore
        } else {
            self.metascore = 0
        }
        
        if let imdbRating = try Double(container.decode(String.self, forKey: .imdbRating)) {
            self.imdbRating = imdbRating
        } else {
            self.imdbRating = 0
        }
        
        if let imdbVotes = try Int(container.decode(String.self, forKey: .imdbVotes)) {
            self.imdbVotes = imdbVotes
        } else {
            self.imdbVotes = 0
        }
        
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.type = try container.decode(String.self, forKey: .type)
        self.production = try container.decode(String.self, forKey: .production)
    }
}

