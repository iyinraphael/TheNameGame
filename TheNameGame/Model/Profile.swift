//
//  Profile.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import Foundation

struct Profile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let headshot: HeadShot
    
    struct HeadShot: Codable {
        let url: String?
    }
}
