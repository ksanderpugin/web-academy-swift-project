//
//  NewRequestTokenRespond.swift
//  MyMovies
//
//  Created by Aleksandr on 09.05.2023.
//

import Foundation

struct NewRequestTokenRespond: Codable {
    let success: Bool?
    let expires_at: String?
    let request_token: String?
}
