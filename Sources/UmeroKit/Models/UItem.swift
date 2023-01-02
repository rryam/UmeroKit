//
//  UItem.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 02/01/23.
//

import Foundation

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
protocol UItem: Identifiable {
  var id: String { get }
  var url: URL { get }
}

extension UItem {
  public var id: String {
    url.absoluteString
  }
}
