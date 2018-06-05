//
//  EnumCollection-Movieator.swift
//  Movieator
//
//  Created by Matej Korman on 04/06/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import Foundation

protocol EnumCollection: Hashable {}

extension EnumCollection {
    static var cases: AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var index = 0
            return AnyIterator {
                let next = withUnsafeBytes(of: &index) { $0.load(as: Self.self) }
                if next.hashValue != index { return nil }
                index += 1
                return next
            }
        }
    }
}
