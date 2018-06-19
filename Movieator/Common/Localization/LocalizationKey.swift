//
//  LocalizationKey.swift
//  Movieator
//
//  Created by Matej Korman on 13/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

struct LocalizationKey {
    struct MovieList {
        static let searchBarPlaceholder = "movie_list_search_bar_placeholder"
        static let navigationBarTitle = "movie_list_navigation_bar_title"
        
        static let addNewMovieAlertTitle = "movie_list_add_new_movie_alert_title"
        static let addNewMovieAlertMessage = "movie_list_add_new_movie_alert_message"
        static let addNewMovieAlertFindAction = "movie_list_add_new_movie_alert_find_action"
        static let addNewMovieAlertTextfieldPlaceholder = "movie_list_add_new_movie_alert_textfield_placeholder"
        
        static let sortMoviesAlertTitle = "movie_list_sort_movies_alert_title"
        static let sortMoviesAlertTitleAction = "movie_list_sort_movies_alert_title_action"
        static let sortMoviesAlertReleaseDateAction = "movie_list_sort_movies_alert_release_date_action"
        static let sortMoviesAlertImdbRatingAction = "movie_list_sort_movies_alert_imdb_rating_action"
        static let sortMoviesAlertMetascoreRatingAction = "movie_list_sort_movies_alert_metascore_rating_action"
        
        static let movieFoundAlertTitle = "movie_list_movie_found_alert_title"
        static let movieFoundAlertMessage = "movie_list_movie_found_alert_message"
        static let movieFoundAlertImportAction = "movie_list_movie_found_alert_import_action"
        
        static let movieNotFoundAlertTitle = "movie_list_movie_not_found_alert_title"
        
        static let importMovieAlertTitle = "movie_list_import_movie_alert_title"
    }
    
    struct UserProfile {
        static let navigationBarTitle = "user_profile_navigation_bar_title"
    
        static let deleteMovieAlertTitle = "user_profile_delete_movie_alert_title"
        static let deleteMovieAlertMessage = "user_profile_delete_movie_alert_message"
        static let deleteMovieAlertDeleteAction = "user_profile_delete_movie_alert_delete_action"
    }
    
    struct MovieDetails {
        static let navigationBarTitle = "movie_details_navigation_bar_title"
        static let saveButtonText = "movie_details_save_button_text"
        static let shareButtonText = "movie_details_share_button_text"
        static let activityMessage = "movie_details_activity_message"
        
        static let saveMovieAlertTitle = "movie_details_save_movie_alert_title"
        static let saveMovieAlertMessage = "movie_details_save_movie_alert_message"
    }
    
    struct Alert {
        static let cancelAction = "alert_cancel_action"
        static let okAction = "alert_ok_action"
    }
}
