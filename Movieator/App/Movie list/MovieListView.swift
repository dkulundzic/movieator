//
//  MovieListView.swift
//  Movieator
//
//  Created by Matej Korman on 12/07/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import SnapKit

class MovieListView: UIView {
    let tableView = UITableView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension MovieListView {
    func setupViews() {
        addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.register(GenreTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
