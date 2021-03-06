//
//  MovieListViewController.swift
//  Movieator
//
//  Created by Matej Korman on 15/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let moviesInGenresManager = GenreMovieGroupingManager()
    private let movieSearchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        let searchController = UISearchController(searchResultsController: movieSearchResultsViewController)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = LocalizationKey.MovieList.searchBarPlaceholder.localized()
        searchController.searchResultsUpdater = self
        movieSearchResultsViewController.delegate = self
        moviesInGenresManager.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
        let userButton = UIBarButtonItem(image: #imageLiteral(resourceName: "userProfileIcon"), style: .plain, target: self, action: #selector(userButtonTapped))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addIcon"), style: .plain, target: self, action: #selector(addButtonTapped))

        navigationItem.title = LocalizationKey.MovieList.navigationBarTitle.localized()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sortIcon"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [userButton, addButton]
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController.generic(title: LocalizationKey.MovieList.addNewMovieAlertTitle.localized(),
                                              message: LocalizationKey.MovieList.addNewMovieAlertMessage.localized())
        let findButton = UIAlertAction(title: LocalizationKey.MovieList.addNewMovieAlertFindAction.localized(),
                                       style: .default,
                                       handler: { action in
            if let id = alert.textFields?.first?.text {
                self.findMovie(with: id)
            }
        })
        alert.addAction(findButton)
        alert.addTextField { textField in
            textField.placeholder = LocalizationKey.MovieList.addNewMovieAlertTextfieldPlaceholder.localized()
            NotificationCenter.default.addObserver(forName: nil, object: textField, queue: OperationQueue.main, using: { _ in
                findButton.isEnabled = textField.text?.count == 9
            })
        }
        alert.present(on: self)
    }
    
    @objc func sortButtonTapped() {
        let actions = [
            UIAlertAction(title: LocalizationKey.MovieList.sortMoviesAlertTitleAction.localized(),
                          style: .default,
                          handler: { [weak self] action in self?.sortMovies(withKey: .title) }),
            UIAlertAction(title: LocalizationKey.MovieList.sortMoviesAlertReleaseDateAction.localized(),
                          style: .default,
                          handler: { [weak self] action in self?.sortMovies(withKey: .releaseDate) }),
            UIAlertAction(title: LocalizationKey.MovieList.sortMoviesAlertImdbRatingAction.localized(),
                          style: .default,
                          handler: { [weak self] action in self?.sortMovies(withKey: .imdbRating) }),
            UIAlertAction(title: LocalizationKey.MovieList.sortMoviesAlertMetascoreRatingAction.localized(),
                          style: .default,
                          handler: { [weak self] action in self?.sortMovies(withKey: .metascore) })]
        let alert = UIAlertController.generic(title: LocalizationKey.MovieList.sortMoviesAlertTitle.localized(),
                                              actions: actions)
        alert.present(on: self)
    }
    
    @objc func userButtonTapped() {
        let userProfileViewController = UserProfileViewController()
        let navController = UINavigationController(rootViewController: userProfileViewController)
        navController.navigationBar.prefersLargeTitles = true
        present(navController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesInGenresManager.getAvailableGenres().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! GenreTableViewCell
        cell.row = indexPath.section
        cell.moviesInGenresManager = moviesInGenresManager
        cell.didSelectItemAt = { [weak self] row, item in
            guard let strongSelf = self else { return }
            let genre = strongSelf.moviesInGenresManager.getAvailableGenres()[row]
            let movie = strongSelf.moviesInGenresManager.getGenreMovies(for: genre)[item]
            let movieDetailsViewController = MovieDetailsViewController(movie: movie)
            strongSelf.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let genre = moviesInGenresManager.getAvailableGenres()[section].localized()
        return genre
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
        let movieDetailsViewController = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

// MARK: - Private Methods
private extension MovieListViewController {
    func sortMovies(withKey sortKey: MovieSortKey) {
        if moviesInGenresManager.sortMovies(withKey: sortKey) {
            tableView.reloadData()
        }
    }
    
    func findMovie(with id: String) {
        let movieFetcher = MovieFetcher()
        movieFetcher.fetchMovie(byId: id,
            success: { movie in
                let year = String(Calendar.current.component(.year, from: movie.releaseDate))
                let actions = [UIAlertAction(title: LocalizationKey.MovieList.movieFoundAlertImportAction.localized(),
                                             style: .default,
                                             handler: { action in self.importMovie(for: movie) })]
                let alert = UIAlertController.generic(title: LocalizationKey.MovieList.movieFoundAlertTitle.localized(),
                                                      message: LocalizationKey.MovieList.movieFoundAlertMessage.localized(movie.title, year),
                                                      preferredStyle: .actionSheet,
                                                      actions: actions)
                alert.present(on: self) },
            failure: { error in
                let alert = UIAlertController.generic(title: LocalizationKey.MovieList.movieNotFoundAlertTitle.localized(),
                                                      message: error.localizedDescription,
                                                      cancelTitle: LocalizationKey.Alert.okAction.localized())
                alert.present(on: self) })
    }
    
    func importMovie(for movie: Movie) {
        moviesInGenresManager.saveNewMovie(movie: movie)
        let alert = UIAlertController.generic(title: LocalizationKey.MovieList.importMovieAlertTitle.localized(),
                                              cancelTitle: LocalizationKey.Alert.okAction.localized())
        alert.present(on: self)
    }
}
