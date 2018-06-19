//
//  MovieSearchViewController.swift
//  Movieator
//
//  Created by Matej Korman on 17/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit
import RealmSwift

class MovieSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataController = DataController()
    private lazy var movies: Results<Movie> = dataController.loadMovies()
    private var filteredMovies = [Movie]()
    private let reuseIdentifier = "cell"
    weak var delegate: MovieSearchViewControllerDelegate?

    func filterMovies(with query: String) {
        filteredMovies = movies.filter { movies in movies.title.lowercased().contains(query.lowercased()) }
        collectionView.reloadData()
    }
}

// MARK: - Data Source Extension
extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        cell.setupCell(with: filteredMovies[indexPath.item])
        return cell
    }
}

// MARK: - Delegate Flow Layout Extension
extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - Collection View Delegate Extension
extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellFrame = collectionView.cellForItem(at: indexPath)?.frame else { return }
        let cellFrameInRootSuperview = collectionView.convert(cellFrame, to: nil)
        delegate?.movieSearch(self, didSelectMovie: filteredMovies[indexPath.item], frame: cellFrameInRootSuperview)
    }
}
