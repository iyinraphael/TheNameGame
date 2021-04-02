//
//  FetchImageOperation.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 4/2/21.
//

import UIKit

class FetchImageOperation: ConcurrentOperation {
    
    // MARK: - Properties
    let imageString: String
    private(set) var image: UIImage?
    
    init(imageString: String) {
        self.imageString = imageString
    }
    
    // MARK: - Methods
    override func start() {
        state = .isExecuting
        defer { self.state = .isFinished}
        if self.isCancelled { return }
        
        guard let imageURL = URL(string: imageString) else { return }
        let data = try? Data(contentsOf: imageURL)
        
        
        if let data = data {
            self.image = UIImage(data: data)
        }
    }
    
    override func cancel() {
        super.cancel()
    }
}
