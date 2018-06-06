//
//  TableViewCell.swift
//  Movieator
//
//  Created by Matej Korman on 05/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var moviesInGenresManager: GenreMovieGroupingManager?
    var didSelectItemAt: ((Int, Int) -> Void)?
    
    var row = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension GenreTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moviesInGenresManager = moviesInGenresManager else { return 1 }
        let genre = moviesInGenresManager.getAvailibleGenres()[row]
        return moviesInGenresManager.getGenreMovies(for: genre).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        guard let moviesInGenresManager = moviesInGenresManager else { return cell }
        let genre = moviesInGenresManager.getAvailibleGenres()[row]
        let movie = moviesInGenresManager.getGenreMovies(for: genre)[indexPath.item]
        cell.setupCell(with: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GenreTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 30) / 2
        return CGSize(width: size, height: size)
    }
}

// MARK: - UICollectionViewDelegate
extension GenreTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt?(row,indexPath.item)
    }
}
