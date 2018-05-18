//
//  MovieSearchViewController.swift
//  Movieator
//
//  Created by Matej Korman on 17/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var filteredMovies = [Movie]()
    private let reuseIdentifier = "cell"

    func filterMovies(movies: [Movie], with query: String) {
        filteredMovies = movies.filter { movies in movies.title.lowercased().contains(query.lowercased()) }
        collectionView.reloadData()
    }
}

// MARK: - Data Source Extension
extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies[indexPath.item]
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
        return cell
    }
}

// MARK: - Delegate Flow Layout Extension
extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}
