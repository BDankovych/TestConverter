//
//  Decodable+Decode.swift
//  Patterns
//
//  Created by Yurii Boiko on 4/3/19.
//  Copyright © 2019 Intuity. All rights reserved.
//

import Foundation

extension Decodable {
    static func decodeObject<T: Decodable>(_ type: T.Type, data: Data?) -> Result<T, Error> {
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            } catch let error {
                return .failure(error)
            }
        } else {
            return .failure(DefaultError.apiError(message: "Data is empty"))
        }
    }
}
