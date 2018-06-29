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
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        activityIndicator.startAnimating()
        getMovies()
    }
    
    func setupViews() {
        setupActivityIndicator()
        setupTitleLabel()
    }
    
    func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func setupTitleLabel() {
        self.view.addSubview(titleLabel)
        titleLabel.text = LocalizationKey.Preparation.title.localized()
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 35)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom)
        }
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
