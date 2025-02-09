//
//  USession.swift
//  UmeroKit
//
//  Created by Rudrank Riyam on 19/03/23.
//

import Foundation

struct USession: Codable {
    let session: Session
    let error: Int?
    let message: String?
    
    struct Session: Codable {
        public let name, key: String
        public let subscriber: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case session
        case error
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.session = try container.decodeIfPresent(Session.self, forKey: .session) ?? Session(name: "", key: "", subscriber: 0)
        self.error = try container.decodeIfPresent(Int.self, forKey: .error)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
