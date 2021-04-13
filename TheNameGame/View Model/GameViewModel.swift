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
    var collectionView: BoxObservable<UICollectionView?> = BoxObservable(value: nil)
    private var randomIndex = 0
    private let network = Network()
    private var allProfile = [Profile]()
    private let cache = Cache<String, UIImage>()
    private let photoQueue = OperationQueue()
    private var operations = [String: Operation]()
    
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
    
    //MARK: - Load cell concurrently with cache
    func loadImage(for cell: ProfileCollectionViewCell, with indexPath: IndexPath) {
        guard let profile = filteredProfiles?[indexPath.item],
        let imageString = profile.headshot.url else{ return}
        let profileId = profile.id
        
        if let cacheImage = cache.value(for: profileId) {
            DispatchQueue.main.async {
                cell.profileImageView.image = cacheImage
            }
        }
        
        let fetchOp = FetchImageOperation(imageString: "https:\(imageString)")
        
        let cacheOp = BlockOperation { [weak self] in
            if let image = fetchOp.image {
                self?.cache.cache(value: image, for: profileId)
            }
        }
        let completOp = BlockOperation { [weak self] in
            defer {self?.operations.removeValue(forKey: profileId)}
            
            if let currentIndexpath = self?.collectionView.value?.indexPath(for: cell),
               currentIndexpath != indexPath { return }
            
            if let image = fetchOp.image {
                cell.profileImageView.image = image
            }
        }
        cacheOp.addDependency(fetchOp)
        completOp.addDependency(fetchOp)
        
        photoQueue.addOperation(fetchOp)
        photoQueue.addOperation(cacheOp)
        
        OperationQueue.main.addOperation(completOp)
        operations[profileId] = fetchOp
        
    }
}

