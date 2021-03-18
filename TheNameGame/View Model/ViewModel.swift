//
//  ViewModel.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import Foundation

class ViewModel {
    
    // MARK: - Properties
    var profiles: [Profile]?
    let network = Network()
    
    init() {
        getAllProfile()
    }
    
    func getAllProfile() {
        network.getProfiles { result in
            
            switch result {
            case .success(let profiles):
                self.profiles = profiles
            default:
                fatalError()
            }
        }
    }
    
}
