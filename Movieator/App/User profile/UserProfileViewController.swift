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
    private let reuseIdentifier = "cell"
    private let data = DataController()
    private let userMovieIDs = SavedMoviesManager()
    private lazy var movieIDs = userMovieIDs.loadUserMovieIDs()
    private lazy var movies = data.loadMovies(with: movieIDs)
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout).autolayoutView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
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
            self.userMovieIDs.deleteSavedMovie(withId: self.movieIDs[indexPath.item])
            self.reloadData()
            collectionView.reloadData()
        }))
        alert.present(on: self)
    }
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - Private Methods Extension
private extension UserProfileViewController {
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .white
        let sizeOfCell = (self.view.bounds.size.width - 30) / 2
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(sizeOfCell + 20)
        }
    }
    
    func reloadData() {
        movieIDs = userMovieIDs.loadUserMovieIDs()
        movies = data.loadMovies(with: movieIDs)
    }
}
