//
//  MovieCollectionViewCell.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setupCell(with movie: Movie) {
        self.titleLabel.text = movie.title
        let year = String(Calendar.current.component(.year, from: movie.releaseDate))
        self.yearLabel.text = year
        self.imageView.layer.cornerRadius = 30.0
        self.imageView.clipsToBounds = true
        
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: movie.poster,
                                       success: { (data) in
                                        let image = UIImage(data: data)
                                        self.imageView.image = image
        },
                                       failure: { (error) in
                                        print("Error getting poster, \(error)")
        })
    }
}
