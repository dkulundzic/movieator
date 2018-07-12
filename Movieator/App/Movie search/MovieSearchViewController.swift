//
//  MovieSearchViewController.swift
//  Movieator
//
//  Created by Matej Korman on 17/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit
import RealmSwift

class MovieSearchViewController: UIViewController {
    private let dataController = DataController()
    private lazy var movies: Results<Movie> = dataController.loadMovies()
    private var filteredMovies = [Movie]()
    private let movieSearchView = MovieSearchView.autolayoutView()
    weak var delegate: MovieSearchViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension MovieSearchViewController {
    func filterMovies(with query: String) {
        filteredMovies = movies.filter { movies in movies.title.lowercased().contains(query.lowercased()) }
        movieSearchView.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.setupCell(with: filteredMovies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - UICollectionViewDelegate
extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieSearch(self, didSelectMovie: filteredMovies[indexPath.item])
    }
}

// MARK: - Private Methods
private extension MovieSearchViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(movieSearchView)
        movieSearchView.collectionView.delegate = self
        movieSearchView.collectionView.dataSource = self
        movieSearchView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
