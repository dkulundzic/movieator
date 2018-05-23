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
    private lazy var movies : [Movie] = data.loadMovies(with: movieIDs)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "SAVED MOVIES"
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.backBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopButttonPressed))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func stopButttonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Data Source Extension
extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        
        let movie = movies[indexPath.item]
        cell.titleLabel.text = movie.title
        let year = String(Calendar.current.component(.year, from: movie.releaseDate))
        cell.yearLabel.text = year
        cell.imageView.layer.cornerRadius = 30.0
        cell.imageView.clipsToBounds = true
        
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: movie.poster,
            success: { (data) in
                let image = UIImage(data: data)
                cell.imageView.image = image
            },
            failure: { (error) in
                print("Error getting poster, \(error)")
            })
        return cell
    }
}
