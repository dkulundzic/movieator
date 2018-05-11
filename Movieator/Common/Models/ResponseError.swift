//
//  ResponseError.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 11/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

struct ResponseError: Codable, LocalizedError {
    let response: Bool
    let errorMessage: String
    
    var errorDescription: String? {
        return errorMessage
    }
    
    private enum CodingKeys: String, CodingKey {
        case response = "Response"
        case errorMessage = "Error"
    }
}
