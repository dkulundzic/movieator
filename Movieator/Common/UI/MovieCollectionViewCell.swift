//
//  MovieCollectionViewCell.swift
//  Movieator
//
//  Created by Matej Korman on 16/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit

class MovieCollectionViewCellSK: UICollectionViewCell {
    typealias ViewModel = (title: String?, year: String?, posterURL: String)
    
    private let stackView = UIStackView.autolayoutView()
    private let titleLabel = UILabel.autolayoutView()
    private let yearLabel = UILabel.autolayoutView()
    private let imageView = UIImageView.autolayoutView()
    private let imageOverlayView = UIView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieCollectionViewCellSK {    
    func setupCell(with movie: Movie) {
        titleLabel.text = movie.title
        let year = String(Calendar.current.component(.year, from: movie.releaseDate))
        yearLabel.text = year
        
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: movie.poster,
                                       success: { [weak self] data in
                                        let image = UIImage(data: data)
                                        self?.imageView.image = image
            },
                                       failure: { error in
                                        print("Error getting poster, \(error)")
        })
    }
}

private extension MovieCollectionViewCellSK {
    func setupViews() {
        setupImageView()
        setupImageViewOverlay()
        setupStackView()
        setupTitleLabel()
        setupYearLabel()
    }
    
    func setupStackView() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.snp.makeConstraints {
            $0.center.leading.trailing.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().inset(50)
            $0.bottom.lessThanOrEqualToSuperview().inset(50)
        }
    }
    
    func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
    }
    
    func setupYearLabel() {
        stackView.addArrangedSubview(yearLabel)
        yearLabel.font = .systemFont(ofSize: 17)
        yearLabel.textColor = .black
        yearLabel.textAlignment = .center
        yearLabel.numberOfLines = 0
        yearLabel.adjustsFontSizeToFitWidth = true
        yearLabel.minimumScaleFactor = 0.6
        yearLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setupImageView() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30.0
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupImageViewOverlay() {
        contentView.addSubview(imageOverlayView)
        imageOverlayView.backgroundColor = .white
        imageOverlayView.alpha = 0.45
        imageOverlayView.snp.makeConstraints {
            $0.width.height.equalTo(imageView)
            $0.center.equalTo(imageView)
        }
    }
}

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setupCell(with movie: Movie) {
        titleLabel.text = movie.title
        let year = String(Calendar.current.component(.year, from: movie.releaseDate))
        yearLabel.text = year
        imageView.layer.cornerRadius = 30.0
        imageView.clipsToBounds = true
        
        let posterFetcher = MoviePosterFetcher()
        posterFetcher.fetchMoviePoster(with: movie.poster,
            success: { [weak self] data in
                let image = UIImage(data: data)
                self?.imageView.image = image
        },
            failure: { error in
                print("Error getting poster, \(error)")
        })
    }
}
