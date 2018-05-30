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
        let alert = UIAlertController.generic(title: "Add new movies", message: "Copy id from URL and paste it below.")
        let findButton = UIAlertAction(title: "Find", style: .default, handler: { action in
            if let id = alert.textFields?.first?.text {
                self.findMovie(with: id)
            }
        })
        alert.addAction(findButton)
        alert.addTextField { textField in
            textField.placeholder = "Place IMDB ID here."
            NotificationCenter.default.addObserver(forName: nil, object: textField, queue: OperationQueue.main, using: { _ in
                findButton.isEnabled = textField.text?.count == 9
            })
        }
        alert.present(target: self)
    }
    
    @objc func sortButtonTapped() {
        let actions = [UIAlertAction(title: "Title", style: .default, handler: { [weak self] action in
                        self?.sortMovies(withKey: "title")
                        }),
                       UIAlertAction(title: "Release date", style: .default, handler: { [weak self] action in
                        self?.sortMovies(withKey: "releaseDate")
                        }),
                       UIAlertAction(title: "IMDB rating", style: .default, handler: { [weak self] action in
                        self?.sortMovies(withKey: "imdbRating")
                        }),
                       UIAlertAction(title: "Metascore rating", style: .default, handler: { [weak self] action in
                        self?.sortMovies(withKey: "metascore")
                        })]
        let alert = UIAlertController.generic(title: "Sort movies by", actions: actions)
        alert.present(target: self)
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
        movies = movies.sorted(byKeyPath: withKey, ascending: false)
        collectionView.reloadData()
    }
    
    func findMovie(with id: String) {
        let movieFetcher = MovieFetcher()
        movieFetcher.fetchMovie(byId: id,
            success: { movie in
                let year = String(Calendar.current.component(.year, from: movie.releaseDate))
                let actions = [UIAlertAction(title: "Import", style: .default, handler: { action in self.importMovie(for: movie) } )]
                let alert = UIAlertController.generic(title: "Movie found", message: "Found movie titled \(movie.title), released in \(year).", preferredStyle: .actionSheet, actions: actions)
                alert.present(target: self) },
            failure: { error in
                let alert = UIAlertController.generic(title: "Movie not found", message: error.localizedDescription, cancelTitle: "Ok")
                alert.present(target: self) })
    }
    
    func importMovie(for movie: Movie) {
        data.saveMovies(movie: movie)
        let alert = UIAlertController.generic(title: "Movie saved", cancelTitle: "Ok")
        alert.present(target: self)
    }
}
