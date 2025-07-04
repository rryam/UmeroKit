//
//  MD5Helper.swift
//  UmeroKit
//
//  Created by Assistant on 2025-07-04.
//

import Foundation
import CryptoKit

/// MD5 hashing utility for Last.fm API compatibility
/// 
/// Note: MD5 is cryptographically broken and should not be used for security purposes.
/// However, Last.fm API requires MD5 for API signature generation as per their
/// authentication specification. This implementation is solely for API compatibility.
enum MD5Helper {
    /// Generates MD5 hash for Last.fm API signature
    /// - Parameter string: The string to hash
    /// - Returns: Hexadecimal string representation of the MD5 hash
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static func hash(_ string: String) -> String {
        let data = Data(string.utf8)
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}