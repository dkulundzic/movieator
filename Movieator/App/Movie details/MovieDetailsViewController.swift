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
    @IBOutlet weak var contrubutorsLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    var movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
