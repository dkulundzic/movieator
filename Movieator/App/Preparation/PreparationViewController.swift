//
//  PreparationViewController.swift
//  Movieator
//
//  Created by Matej Korman on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class PreparationViewController: UIViewController {
    let movieFetcher: MovieFetcher = MovieFetcher()
    let data = DataController()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.addSubview(activityIndicator)
        activityIndicator.frame = loadingView.bounds
        activityIndicator.startAnimating()
        getMovies()
    }
    
    func movieReceived(movie: Movie) {
        data.saveMovies(movie: movie)
    }
    
    func movieNotReceived(error: Error) {
        print(error)
    }
    
    func didCompleteFetchingAndStoringMovies() {
        activityIndicator.removeFromSuperview()
        let movieListViewController = MovieListViewController()
        navigationController?.pushViewController(movieListViewController, animated: true)
    }
    
    func getMovies() {
        let group = DispatchGroup()
        let movieIDs = getIds()
        
        for id in movieIDs {
            group.enter()
            movieFetcher.fetchMovie(byId: id,
                success: { [weak self] movie in
                    self?.movieReceived(movie: movie)
                    group.leave() },
                failure: { [weak self] error in
                    self?.movieNotReceived(error: error)
                    group.leave() })
        }
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.didCompleteFetchingAndStoringMovies()
        }
    }
        
    func getIds() -> [String] {
        if let filePath = Bundle.main.path(forResource: "movie_ids", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                let movieIDs = contents.components(separatedBy: .newlines)
                return movieIDs
            } catch {
                return []
            }
        } else {
            return []
        }
    }
}
