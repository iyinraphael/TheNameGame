//
//  GameViewModel.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/18/21.
//

import UIKit.UIImage

class GameViewModel {
    
    // MARK: - Properties
    var fullName = BoxObservable(value: "")
    private var randomIndex = 0
    private let network = Network()
    private var allProfile = [Profile]()
    
    var filteredProfiles: [Profile]?{
        didSet{
            self.didFinishFetch?()
        }
    }
    // MARK: - Closures for callback
    var didFinishFetch: (() -> ())?
    
    
    init() {
        getAllProfile()
    }
    
    // MARK: - Methods
    private func getAllProfile() {
        
        network.getProfiles { result in
            switch result {
            case .success(let profiles):
                self.allProfile = profiles
                self.getRandomProfile()
            default:
                fatalError()
            }
        }
    }
    
    func getRandomProfile() {
        var tempProfiles = [Profile]()
        let profilesWithHeadshots = allProfile.filter{$0.headshot.url != nil}
        for _ in 0..<6 {
            if let profile = profilesWithHeadshots.randomElement() {
                tempProfiles.append(profile)
            }
        }
        filteredProfiles = tempProfiles
        guard let profiles = filteredProfiles else { return }
        randomIndex = Range(0...5).randomElement() ?? 0
        let name = profiles[randomIndex]
        self.fullName.value = "\(name.firstName) \(name.lastName)"
    }
    
    func getUrl(from imageString: String?) -> URL? {
        guard let imageWithString = imageString,
              let imageURL = URL(string: "https:\(imageWithString)")
        else { return nil}
        
        return imageURL
    }
    
}

