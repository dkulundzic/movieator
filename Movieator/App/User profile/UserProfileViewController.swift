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

        navigationItem.title = NSLocalizedString("Saved movies", comment: "Title in navigation bar representing current screen.")
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
        cell.setupCell(with: movies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate Extension
extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertTitle = NSLocalizedString("Delete movie: \n\(movies[indexPath.item].title)", comment: "Notifying the user he is going to delete movie with supplied title.")
        let alertMassage = NSLocalizedString("Are you sure you want to delete this movie?", comment: "Asking for confirmation to delete the movie.")
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Confirming the action. Deleting movie.")
        let alert = UIAlertController.generic(title: alertTitle, message: alertMassage)
        alert.addAction(UIAlertAction(title: deleteActionTitle, style: .default, handler: { action in
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
