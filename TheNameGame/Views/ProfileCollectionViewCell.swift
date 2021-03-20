//
//  ProfileCollectionViewCell.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/18/21.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properites
    var profileImageView: UIImageView!
    
    var profile: Profile?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.widthAnchor.constraint(equalTo: widthAnchor),
            profileImageView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
