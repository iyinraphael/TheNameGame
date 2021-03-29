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
    let strikeLayer = CALayer()
    weak var delegate: GameiSCorrectDelegate?
    
    var profile: Profile? {
        didSet {
            self.addSubLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.widthAnchor.constraint(equalTo: widthAnchor),
            profileImageView.heightAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        strikeLayer.removeFromSuperlayer()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubLayer() {
        let checkImage = UIImage(named: "checkMark")?.cgImage
        let strikeImage = UIImage(named: "strikeMark")?.cgImage
        
        strikeLayer.frame = contentView.bounds
        strikeLayer.contentsGravity = .center
        strikeLayer.contents = delegate?.isCorrect == true ? checkImage : strikeImage
        strikeLayer.backgroundColor = delegate?.isCorrect == true ? Appearance.checkColor : Appearance.strikeColor

        layer.addSublayer(strikeLayer)
    }
}
