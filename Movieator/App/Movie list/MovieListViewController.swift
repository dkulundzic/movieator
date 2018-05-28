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
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let data = DataController()
    private let reuseIdentifier = "cell"
    private lazy var movies : Results<Movie> = data.loadMovies()
    private let movieSearchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
    private var realmToken = NotificationToken()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        let searchController = UISearchController(searchResultsController: movieSearchResultsViewController)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchResultsUpdater = self
        movieSearchResultsViewController.delegate = self
        
        let userButton = UIBarButtonItem(image: #imageLiteral(resourceName: "userProfileIcon"), style: .plain, target: self, action: #selector(userButtonTapped))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addIcon"), style: .plain, target: self, action: #selector(addButtonTapped))

        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sortIcon"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [userButton, addButton]
        
        realmToken = movies.observe { realm in
            self.collectionView.reloadData()
        }
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController(title: "Add new movies", message: "", preferredStyle: .alert)
        let importButton = UIAlertAction(title: "Import", style: .default, handler: { action in
            if let id = alert.textFields?.first?.text {
                self.importMovie(with: id)
            }
        })
        alert.addAction(importButton)
        alert.addTextField { textField in
            textField.placeholder = "Place IMDB ID here."
            NotificationCenter.default.addObserver(forName: nil, object: textField, queue: OperationQueue.main, using: { _ in
                importButton.isEnabled = textField.text?.count == 9
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func sortButtonTapped() {
        let alert = UIAlertController(title: "Sort movies:", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "By title", style: .default, handler: { [weak self] action in
            self?.sortMovies(withKey: "title")
        }))
        alert.addAction(UIAlertAction(title: "By release date", style: .default, handler: { [weak self] action in
            self?.sortMovies(withKey: "releaseDate")
        }))
        alert.addAction(UIAlertAction(title: "By IMDB rating", style: .default, handler: { [weak self] action in
            self?.sortMovies(withKey: "imdbRating")
        }))
        alert.addAction(UIAlertAction(title: "By Metascore rating", style: .default, handler: { [weak self] action in
            self?.sortMovies(withKey: "metascore")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func userButtonTapped() {
        let userProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController")
        let navController = UINavigationController(rootViewController: userProfileViewController)
        navController.navigationBar.prefersLargeTitles = true
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.setupCell(with: movies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsViewController.movie = movies[indexPath.item]
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        movieSearchResultsViewController.filterMovies(movies: Array(movies), with: searchController.searchBar.text ?? "")
    }
}

// MARK: - MovieSearchViewControllerDelegate
extension MovieListViewController: MovieSearchViewControllerDelegate {
    func movieSearch(_ movieSearch: MovieSearchViewController, didSelectMovie movie: Movie) {
        let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

// MARK: - Private Methods
private extension MovieListViewController {
    func sortMovies(withKey: String) {
        movies = movies.sorted(byKeyPath: withKey, ascending: true)
        collectionView.reloadData()
    }
    
    func importMovie(with id: String) {
        let movieFetcher = MovieFetcher()
        movieFetcher.fetchMovie(byId: id,
            success: { movie in
                self.data.saveMovies(movie: movie)
                let alert = UIAlertController(title: "Movie saved", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true) },
            failure: { error in
                let alert = UIAlertController(title: "Movie not saved", message: "Error ocured while trying to fetch movie", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true) })
    }
}
