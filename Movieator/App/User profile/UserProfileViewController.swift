//
//  UserProfileViewController.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit
import RealmSwift

class UserProfileViewController: UIViewController {
    private let reuseIdentifier = "cell"
    private let data = DataController()
    private let userMovieIDs = SavedMoviesManager()
    private lazy var movieIDs = userMovieIDs.loadUserMovieIDs()
    private lazy var movies = data.loadMovies(with: movieIDs)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizationKey.MovieList.navigationBarTitle.localized()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Data Source Extension
extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.updateProperties(with: movies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate Extension
extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController.generic(title: LocalizationKey.UserProfile.deleteMovieAlertTitle.localized(movies[indexPath.item].title),
                                              message: LocalizationKey.UserProfile.deleteMovieAlertMessage.localized())
        alert.addAction(UIAlertAction(title: LocalizationKey.UserProfile.deleteMovieAlertDeleteAction.localized(),
                                      style: .default,
                                      handler: { action in
            self.userMovieIDs.deleteSavedMovie(withId: self.movieIDs[indexPath.item])
            self.reloadData()
            collectionView.reloadData()
        }))
        alert.present(on: self)
    }
}

// MARK: - Private Methods Extension
private extension UserProfileViewController {
    func reloadData() {
        movieIDs = userMovieIDs.loadUserMovieIDs()
        movies = data.loadMovies(with: movieIDs)
    }
}
