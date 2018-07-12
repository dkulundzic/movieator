//
//  MovieSearchView.swift
//  Movieator
//
//  Created by Matej Korman on 12/07/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit

class MovieSearchView: UIView {
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout).autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MovieSearchView {
    func setupViews() {
        addSubview(collectionView)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
