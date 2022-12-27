//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// An object that represents a musicbrainz unique identifier for a last.fm music item.
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public struct UItemID: Equatable, Hashable, Sendable, RawRepresentable, ExpressibleByStringLiteral {

  /// Creates a musicbrainz identifier with a string.
  public init(_ rawValue: String) {
    self.rawValue = rawValue
  }

  /// Creates a new instance with the specified raw value.
  ///
  /// If there is no value of the type that corresponds with the specified raw
  /// value, this initializer returns `nil`. For example:
  ///
  ///     enum PaperSize: String {
  ///         case A4, A5, Letter, Legal
  ///     }
  ///
  ///     print(PaperSize(rawValue: "Legal"))
  ///     // Prints "Optional("PaperSize.Legal")"
  ///
  ///     print(PaperSize(rawValue: "Tabloid"))
  ///     // Prints "nil"
  ///
  /// - Parameter rawValue: The raw value to use for the new instance.
  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter value: The value of the new instance.
  public init(stringLiteral value: String) {
    self.rawValue = value
  }

  /// The corresponding value of the raw type.
  ///
  /// A new instance initialized with `rawValue` will be equivalent to this
  /// instance. For example:
  ///
  ///     enum PaperSize: String {
  ///         case A4, A5, Letter, Legal
  ///     }
  ///
  ///     let selectedSize = PaperSize.Letter
  ///     print(selectedSize.rawValue)
  ///     // Prints "Letter"
  ///
  ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
  ///     // Prints "true"
  public let rawValue: String

  /// A type that represents an extended grapheme cluster literal.
  ///
  /// Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`,
  /// `String`, and `StaticString`.
  public typealias ExtendedGraphemeClusterLiteralType = String

  /// The raw type that can be used to represent all values of the conforming
  /// type.
  ///
  /// Every distinct value of the conforming type has a corresponding unique
  /// value of the `RawValue` type, but there may be values of the `RawValue`
  /// type that don't have a corresponding value of the conforming type.
  public typealias RawValue = String

  /// A type that represents a string literal.
  ///
  /// Valid types for `StringLiteralType` are `String` and `StaticString`.
  public typealias StringLiteralType = String

  /// A type that represents a Unicode scalar literal.
  ///
  /// Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`,
  /// `Character`, `String`, and `StaticString`.
  public typealias UnicodeScalarLiteralType = String
}

extension UItemID: Codable {
  enum CodingKeys: CodingKey {
    case mbid
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.rawValue = try container.decode(StringLiteralType.self, forKey: .mbid)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(rawValue, forKey: .mbid)
  }
}
