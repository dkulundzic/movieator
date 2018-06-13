//
//  LocalizationKey.swift
//  Movieator
//
//  Created by Matej Korman on 13/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

enum LocalizationKey: String {
    case savedMovies = "Saved movies"
    case deleteMovie_ = "Delete movie: \n%@"
    case areYouSureYouWantToDeleteThisMovie = "Are you sure you want to delete this movie?"
    case cancel = "Cancel"
    case delete = "Delete"
    case searchMovies = "Search Movies"
    case addNewMovies = "Add new movies"
    case copyIdFromURLAndPasteItBelow = "Copy id from URL and paste it below."
    case placeIMDBIDHere = "Place IMDB ID here."
    case title = "Title"
    case releaseDate = "Release date"
    case IMDBRating = "IMDB rating"
    case metascoreRating = "Metascore rating"
    case sortMoviesBy = "Sort movies by"
    case importMovie = "Import"
    case movieFound = "Movie found"
    case foundMovieTitled_ReleasedIn_ = "Found movie titled %@, released in %@."
    case movieNotFound = "Movie not found"
    case movieSaved = "Movie saved"
    case save = "Save"
    case share = "Share"
    case movieDetails = "Movie details"
    case saveMovie = "Save movie"
    case ok = "Ok"
    case lookIveFoundACoolMovie = "Look I've found a cool movie!"
    case find = "Find"
    case mainList = "Main list"
}

struct LocalizationString {
    static func getString(forKey key: LocalizationKey) -> String {
        switch key {
        case .savedMovies:
            return NSLocalizedString(key.rawValue, comment: "Title in navigation bar representing current screen.")
        case .deleteMovie_:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user he is going to delete movie with supplied title.")
        case .areYouSureYouWantToDeleteThisMovie:
            return NSLocalizedString(LocalizationKey.areYouSureYouWantToDeleteThisMovie.rawValue, comment: "Asking for confirmation to delete the movie.")
        case .cancel:
            return NSLocalizedString(key.rawValue, comment: "Canceling or dismissing alert.")
        case .delete:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Deleting movie.")
        case .searchMovies:
            return NSLocalizedString(key.rawValue, comment: "Message telling the user that label input is going to be used as search predicate.")
        case .addNewMovies:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user he can add a new movie.")
        case .copyIdFromURLAndPasteItBelow:
            return NSLocalizedString(key.rawValue, comment: "Instructions how to add new movie.")
        case .placeIMDBIDHere:
            return NSLocalizedString(key.rawValue, comment: "Giving the user direction on where to put a string.")
        case .title:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Sorting movies by title.")
        case .releaseDate:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Sorting movies by release date.")
        case .IMDBRating:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Sorting movies by IMDB rating.")
        case .metascoreRating:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Sorting movies by Metascore rating.")
        case .sortMoviesBy:
            return NSLocalizedString(key.rawValue, comment: "Telling the user he is able to choose in what order to sort movies.")
        case .importMovie:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Importing new movie.")
        case .movieFound:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user that a new movie was found.")
        case .foundMovieTitled_ReleasedIn_:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user that movie with supplied title released in supplied year was found.")
        case .movieNotFound:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user that the movie wasn't found.")
        case .movieSaved:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user that a movie was saved.")
        case .save:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Saving the movie.")
        case .share:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Sharing the movie.")
        case .movieDetails:
            return NSLocalizedString(key.rawValue, comment: "Title in navigation bar representing current screen.")
        case .saveMovie:
            return NSLocalizedString(key.rawValue, comment: "Notifying the user that current action is saving movies.")
        case .ok:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Acknowledging that movie isn't found.")
        case .lookIveFoundACoolMovie:
            return NSLocalizedString(key.rawValue, comment: "Telling your frieds that you found a movie that you like.")
        case .find:
            return NSLocalizedString(key.rawValue, comment: "Confirming the action. Finding new movie.")
        case .mainList:
            return NSLocalizedString(key.rawValue, comment: "Informing the user he is in main list screen where all movies are displayed.")
        }
    }
}
