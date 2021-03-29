//
//  ProfileCollectionViewCell.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/18/21.
//

import UIKit

protocol GameiSCorrectDelegate: class {
    var isCorrect: Bool { get set}
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properites
    var profileImageView: UIImageView!
    var strikeLayer: CALayer!
    weak var delegate: GameiSCorrectDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        addSubview(profileImageView)
        sendSubviewToBack(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
