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
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButtonTitle = LocalizationString.getString(forKey: .save)
        let shareButtonTitle = LocalizationString.getString(forKey: .share)
        let saveButton = UIBarButtonItem(title: saveButtonTitle, style: .plain, target: self, action: #selector(saveButtonTapped))
        let shareButton = UIBarButtonItem(title: shareButtonTitle, style: .plain, target: self, action: #selector(shareButtonTapped))
        
        navigationItem.title = LocalizationString.getString(forKey: .movieDetails)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = [saveButton, shareButton]

        setupViews()
    }
    
    @objc func saveButtonTapped() {
        let savedMoviesManager = SavedMoviesManager()
        savedMoviesManager.saveUserMovie(withID: movie.imdbID)
        
        let alertTitle = LocalizationString.getString(forKey: .saveMovie)
        let alertMassage = LocalizationString.getString(forKey: .movieSaved)
        let confirmingActionTitle = LocalizationString.getString(forKey: .ok)

        let alert = UIAlertController(title: alertTitle, message: alertMassage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmingActionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        let url = getMovieURL()
        let activityMessage = LocalizationString.getString(forKey: .lookIveFoundACoolMovie)
        let activityViewController = UIActivityViewController(activityItems: [activityMessage, url], applicationActivities: nil)
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
        }
        present(activityViewController, animated: true, completion: nil)
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

private extension MovieDetailsViewController {
    func getMovieURL() -> URL {
        guard let url = URL(string: "https://www.imdb.com/title/\(movie.imdbID)") else {
            fatalError("Error creating url for this movie.")
        }
        return url
    }
}
