//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

public struct UImage: Codable {
  public let size: String
  public let url: URL

  enum CodingKeys: String, CodingKey {
    case size
    case url = "#text"
  }
}
