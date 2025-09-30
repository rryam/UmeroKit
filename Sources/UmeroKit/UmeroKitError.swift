//
//  UmeroKitError.swift
//  UmeroKit
//
//  Created by Assistant on 2025-09-30.
//

import Foundation

/// Errors that can occur when using UmeroKit
public enum UmeroKitError: LocalizedError {
    /// API key has not been configured
    case missingAPIKey

    /// Shared secret has not been configured
    case missingSecret

    /// Username has not been provided
    case missingUsername

    /// Password has not been provided
    case missingPassword

    /// Invalid data format received from API
    case invalidDataFormat(String)

    /// Authentication failed with Last.fm
    case authenticationFailed(code: Int, message: String)

    /// Network request failed
    case networkError(URLError)

    /// JSON decoding failed
    case decodingError(DecodingError)

    /// Invalid URL construction
    case invalidURL

    /// API returned an error
    case apiError(code: Int, message: String)

    public var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key must be configured using UmeroKit.configure(withAPIKey:sharedSecret:)"
        case .missingSecret:
            return "Shared secret must be configured using UmeroKit.configure(withAPIKey:sharedSecret:)"
        case .missingUsername:
            return "Username must be provided using UmeroKit.configureUser(username:password:)"
        case .missingPassword:
            return "Password must be provided using UmeroKit.configureUser(username:password:)"
        case .invalidDataFormat(let details):
            return "Invalid data format: \(details)"
        case .authenticationFailed(let code, let message):
            return "Authentication failed (code \(code)): \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidURL:
            return "Failed to construct valid URL"
        case .apiError(let code, let message):
            return "API error (code \(code)): \(message)"
        }
    }
}