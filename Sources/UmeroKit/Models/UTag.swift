//
//  UTag.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

public struct UTag: Identifiable, Codable {
  public var id: String {
    name
  }

  public let name: String
  public let url: URL?
  public let count: Int?
  public let total: Int?
  public let reach: Int?
  public let wiki: UWiki?
}
