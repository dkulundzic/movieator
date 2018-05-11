//
//  Movie.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

class Movie : Codable{
    let title : String
    let rated : String
    let releaseDate : Date
    let runtime : String
    let genre : String
    let director : String
    let writer : String
    let actors : String
    let plot : String
    let language : String
    let country : String
    let awards : String
    let poster : String
    let metascore : Int
    let imdbRating : Double
    let imdbVotes : Int
    let imdbID : String
    let type : String
    let production : String
    
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
        
        if let temp = try Int(container.decode(String.self, forKey: .metascore)) {
            self.metascore = temp
        } else {
            self.metascore = 0
        }
        
        if let temp = try Double(container.decode(String.self, forKey: .imdbRating)) {
            self.imdbRating = temp
        } else {
            self.imdbRating = 0
        }
        
        if let temp = try Int(container.decode(String.self, forKey: .imdbVotes)) {
            self.imdbVotes = temp
        } else {
            self.imdbVotes = 0
        }
        
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.type = try container.decode(String.self, forKey: .type)
        self.production = try container.decode(String.self, forKey: .production)
    }
}

