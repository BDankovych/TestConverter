//
//  OSStatus+Bool.swift
//  Test
//
//  Created by bdankovych on 11.10.2022.
//

import Foundation

extension OSStatus {
    @inlinable
    var isSuccess: Bool {
        self == noErr
    }
}
