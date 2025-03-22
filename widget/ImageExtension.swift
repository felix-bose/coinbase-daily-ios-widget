//
//  ImageExtension.swift
//  CoinbaseDaily
//
//  Created by Felix Bose on 22.02.25.
//

import SwiftUI

extension String {
    /// Returns decoded Data if the string is a valid base64-encoded image.
    var base64DecodedData: Data? {
        // Remove data URL prefix if present
        let prefix = "data:image/png;base64,"
        let base64String = self.hasPrefix(prefix) ? String(self.dropFirst(prefix.count)) : self
        return Data(base64Encoded: base64String)
    }
}
