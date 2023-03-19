//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 19/03/23.
//

import Foundation

struct USession: Codable {
  let session: Session

  struct Session: Codable {
    let name, key: String
    let subscriber: Int
  }
}
