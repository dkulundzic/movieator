//
//  MovieDetailsViewController.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: Movie!
    
    private let detailsView = MovieDetailsView.autolayoutView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let saveButtonTitle = LocalizationKey.MovieDetails.saveButtonText.localized()
        let shareButtonTitle = LocalizationKey.MovieDetails.shareButtonText.localized()
        let saveButton = UIBarButtonItem(title: saveButtonTitle, style: .plain, target: self, action: #selector(saveButtonTapped))
        let shareButton = UIBarButtonItem(title: shareButtonTitle, style: .plain, target: self, action: #selector(shareButtonTapped))
        
        navigationItem.title = LocalizationKey.MovieDetails.navigationBarTitle.localized()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [saveButton, shareButton]

        setupViews()
    }
    
    @objc func saveButtonTapped() {
        let savedMoviesManager = SavedMoviesManager()
        savedMoviesManager.saveUserMovie(withID: movie.imdbID)

        let alert = UIAlertController.generic(title: LocalizationKey.MovieDetails.saveMovieAlertTitle.localized(),
                                              message: LocalizationKey.MovieDetails.saveMovieAlertMessage.localized(),
                                              cancelTitle: LocalizationKey.Alert.okAction.localized())
        alert.present(on: self)
    }
    
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        let url = getMovieURL()
        let activityMessage = LocalizationKey.MovieDetails.activityMessage.localized()
        let activityViewController = UIActivityViewController(activityItems: [activityMessage, url], applicationActivities: nil)
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(detailsView)
        detailsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        detailsView.setupDetails(withMovie: movie)
    }
}

private extension MovieDetailsViewController {
    func getMovieURL() -> URL {
        guard let url = URL(string: "https://www.imdb.com/title/\(movie.imdbID)") else {
            fatalError("Error creating url for this movie.")
        }
        return url
    }
}
