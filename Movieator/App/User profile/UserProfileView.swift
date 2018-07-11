//
//  UserProfileView.swift
//  Movieator
//
//  Created by Matej Korman on 11/07/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit

class UserProfileView: UIView {
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout).autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellSize = (frame.size.width - 30) / 2
        collectionView.snp.updateConstraints {
            $0.height.equalTo(cellSize + 20)
        }
    }
}

// MARK: - Public Methods Extension
private extension UserProfileView {
    func setupViews() {
        addSubview(collectionView)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(375)
        }
    }
}
