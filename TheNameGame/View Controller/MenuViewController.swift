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
    var backgroundImageView: UIImageView!
    var practiceModeButton: UIButton!
    var timedModeButton: UIButton!
    
    // MARK: - Properties
    var playmode = PlayMode.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.width
        let height = view.frame.height
        let radius: CGFloat = 14
        
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundImageView.image = UIImage(named: "Splash Screen")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Try matching the WillowTree employee to their photo"
        label.textColor = .white
        label.textAlignment = .center
        
        practiceModeButton = UIButton()
        practiceModeButton.translatesAutoresizingMaskIntoConstraints = false
        practiceModeButton.setTitle("Practice Mode", for: .normal)
        practiceModeButton.addTarget(self, action: #selector(playPracticeMode), for: .touchUpInside)
        practiceModeButton.titleLabel?.font = .systemFont(ofSize: 17)
        practiceModeButton.backgroundColor = Appearance.buttonColor
        practiceModeButton.layer.masksToBounds = true
        practiceModeButton.layer.cornerRadius = radius
        
        timedModeButton = UIButton()
        timedModeButton.translatesAutoresizingMaskIntoConstraints = false
        timedModeButton.setTitle("Timed Mode", for: .normal)
        timedModeButton.addTarget(self, action: #selector(playTimedMode), for: .touchUpInside)
        timedModeButton.titleLabel?.font = .systemFont(ofSize: 17)
        timedModeButton.backgroundColor = Appearance.buttonColor
        timedModeButton.layer.masksToBounds = true
        timedModeButton.layer.cornerRadius = radius
        
        view.addSubview(backgroundImageView)
        view.addSubview(label)
        view.addSubview(practiceModeButton)
        view.addSubview(timedModeButton)
        
        let space: CGFloat = 8
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 47),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -47),
            label.bottomAnchor.constraint(equalTo: practiceModeButton.topAnchor, constant: -space * 2),
            
            practiceModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
            practiceModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
            practiceModeButton.heightAnchor.constraint(equalToConstant: space * 7),
            
            timedModeButton.topAnchor.constraint(equalTo: practiceModeButton.bottomAnchor, constant: space),
            timedModeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space),
            timedModeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space),
            timedModeButton.heightAnchor.constraint(equalToConstant: space * 7),
            timedModeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -42)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = Appearance.backgroundColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Methods
    @objc func playPracticeMode() {
        let vc = GameViewController()
        vc.title = "Pratice Mode"
        vc.delegate = self
        playmode = .practiceMode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func playTimedMode() {
        let vc = GameViewController()
        vc.title = "Timed Mode"
        vc.delegate = self
        playmode = .timedMode
        navigationController?.pushViewController(vc, animated: true)
       
    }
    

}
