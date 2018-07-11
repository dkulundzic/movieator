//
//  UserProfileViewController.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit
import RealmSwift

class UserProfileViewController: UIViewController {
    private let data = DataController()
    private let userMovieIDs = SavedMoviesManager()
    private lazy var movieIDs = userMovieIDs.loadUserMovieIDs()
    private lazy var movies = data.loadMovies(with: movieIDs)
    private let userProfileView = UserProfileView().autolayoutView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.setupCell(with: movies[indexPath.item])
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
            let predicate = NSPredicate(format: "id LIKE %@", self.movies[indexPath.item].imdbID)
            guard let movieID = self.movieIDs.filter(predicate).first else { return }
            self.userMovieIDs.deleteSavedMovie(withId: movieID)
            self.reloadData()
            collectionView.reloadData()
        }))
        alert.present(on: self)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - Private Methods Extension
private extension UserProfileViewController {
    func setupView() {
        navigationItem.title = LocalizationKey.UserProfile.navigationBarTitle.localized()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
        view.backgroundColor = .white
        view.addSubview(userProfileView)
        userProfileView.collectionView.delegate = self
        userProfileView.collectionView.dataSource = self
        userProfileView.collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        userProfileView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func reloadData() {
        movieIDs = userMovieIDs.loadUserMovieIDs()
        movies = data.loadMovies(with: movieIDs)
    }
}
