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
    }
    struct UserProfile {
        static let navigationBarTitle = "user_profile_navigation_bar_title"
    }
    struct MovieDetails {
        static let navigationBarTitle = "movie_details_navigation_bar_title"
        static let saveButtonText = "movie_details_save_button_text"
        static let shareButtonText = "movie_details_share_button_text"
        static let activityMessage = "movie_details_activity_message"
    }
    struct Alert {
        static let cancelAction = "alert_cancel_action"
        static let okAction = "alert_ok_action"
        
        struct DeleteMovie {
            static let title = "alert_delete_movie_title"
            static let questionMessage = "alert_delete_movie_question_message"
            static let deleteAction = "alert_delete_movie_delete_action"
        }
        struct AddNewMovie {
            static let title = "alert_add_new_movie_title"
            static let instructionsMessage = "alert_add_new_movie_instructions_message"
            static let findAction = "alert_add_new_movie_find_action"
            static let textfieldPlaceholder = "alert_add_new_movie_textfield_placeholder"
        }
        struct SortMovies {
            static let title = "alert_sort_movies_title"
            static let titleAction = "alert_sort_movies_title_action"
            static let releaseDateAction = "alert_sort_movies_release_date_action"
            static let imdbRatingAction = "alert_sort_movies_imdb_rating_action"
            static let metascoreRatingAction = "alert_sort_movies_metascore_rating_action"
        }
        struct MovieFound {
            static let title = "alert_movie_found_title"
            static let titleAndReleasedMassage = "alert_movie_found_title_and_released_message"
            static let importAction = "alert_movie_found_import_action"
        }
        struct MovieNotFound {
            static let title = "alert_movie_not_found_title"
        }
        struct ImportMovie {
            static let title = "alert_import_movie_title"
        }
        struct SaveMovie {
            static let title = "alert_save_movie_title"
            static let message = "alert_save_movie_message"
        }
    }
}
