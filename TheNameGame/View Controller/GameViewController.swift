//
//  GameViewController.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Properties
    var firstImageView: UIImageView!
    var secondImageView: UIImageView!
    var thirdImageView: UIImageView!
    var fourthImageView: UIImageView!
    var fifthImageView: UIImageView!
    var sixthImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstImageView = UIImageView()
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.tag = 1
        
    }
    
    private func setUp(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

}
