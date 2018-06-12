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
        searchController.searchBar.placeholder = NSLocalizedString("Search Movies", comment: "Message telling the user that label input is going to be used as search predicate.")
        searchController.searchResultsUpdater = self
        movieSearchResultsViewController.delegate = self
        moviesInGenresManager.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
        let userButton = UIBarButtonItem(image: #imageLiteral(resourceName: "userProfileIcon"), style: .plain, target: self, action: #selector(userButtonTapped))
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addIcon"), style: .plain, target: self, action: #selector(addButtonTapped))

        navigationItem.title = NSLocalizedString("Main list", comment: "Informing the user he is in main list screen where all movies are displayed.")
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sortIcon"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [userButton, addButton]
    }
    
    @objc func addButtonTapped() {
        let alertTitle = NSLocalizedString("Add new movies", comment: "Notifying the user he can add a new movie.")
        let alertMassage = NSLocalizedString("Copy id from URL and paste it below.", comment: "Instructions how to add new movie.")
        let findActionTitle = NSLocalizedString("Find", comment: "Confirming the action. Finding new movie.")
        
        let alert = UIAlertController.generic(title: alertTitle, message: alertMassage)
        let findButton = UIAlertAction(title: findActionTitle, style: .default, handler: { action in
            if let id = alert.textFields?.first?.text {
                self.findMovie(with: id)
            }
        })
        alert.addAction(findButton)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("Place IMDB ID here.", comment: "Giving the user direction on where to put a string.")
            NotificationCenter.default.addObserver(forName: nil, object: textField, queue: OperationQueue.main, using: { _ in
                findButton.isEnabled = textField.text?.count == 9
            })
        }
        alert.present(on: self)
    }
    
    @objc func sortButtonTapped() {
        let alertTitle = NSLocalizedString("Sort movies by", comment: "Telling the user he is able to choose in what order to sort movies.")
        let sortByTitleActionTitle = NSLocalizedString("Title", comment: "Confirming the action. Sorting movies by title.")
        let sortByReleaseDateActionTitle = NSLocalizedString("Release date", comment: "Confirming the action. Sorting movies by release date.")
        let sortByImdbRatingActionTitle = NSLocalizedString("IMDB rating", comment: "Confirming the action. Sorting movies by IMDB rating.")
        let sortByMetascoreRatingActionTitle = NSLocalizedString("Metascore rating", comment: "Confirming the action. Sorting movies by Metascore rating.")
        
        let actions = [
            UIAlertAction(title: sortByTitleActionTitle, style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .title)
            }),
            UIAlertAction(title: sortByReleaseDateActionTitle, style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .releaseDate)
            }),
            UIAlertAction(title: sortByImdbRatingActionTitle, style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .imdbRating)
            }),
            UIAlertAction(title: sortByMetascoreRatingActionTitle, style: .default, handler: { [weak self] action in
                self?.sortMovies(withKey: .metascore)
            })]
        let alert = UIAlertController.generic(title: alertTitle, actions: actions)
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
            let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            let genre = strongSelf.moviesInGenresManager.getAvailableGenres()[row]
            let movie = strongSelf.moviesInGenresManager.getGenreMovies(for: genre)[item]
            movieDetailsViewController.movie = movie
            strongSelf.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let genre = NSLocalizedString(moviesInGenresManager.getAvailableGenres()[section], comment: "Displaying genre for headers.")
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
        let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
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
                let alertTitle = NSLocalizedString("Movie found", comment: "Notifying the user that a new movie was found.")
                let alertMassage = String(format: NSLocalizedString("Found movie titled %@, released in %@.", comment: "Notifying the user that movie with supplied title released in supplied year was found."), movie.title, year)
                let importActionTitle = NSLocalizedString("Import", comment: "Confirming the action. Importing new movie.")
                
                let actions = [UIAlertAction(title: importActionTitle, style: .default, handler: { action in self.importMovie(for: movie) } )]
                let alert = UIAlertController.generic(title: alertTitle, message: alertMassage, preferredStyle: .actionSheet, actions: actions)
                alert.present(on: self) },
            failure: { error in
                let alertTitle = NSLocalizedString("Movie not found", comment: "Notifying the user that the movie wasn't found.")
                let confirmingActionTitle = NSLocalizedString("Ok", comment: "Confirming the action. Acknowledging that movie isn't found.")
                
                let alert = UIAlertController.generic(title: alertTitle, message: error.localizedDescription, cancelTitle: confirmingActionTitle)
                alert.present(on: self) })
    }
    
    func importMovie(for movie: Movie) {
        moviesInGenresManager.saveNewMovie(movie: movie)
        let alertTitle = NSLocalizedString("Movie saved", comment: "Notifying the user that a movie was saved.")
        let confirmingActionTitle = NSLocalizedString("Ok", comment: "Confirming the action. Acknowledging that movie is saved.")
        
        let alert = UIAlertController.generic(title: alertTitle, cancelTitle: confirmingActionTitle)
        alert.present(on: self)
    }
}
