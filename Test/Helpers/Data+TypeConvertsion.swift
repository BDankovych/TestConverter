//
//  Data+Int.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

extension Data {
    var intValue: Int {
        self.withUnsafeBytes { $0.load(as: Int.self) }
    }
    
    var doubleValue: Double {
        self.withUnsafeBytes { $0.load(as: Double.self) }
    }
}

extension Double {
    var data: Data {
        mutating get {
            Data(bytes: &self, count: MemoryLayout.size(ofValue: self))
        }
    }
}

extension Int {
    var data: Data {
        mutating get {
            Data(bytes: &self, count: MemoryLayout.size(ofValue: self))
        }
    }
}
