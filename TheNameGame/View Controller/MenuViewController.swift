//
//  MenuViewController.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import UIKit

protocol PlayModeDelegate: class {
    var playmode: PlayMode { get set }
}

enum PlayMode: String {
    case none, practiceMode, timedMode
}

class MenuViewController: UIViewController, PlayModeDelegate {

    // MARK: - Outlets
    private weak var portraitBackgroundImageView: UIImageView!
    private weak var landscapeBackgroundImageView: UIImageView!
    private weak var practiceModeButton: UIButton!
    private weak var timedModeButton: UIButton!
    private weak var instructionLabel: UILabel!
    
    // MARK: - Properties
    var playmode = PlayMode.none
    private let space: CGFloat = 8
    private let radius: CGFloat = 14
    
    lazy var verticalConstraints: [NSLayoutConstraint] = [
        portraitBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
        portraitBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        portraitBackgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        
        instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (space * 6) - 1),
        instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: (-space * 6) - 1),
        instructionLabel.bottomAnchor.constraint(equalTo: practiceModeButton.topAnchor, constant: -space * 2),
        
        practiceModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
        practiceModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
        practiceModeButton.heightAnchor.constraint(equalToConstant: space * 7),
        
        timedModeButton.topAnchor.constraint(equalTo: practiceModeButton.bottomAnchor, constant: space),
        timedModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
        timedModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
        timedModeButton.heightAnchor.constraint(equalToConstant: space * 7),
        timedModeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (-space * 5) - 2)
        
    ]
    
    lazy var horizontalConstraints: [NSLayoutConstraint] = [
        landscapeBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
        landscapeBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        landscapeBackgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        
        instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 424),
        instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -107),
        instructionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 104),
        
        practiceModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 389),
        practiceModeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 199),
        practiceModeButton.widthAnchor.constraint(equalToConstant: 359),
        practiceModeButton.heightAnchor.constraint(equalToConstant: 56),
        
        timedModeButton.leadingAnchor.constraint(equalTo: practiceModeButton.leadingAnchor),
        timedModeButton.topAnchor.constraint(equalTo: practiceModeButton.bottomAnchor, constant: space),
        timedModeButton.widthAnchor.constraint(equalTo: practiceModeButton.widthAnchor),
        timedModeButton.heightAnchor.constraint(equalTo: practiceModeButton.heightAnchor)
    ]
    
    lazy var regularConstraint: [NSLayoutConstraint] = [
        portraitBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
        portraitBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        portraitBackgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        
        instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        instructionLabel.widthAnchor.constraint(equalToConstant: 501),
        instructionLabel.bottomAnchor.constraint(equalTo: practiceModeButton.topAnchor, constant: -space * 7),
        practiceModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        practiceModeButton.widthAnchor.constraint(equalToConstant: 433),
        practiceModeButton.heightAnchor.constraint(equalToConstant: space * 7),
        
        timedModeButton.topAnchor.constraint(equalTo: practiceModeButton.bottomAnchor, constant: space),
        timedModeButton.leadingAnchor.constraint(equalTo: practiceModeButton.leadingAnchor),
        timedModeButton.trailingAnchor.constraint(equalTo: practiceModeButton.trailingAnchor),
        timedModeButton.heightAnchor.constraint(equalToConstant: space * 7),
        timedModeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -92)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let portraitBackgroundImageView = UIImageView()
        portraitBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        portraitBackgroundImageView.contentMode = .scaleAspectFill
        self.portraitBackgroundImageView = portraitBackgroundImageView
        
        let landscapeBackgroundImageView = UIImageView()
        landscapeBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.landscapeBackgroundImageView = landscapeBackgroundImageView
        
        let instructionLabel = UILabel()
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.numberOfLines = 0
        instructionLabel.text = "Try matching the WillowTree employee to their photo"
        instructionLabel.textColor = .white
        instructionLabel.font = .systemFont(ofSize: 17)
        instructionLabel.textAlignment = .center
        self.instructionLabel = instructionLabel
        
        let practiceModeButton = UIButton()
        practiceModeButton.translatesAutoresizingMaskIntoConstraints = false
        practiceModeButton.setTitle("Practice Mode", for: .normal)
        practiceModeButton.addTarget(self, action: #selector(playPracticeMode), for: .touchUpInside)
        practiceModeButton.titleLabel?.font = .systemFont(ofSize: 17)
        practiceModeButton.backgroundColor = Appearance.buttonColor
        practiceModeButton.layer.masksToBounds = true
        practiceModeButton.layer.cornerRadius = radius
        self.practiceModeButton = practiceModeButton
        
        let timedModeButton = UIButton()
        timedModeButton.translatesAutoresizingMaskIntoConstraints = false
        timedModeButton.setTitle("Timed Mode", for: .normal)
        timedModeButton.addTarget(self, action: #selector(playTimedMode), for: .touchUpInside)
        timedModeButton.titleLabel?.font = .systemFont(ofSize: 17)
        timedModeButton.backgroundColor = Appearance.buttonColor
        timedModeButton.layer.masksToBounds = true
        timedModeButton.layer.cornerRadius = radius
        self.timedModeButton = timedModeButton
        
        view.addSubview(portraitBackgroundImageView)
        view.addSubview(landscapeBackgroundImageView)
        view.addSubview(instructionLabel)
        view.addSubview(practiceModeButton)
        view.addSubview(timedModeButton)
        
        displayTraitCollection()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = Appearance.backgroundColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        displayTraitCollection()
    }
    
    
    private func displayTraitCollection(){
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular{
            landscapeBackgroundImageView.image = nil
            portraitBackgroundImageView.image = UIImage(named: "Splash Screen")
            
            NSLayoutConstraint.deactivate(horizontalConstraints)
            NSLayoutConstraint.activate(verticalConstraints)
        }
        else if  traitCollection.verticalSizeClass == .compact && traitCollection.horizontalSizeClass == .compact {
            portraitBackgroundImageView.image = nil
            landscapeBackgroundImageView.image = UIImage(named: "splashLandcape")
            
            NSLayoutConstraint.deactivate(verticalConstraints)
            NSLayoutConstraint.activate(horizontalConstraints)
        }
        else if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
            instructionLabel.font = nil
            instructionLabel.font =  .systemFont(ofSize: 34)
            instructionLabel.numberOfLines = 2
            landscapeBackgroundImageView.image = nil
            portraitBackgroundImageView.image = UIImage(named: "Splash Screen")
            
            NSLayoutConstraint.deactivate(horizontalConstraints)
            NSLayoutConstraint.deactivate(verticalConstraints)
            NSLayoutConstraint.activate(regularConstraint)
        }
    }
    
    
    // MARK: - Methods to select game state
    @objc func playPracticeMode() {
        let vc = GameViewController()
        vc.title = "Pratice Mode"
        vc.nameGame.delegate = self
        playmode = .practiceMode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func playTimedMode() {
        let vc = GameViewController()
        vc.title = "Timed Mode"
        vc.nameGame.delegate = self
        playmode = .timedMode
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
