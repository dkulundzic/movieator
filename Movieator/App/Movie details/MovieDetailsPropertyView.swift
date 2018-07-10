//
//  MovieDetailsPropertyView.swift
//  Movieator
//
//  Created by Matej Korman on 10/07/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit

class MovieDetailsPropertyView: UIView {
    private let titleLabel = UILabel.autolayoutView()
    private let bodyLabel = UILabel.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailsPropertyView {
    func setProperties(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}

private extension MovieDetailsPropertyView {
    func setupViews() {
        setupTitleLabel()
        setupBodyLabel()
    }
    
    func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func setupBodyLabel() {
        self.addSubview(bodyLabel)
        bodyLabel.font = .systemFont(ofSize: 17)
        bodyLabel.textColor = .black
        bodyLabel.textAlignment = .left
        bodyLabel.numberOfLines = 0
        bodyLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}
