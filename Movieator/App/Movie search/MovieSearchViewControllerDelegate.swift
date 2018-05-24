//
//  MovieSearchViewControllerDelegate.swift
//  Movieator
//
//  Created by Matej Korman on 23/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

protocol MovieSearchViewControllerDelegate: class {
    func movieSearch(_ movieSearch: MovieSearchViewController, didSelectMovie movie: Movie)
}
