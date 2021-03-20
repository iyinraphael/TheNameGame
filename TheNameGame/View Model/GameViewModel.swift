//
//  GameViewModel.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/18/21.
//

import UIKit.UIImage

class GameViewModel {
    
    // MARK: - Properties
    var fullName = BoxObservable(value: " ")
    var randomIndex = 0
    private let network = Network()
    var filteredProfiles: [Profile]?{
        didSet{
            self.didFinishFetch?()
            self.setUpName()
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
                self.getRandom(profiles: profiles)
            default:
                fatalError()
            }
        }
    }
    
    private func getRandom(profiles: [Profile]) {
        var allProfiles = [Profile]()
        let profilesWithHeadshots = profiles.filter{$0.headshot.url != nil}
       
        for _ in 0..<6 {
            if let profile = profilesWithHeadshots.randomElement() {
                allProfiles.append(profile)
            }
        }
        filteredProfiles = allProfiles
    }
    
    func getImage(from imageString: String?) -> UIImage {
        guard let imageWithString = imageString,
              let imageURL = URL(string: "https:\(imageWithString)"),
              let data = try? Data(contentsOf: imageURL),
              let image = UIImage(data: data) else
        { return UIImage()}
        
        return image
    }
    
    func setUpName() {
        guard let profiles = filteredProfiles else { return }
        randomIndex = Range(0...5).randomElement() ?? 0
        let name = profiles[randomIndex]
        self.fullName.value = "\(name.firstName) \(name.lastName)"
    }

    
}
