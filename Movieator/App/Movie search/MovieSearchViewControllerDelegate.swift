//
//  MovieSearchViewControllerDelegate.swift
//  Movieator
//
//  Created by Matej Korman on 04/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

protocol MovieSearchViewControllerDelegate: class {
    func movieSearch(_ movieSearch: MovieSearchViewController, didSelectMovie movie: Movie, frame: CGRect)
}
