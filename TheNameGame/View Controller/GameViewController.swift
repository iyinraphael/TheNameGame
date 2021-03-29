//
//  GameViewController.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import UIKit
import Kingfisher

class GameViewController: UIViewController, GameiSCorrectDelegate {
    // MARK: - Properties
    private let reuseIdentifier = "cell"
    var viewModel = GameViewModel()
    var attempCount = 0
    var scoreCount = 0
    var isCorrect: Bool = false
    weak var delegate: PlayModeDelegate?
    var value: Double?
    
    
    // MARK: - Outlets
    var collectionView: UICollectionView!
    var fullNameLabel: UILabel!
    var cellView: UIView!
    var alertController: UIAlertController!
    var progressCircularView: CircularProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressCircularView = CircularProgressBar()
        progressCircularView.translatesAutoresizingMaskIntoConstraints = false
        progressCircularView.labelSize = 10
        progressCircularView.lineWidth = 2
        
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.rightBarButtonItem?.customView = progressCircularView
        
        cellView = UIView()
        cellView.contentMode = .center
        
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
        view.addSubview(progressCircularView)
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressCircularView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressCircularView.heightAnchor.constraint(equalToConstant: 30),
            progressCircularView.widthAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.didFinishFetch = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.fullName.bind { [weak self] fullName in
            self?.fullNameLabel.text = fullName
        }
        
        if delegate?.playmode == .some(.timedMode) {
            progressCircularView.setProgress(to: 1, withAnimation: true) {
                self.gameOverAlertView(with: self.scoreCount, self.attempCount)
                self.alertController.removeFromParent()
            }
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
        let url = viewModel.getUrl(from: profile?.headshot.url)
        cell.profileImageView.kf.setImage(with: url)
        
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let profile = viewModel.filteredProfiles?[indexPath.item]
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell {
            cell.delegate = self
            gamePlayMode(profile, cell)
        }
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
                
                gameOverAlertView(with: scoreCount, attempCount)
                alertController.removeFromParent()
            }
            scoreCount += 1
            isCorrect = true
            cell.profile = profile
            
            correctAnswerAlertView()
            alertController.removeFromParent()
        
        case .timedMode:
            if fullNameLabel.text != guessName {
                isCorrect = false
                cell.profile = profile
                return
            }
            scoreCount += 1
            isCorrect = true
            cell.profile = profile
            
            correctAnswerAlertView()
            alertController.removeFromParent()
       
        default:
            fatalError()
        }
        
    }

    
    private func gameOverAlertView(with score: Int, _ count: Int) {
        let message = "\(score)/\(count)"
        
        alertController = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func correctAnswerAlertView() {
        alertController = UIAlertController(title: "Correct", message:"Keep going!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
            self?.viewModel.getRandomProfile()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
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
