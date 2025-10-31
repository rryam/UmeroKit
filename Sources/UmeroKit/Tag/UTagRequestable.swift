//
//  UTagRequestable.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 27/12/22.
//

import Foundation

/// Defines the property that an object must implement in order to request data for a tag.
protocol UTagRequestable {

  /// The attributes of the tag request.
  var attributes: UTagAttributes { get }
}

