//
//  PreparationViewController.swift
//  Movieator
//
//  Created by Matej Korman on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class PreparationViewController: UIViewController {
    private let movieFetcher: MovieFetcher = MovieFetcher()
    private let data = DataController()
    private let preparationView = PreparationView().autolayoutView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getMovies()
    }
}

// MARK: - Private Methods
private extension PreparationViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(preparationView)
        preparationView.activityIndicator.startAnimating()
        preparationView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    func didCompleteFetchingAndStoringMovies() {
        preparationView.activityIndicator.removeFromSuperview()
        let movieListViewController = MovieListViewController()
        navigationController?.pushViewController(movieListViewController, animated: true)
    }
    
    func movieReceived(movie: Movie) {
        data.saveMovies(movie: movie)
    }
    
    func movieNotReceived(error: Error) {
        print(error)
    }
}
