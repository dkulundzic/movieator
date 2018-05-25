//
//  MovieDetailsViewController.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var metascoreRatingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MOVIE DETAILS"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))

        setupViews()
    }
    
    @objc func saveButtonTapped() {
        //save Movie
    }
    
    func setupViews() {
        titleLabel.text = movie.title
        imdbRatingLabel.text = "\(movie.imdbRating)"
        metascoreRatingLabel.text = "\(movie.metascore)"
        plotLabel.text = movie.plot
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        releasedLabel.text = dateFormatter.string(from: movie.releaseDate)
        genreLabel.text = movie.genre
        actorsLabel.text = movie.actors
        directorLabel.text = movie.director
        writerLabel.text = movie.writer
        
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: movie.poster,
           success: { data in
                let image = UIImage(data: data)
                self.posterImageView.image = image
            },
           failure: { error in
                print("Error getting poster, \(error)")
        })
    }
}
