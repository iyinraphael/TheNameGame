//
//  GameViewController.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import UIKit

class GameViewController: UIViewController, GameiSCorrectDelegate {
    // MARK: - Properties
    private let reuseIdentifier = "cell"
    var viewModel = GameViewModel()
    var attempCount = 0
    var scoreCount = 0
    var isCorrect: Bool?
    weak var delegate: PlayModeDelegate?
    
    
    // MARK: - Outlets
    var collectionView: UICollectionView!
    var fullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        fullNameLabel = UILabel()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 12, bottom: 24, right: 12)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        view.addSubview(fullNameLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.didFinishFetch = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.fullName.bind { [weak self] fullName in
            self?.fullNameLabel.text = fullName
        }
        
        
    }
    
}

    

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GameViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProfiles?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        let profile = viewModel.filteredProfiles?[indexPath.item]
        cell.profileImageView.image = viewModel.getImage(from: profile?.headshot.url)

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profile = viewModel.filteredProfiles?[indexPath.item]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell {
            gamePlayMode(profile, cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
    }
    
    
    
    // MARK: - Game Logic
    private func gamePlayMode(_ profile: Profile?, _ cell: ProfileCollectionViewCell) {
        attempCount += 1
        
        guard let profile = profile else { return }
        let guessName = "\(profile.firstName) \(profile.lastName)"

        switch delegate?.playmode {
        
        case .practiceMode:
            if fullNameLabel.text != guessName {
                isCorrect = false
                cell.profile = profile
                let alertController = UIAlertController(title: "Game Over",
                                                        message: "\(scoreCount)/\(attempCount)",
                                                        preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(action)
                present(alertController, animated: true)
                return
            }
            
            isCorrect = true
            cell.profile = profile
            scoreCount += 1
            viewModel.getRandomProfile()
            collectionView.reloadData()
            
        case .timedMode:
            if fullNameLabel.text != guessName {
                
            }
        default:
            fatalError()
        }

    }


}

     // MARK: - UICollectionViewDelegateFlowLayout
extension GameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 12
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
        let itemSize = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow

        return CGSize(width: itemSize, height: itemSize)
    }
}



