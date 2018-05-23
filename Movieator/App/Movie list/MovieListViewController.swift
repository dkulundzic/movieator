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
    private let data = DataController()
    private let reuseIdentifier = "cell"
    private lazy var movies : Results<Movie> = data.loadMovies()
    private let movieSearchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        let searchController = UISearchController(searchResultsController: movieSearchResultsViewController)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchResultsUpdater = self
        movieSearchResultsViewController.delegate = self
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "User", style: .plain, target: self, action: #selector(userButtonTapped))
    }
    
    @objc func userButtonTapped() {
        let userProfileViewController = UserProfileViewController()
        navigationController?.pushViewController(userProfileViewController, animated: true)
    }
}

// MARK: - Data Source Extension
extension MovieListViewController: UICollectionViewDataSource {
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

// MARK: - Collection View Delegate Extension
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsViewController.movie = movies[indexPath.item]
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

// MARK: - Delegate Flow Layout Extension
extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - Search Results Delegate
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        movieSearchResultsViewController.filterMovies(movies: Array(movies), with: searchController.searchBar.text ?? "")
    }
}

extension MovieListViewController: MovieSearchViewControllerDelegate {
    func goToMovieDetails(forMovie movie: Movie) {
        let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
