//
//  ViewModel.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import Foundation

class MenuViewModel {
    
    // MARK: - Properties
    var profiles = [Profile]()
    private let network = Network()
    
    init() {
        getAllProfile()
    }
    
    private func getAllProfile() {
        
        network.getProfiles { result in
            switch result {
            case .success(let profiles):
                self.getRandom(profiles: profiles)
            default:
                fatalError()
            }
        }
    }
    
    private func getRandom(profiles: [Profile]) {
        let profilesWithHeadshots = profiles.filter{$0.headshot.url != nil}
        
        for _ in 0..<6 {
            if let profile = profilesWithHeadshots.randomElement() {
                self.profiles.append(profile)
            }
        }

    }
        
    
}
