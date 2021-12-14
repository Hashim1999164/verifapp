//
//  KeychainManager.swift
//  VerifApp-UI
//
//  Created by Hashim Khan on 28/10/2021.
//

import Security
import UIKit

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
