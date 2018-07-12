//
//  PreparationView.swift
//  Movieator
//
//  Created by Matej Korman on 12/07/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class PreparationView: UIView {
    private let titleLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension PreparationView {
    func setupViews() {
        setupActivityIndicator()
        setupTitleLabel()
    }
    
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = LocalizationKey.Preparation.title.localized()
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 35)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicator.snp.bottom)
        }
    }
}
