//
//  MovieListViewController.swift
//  Movieator
//
//  Created by Matej Korman on 15/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    let reuseIdentifier = "cell"
    var titles = ["Movie1", "Movie2", "Movie3", "Movie4", "Movie5", "Movie6", "Movie7", "Movie8"]
    var years = ["2002", "2015", "2016", "1986", "1997", "2006", "2011", "2008"]

    override func viewDidLoad() {
        navigationItem.backBarButtonItem = nil
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = self.titles[indexPath.item]
        cell.yearLabel.text = self.years[indexPath.item]
        cell.backgroundColor = UIColor.cyan
        
        return cell
    }
    
    
}

extension MovieListViewController: UICollectionViewDelegate {
    
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width - 30) / 2, height: (self.view.frame.size.width - 30) / 2)
    }
}
