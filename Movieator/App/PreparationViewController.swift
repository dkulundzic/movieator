//
//  PreparationViewController.swift
//  Movieator
//
//  Created by Matej Korman on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation
//
//  PreparationViewController.swift
//  Movieator
//
//  Created by Matej Korman on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit

class PreparationViewController: UIViewController {
    
    var movieIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIds()
    }
    
    func getIds() {
        if let filePath = Bundle.main.path(forResource: "movie_ids", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                movieIDs = contents.components(separatedBy: .newlines)
                print(movieIDs)
            } catch {
                print("Contenst could not be loaded, \(error)")
            }
        } else {
            print("File not found.")
        }
    }
}
