//
//  MovieDetailsViewController.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    private let movie: Movie
    private let detailsView = MovieDetailsView.autolayoutView()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
        setupNavigationBar()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions
private extension MovieDetailsViewController {
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
}

// MARK: - Private Methods
private extension MovieDetailsViewController {
    func getMovieURL() -> URL {
        guard let url = URL(string: "https://www.imdb.com/title/\(movie.imdbID)") else {
            fatalError("Error creating url for this movie.")
        }
        return url
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(detailsView)
        detailsView.updateProperties(withMovie: movie)
        detailsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        let saveButtonTitle = LocalizationKey.MovieDetails.saveButtonText.localized()
        let shareButtonTitle = LocalizationKey.MovieDetails.shareButtonText.localized()
        let saveButton = UIBarButtonItem(title: saveButtonTitle, style: .plain, target: self, action: #selector(saveButtonTapped))
        let shareButton = UIBarButtonItem(title: shareButtonTitle, style: .plain, target: self, action: #selector(shareButtonTapped))
        
        navigationItem.title = LocalizationKey.MovieDetails.navigationBarTitle.localized()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
}
