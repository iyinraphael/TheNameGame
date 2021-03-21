//
//  ProfileCollectionViewCell.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/18/21.
//

import UIKit

protocol GameiSCorrectDelegate: class {
    var isCorrect: Bool? { get set}
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properites
    var profileImageView: UIImageView!
    var strikeLayer: CALayer!
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
    
    func addSubLayer() {
        strikeLayer = CALayer()
        strikeLayer.frame = contentView.bounds
        strikeLayer.contentsGravity = .center

        strikeLayer.contents = delegate?.isCorrect == true ?
                                UIImage(named: "checkMark")?.cgImage :
            UIImage(named: "strikeMark")?.cgImage
        strikeLayer.backgroundColor = delegate?.isCorrect == true ?
                                    Appearance.checkColor :
                                    Appearance.strikeColor

        layer.addSublayer(strikeLayer)
    }
}
