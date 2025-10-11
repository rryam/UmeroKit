//
//  UItem.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 02/01/23.
//

import Foundation

protocol UItem: Identifiable {
  var id: String { get }
  var url: URL { get }
}

extension UItem {
  public var id: String {
    url.absoluteString
  }
}
