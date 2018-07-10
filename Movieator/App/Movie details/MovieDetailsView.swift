//
//  MovieDetailsView.swift
//  Movieator
//
//  Created by Matej Korman on 21/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit

class MovieDetailsView: UIView {
    private let imageView = UIImageView.autolayoutView()
    private let scrollView = UIScrollView.autolayoutView()
    private let scrollContentView = UIView.autolayoutView()
    private let detailsStackView = UIStackView.autolayoutView()
    private let titleLabel = UILabel.autolayoutView()
    private let ratingsStackView = UIStackView.autolayoutView()
    private let imdbRatingView = MovieDetailsPropertyView.autolayoutView()
    private let metascoreRatingView = MovieDetailsPropertyView.autolayoutView()
    private let plotView = MovieDetailsPropertyView.autolayoutView()
    private let releasedView = MovieDetailsPropertyView.autolayoutView()
    private let genreView = MovieDetailsPropertyView.autolayoutView()
    private let actorsView = MovieDetailsPropertyView.autolayoutView()
    private let directorView = MovieDetailsPropertyView.autolayoutView()
    private let writerView = MovieDetailsPropertyView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailsView {
    func setupDetails(withMovie movie: Movie) {
        setupViews()
        titleLabel.text = movie.title
        imdbRatingView.setProperties(title: "IMDB: ", body: "\(movie.imdbRating)")
        metascoreRatingView.setProperties(title: "Metascore: ", body: "\(movie.metascore)")
        plotView.setProperties(title: "Plot: ", body: movie.plot)
        dateFormatter.dateStyle = .medium
        releasedView.setProperties(title: "Released: ", body: dateFormatter.string(from: movie.releaseDate))
        genreView.setProperties(title: "Genre: ", body: movie.genre)
        actorsView.setProperties(title: "Actors: ", body: movie.actors)
        directorView.setProperties(title: "Director: ", body: movie.director)
        writerView.setProperties(title: "Writer: ", body: movie.writer)
        
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: movie.poster,
            success: { data in
                let image = UIImage(data: data)
                self.imageView.image = image
            },
            failure: { error in
                print("Error getting poster, \(error)")
        })
    }
}

private extension MovieDetailsView {
    func setupViews() {
        setupImageView()
        setupScrollView()
        setupScrollContentView()
        setupDetailsStackView()
        setupTitleLabel()
        setupRatingsStackView()
        setupImdbRatingView()
        setupMetascoreRatingView()
        setupPlotView()
        setupReleasedView()
        setupGenreView()
        setupActorsView()
        setupDirectorView()
        setupWriterView()
    }
    
    func setupImageView() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func setupScrollContentView() {
        scrollView.addSubview(scrollContentView)
        scrollContentView.backgroundColor = .white
        scrollContentView.alpha = 0.6
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self.snp.width)
        }
    }
    
    func setupDetailsStackView() {
        scrollContentView.addSubview(detailsStackView)
        detailsStackView.axis = .vertical
        detailsStackView.alignment = .fill
        detailsStackView.distribution = .fill
        detailsStackView.spacing = 10
        detailsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        let titleView = UIView.autolayoutView()
        detailsStackView.addArrangedSubview(titleView)
        titleView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func setupRatingsStackView() {
        detailsStackView.addArrangedSubview(ratingsStackView)
        ratingsStackView.axis = .horizontal
        ratingsStackView.alignment = .fill
        ratingsStackView.distribution = .fillEqually
        ratingsStackView.spacing = 10
    }
    
    func setupImdbRatingView() {
        ratingsStackView.addArrangedSubview(imdbRatingView)
    }
    
    func setupMetascoreRatingView() {
        ratingsStackView.addArrangedSubview(metascoreRatingView)
    }
    
    func setupPlotView() {
        detailsStackView.addArrangedSubview(plotView)
    }
    
    func setupReleasedView() {
        detailsStackView.addArrangedSubview(releasedView)
    }
    
    func setupGenreView() {
        detailsStackView.addArrangedSubview(genreView)
    }
    
    func setupActorsView() {
        detailsStackView.addArrangedSubview(actorsView)
    }
    
    func setupDirectorView() {
        detailsStackView.addArrangedSubview(directorView)
    }
    
    func setupWriterView() {
        detailsStackView.addArrangedSubview(writerView)
    }
}
