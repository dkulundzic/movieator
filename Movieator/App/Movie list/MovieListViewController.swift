//
//  MovieListViewController.swift
//  Movieator
//
//  Created by Matej Korman on 15/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let moviesInGenresManager = GenreMovieGroupingManager()
    private let reuseIdentifier = "cell"
    private let movieSearchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        let searchController = UISearchController(searchResultsController: movieSearchResultsViewController)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchResultsUpdater = self
        movieSearchResultsViewController.delegate = self
        moviesInGenresManager.dataChanged = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        let userButton = UIBarButtonItem(image: #imageLiteral(resourceName: "userProfileIcon"), style: .plain, target: self, action: #selector(userButtonTapped))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addIcon"), style: .plain, target: self, action: #selector(addButtonTapped))

        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sortIcon"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [userButton, addButton]
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
        alert.present(on: self)
    }
    
    @objc func sortButtonTapped() {
        let actions = [
            UIAlertAction(title: "Title", style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .title)
            }),
            UIAlertAction(title: "Release date", style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .releaseDate)
            }),
            UIAlertAction(title: "IMDB rating", style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .imdbRating)
            }),
            UIAlertAction(title: "Metascore rating", style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .metascore)
            })]
        let alert = UIAlertController.generic(title: "Sort movies by", actions: actions)
        alert.present(on: self)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return moviesInGenresManager.getAvailibleGenres().count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "MovieListHeaderView",
                                                                             for: indexPath) as! MovieListHeaderView
            headerView.label.text = moviesInGenresManager.getAvailibleGenres()[indexPath.section].capitalized
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let genre = moviesInGenresManager.getAvailibleGenres()[section]
        return moviesInGenresManager.getGenreMovies(for: genre).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        let genre = moviesInGenresManager.getAvailibleGenres()[indexPath.section]
        let movie = moviesInGenresManager.getGenreMovies(for: genre)[indexPath.item]
        cell.setupCell(with: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        let genre = moviesInGenresManager.getAvailibleGenres()[indexPath.section]
        let movie = moviesInGenresManager.getGenreMovies(for: genre)[indexPath.item]
        movieDetailsViewController.movie = movie
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
        movieSearchResultsViewController.filterMovies(with: searchController.searchBar.text ?? "")
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
    func sortMovies(withKey sortKey: MovieSortKey) {
        if moviesInGenresManager.sortMovies(withKey: sortKey) {
            collectionView.reloadData()
        }
    }
    
    func findMovie(with id: String) {
        let movieFetcher = MovieFetcher()
        movieFetcher.fetchMovie(byId: id,
            success: { movie in
                let year = String(Calendar.current.component(.year, from: movie.releaseDate))
                let actions = [UIAlertAction(title: "Import", style: .default, handler: { action in self.importMovie(for: movie) } )]
                let alert = UIAlertController.generic(title: "Movie found", message: "Found movie titled \(movie.title), released in \(year).", preferredStyle: .actionSheet, actions: actions)
                alert.present(on: self) },
            failure: { error in
                let alert = UIAlertController.generic(title: "Movie not found", message: error.localizedDescription, cancelTitle: "Ok")
                alert.present(on: self) })
    }
    
    func importMovie(for movie: Movie) {
        moviesInGenresManager.saveNewMovie(movie: movie)
        let alert = UIAlertController.generic(title: "Movie saved", cancelTitle: "Ok")
        alert.present(on: self)
    }
}
