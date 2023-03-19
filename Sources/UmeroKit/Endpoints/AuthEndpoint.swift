//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 08/03/23.
//

import Foundation

enum AuthEndpoint: String, UURLEndpoint {
  case getMobileSession

  var path: String {
    "auth." + rawValue.lowercased()
  }
}
