//
//  MovieListViewController.swift
//  Movieator
//
//  Created by Matej Korman on 15/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit
import RealmSwift

class MovieListViewController: UIViewController {
    let reuseIdentifier = "cell"
    var movies : Results<Movie>?

    override func viewDidLoad() {
        navigationItem.backBarButtonItem = nil
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "User", style: .plain, target: self, action: #selector(userButtonTapped))
        
        let data = DataController()
        movies = data.loadMovies()
    }
    
    @objc func userButtonTapped() {
        let userProfileViewController = UserProfileViewController()
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }
}

// MARK: - Data Source Extension
extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        
        if let movie = movies?[indexPath.item] {
            cell.titleLabel.text = movie.title
            let year = String(Calendar.current.component(.year, from: movie.releaseDate))
            cell.yearLabel.text = year
            
            let posterFetcher = MoviePosterFetcher()
            posterFetcher.fetchMoviePoster(with: movie.poster,
                success: { (data) in
                    let image = UIImage(data: data)
                    cell.imageView.image = image
                },
                failure: { (error) in
                    print("Error getting poster, \(error)")
                })
        }
        
        return cell
    }
}

// MARK: - Collection View Delegate Extension
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movie = movies![indexPath.item]
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    //Add User Profile button pressed
}

// MARK: - Delegate Flow Layout Extension
extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}
