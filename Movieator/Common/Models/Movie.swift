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
    let releaseDate : String
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
    let metascore : String
    let imdbRating : String
    let imdbVotes : String
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
        case type = "Type"
        case production = "Production"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.rated = try container.decode(String.self, forKey: .rated)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
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
        self.metascore = try container.decode(String.self, forKey: .metascore)
        self.imdbRating = try container.decode(String.self, forKey: .imdbRating)
        self.imdbVotes = try container.decode(String.self, forKey: .imdbVotes)
        self.type = try container.decode(String.self, forKey: .type)
        self.production = try container.decode(String.self, forKey: .production)
        
    }
}

