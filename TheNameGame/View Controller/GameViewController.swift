//
//  GameViewController.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import UIKit

class GameViewController: UIViewController, GameiSCorrectDelegate {
    
    // MARK: - Outlets
    var collectionView: UICollectionView!
    var fullNameLabel: UILabel!
    var cellView: UIView!
    var alertController: UIAlertController!
    var progressCircularView: CircularProgressBar!
    var stackView: UIStackView!
    
    // MARK: - Properties
    private let reuseIdentifier = "cell"
    var viewModel = GameViewModel()
    var attempCount = 0
    var scoreCount = 0
    var isCorrect: Bool = false
    weak var delegate: PlayModeDelegate?
    var value: Double?
    let nameGame = NameGame()
    private let cache = Cache<String, UIImage>()
    private let photoQueue = OperationQueue()
    private var operations = [String: Operation]()
    
    lazy var horizontalConstraints: [NSLayoutConstraint] = [
        fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 96),
        fullNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 92),
        fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -600),
        
        collectionView.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor, constant: 86),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    
    lazy var verticalConstraints: [NSLayoutConstraint] = [
        fullNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
        fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        collectionView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    
    lazy var regularConstraint: [NSLayoutConstraint] = [
        fullNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
        fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        collectionView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 114),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -114),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -63)
    ]
    
    // MARK: - View Cycle
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
        fullNameLabel.adjustsFontSizeToFitWidth = true
        fullNameLabel.font = .boldSystemFont(ofSize: 32)
        fullNameLabel.numberOfLines = 2
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.didFinishFetch = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.fullName.bind { [weak self] fullName in
            DispatchQueue.main.async {
                self?.fullNameLabel.text = fullName
            }
        }
        
        if delegate?.playmode == .some(.timedMode) {
            view.addSubview(progressCircularView)
            NSLayoutConstraint.activate([
            progressCircularView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressCircularView.heightAnchor.constraint(equalToConstant: 30),
            progressCircularView.widthAnchor.constraint(equalToConstant: 30),
            ])
            progressCircularView.setProgress(to: 1, withAnimation: true) { [weak self] in
                guard let self = self else { return }
                if self.isViewLoaded {
                    self.gameOverAlertView(with: self.scoreCount, self.attempCount)
                }
                self.alertController.removeFromParent()
            }
        }
        displayTraitCollection()
    }

    
    // MARK: - UI and Contrainsts
    private func displayTraitCollection(){
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular{
            NSLayoutConstraint.deactivate(horizontalConstraints)
            NSLayoutConstraint.activate(verticalConstraints)
            collectionView.collectionViewLayout.invalidateLayout()
        }
        else if  traitCollection.verticalSizeClass == .compact && traitCollection.horizontalSizeClass == .compact {
            NSLayoutConstraint.deactivate(verticalConstraints)
            NSLayoutConstraint.activate(horizontalConstraints)
            collectionView.collectionViewLayout.invalidateLayout()
        }
        else if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
            NSLayoutConstraint.deactivate(horizontalConstraints)
            NSLayoutConstraint.deactivate(verticalConstraints)
            NSLayoutConstraint.activate(regularConstraint)
            collectionView.collectionViewLayout.invalidateLayout()
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        displayTraitCollection()
    }
}

    

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GameViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProfiles?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        
        loadImage(for: cell, with: indexPath)
        
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let profile = viewModel.filteredProfiles?[indexPath.item],
           let cell = collectionView.cellForItem(at: indexPath) as? ProfileCollectionViewCell,
           let name = fullNameLabel.text {
            cell.delegate = self
            nameGame.playGuess(for: profile, with: name, at: cell) { iscorrect in
                if iscorrect == false {
                    gameOverAlertView(with: nameGame.scoreCount, nameGame.attemptCount)
                }
                correctAnswerAlertView()
            }
        }
    }
}

     // MARK: - UICollectionViewDelegateFlowLayout
extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if  traitCollection.verticalSizeClass == .compact && traitCollection.horizontalSizeClass == .compact {
            let numberOfItemsPerRow: CGFloat = 3
            let spacing: CGFloat = 12
            let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
            let itemSize = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
            return CGSize(width: itemSize, height: itemSize)
        }
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 12
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
        let itemSize = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemSize, height: itemSize)
    }
}



//// MARK: - Game Logic
//extension GameViewController {
//
//    private func gamePlayMode(_ profile: Profile?, _ cell: ProfileCollectionViewCell) {
//        attempCount += 1
//        guard let profile = profile else { return }
//        let guessName = "\(profile.firstName) \(profile.lastName)"
//
//        switch delegate?.playmode {
//        case .practiceMode:
//            if fullNameLabel.text != guessName {
//                isCorrect = false
//                cell.profile = profile
//                gameOverAlertView(with: scoreCount, attempCount)
//                alertController.removeFromParent()
//                return
//            }
//            scoreCount += 1
//            isCorrect = true
//            cell.profile = profile
//            correctAnswerAlertView()
//            alertController.removeFromParent()
//        case .timedMode:
//            if fullNameLabel.text != guessName {
//                isCorrect = false
//                cell.profile = profile
//                return
//            }
//            scoreCount += 1
//            isCorrect = true
//            cell.profile = profile
//            correctAnswerAlertView()
//            alertController.removeFromParent()
//        default:
//            fatalError()
//        }
//    }
//}


    //MARK: - Load cell concurrently with cache

extension GameViewController {
    
    private func loadImage(for cell: ProfileCollectionViewCell, with indexPath: IndexPath) {
        guard let profile = viewModel.filteredProfiles?[indexPath.item],
        let imageString = profile.headshot.url else{ return}
        let profileId = profile.id
        
        if let cacheImage = cache.value(for: profileId) {
            DispatchQueue.main.async {
                cell.profileImageView.image = cacheImage
            }
        }
        
        let fetchOp = FetchImageOperation(imageString: "https:\(imageString)")
        
        let cacheOp = BlockOperation { [weak self] in
            if let image = fetchOp.image {
                self?.cache.cache(value: image, for: profileId)
            }
        }
        let completOp = BlockOperation { [weak self] in
            defer {self?.operations.removeValue(forKey: profileId)}
            
            if let currentIndexpath = self?.collectionView.indexPath(for: cell),
               currentIndexpath != indexPath { return }
            
            if let image = fetchOp.image {
                cell.profileImageView.image = image
            }
        }
        cacheOp.addDependency(fetchOp)
        completOp.addDependency(fetchOp)
        
        photoQueue.addOperation(fetchOp)
        photoQueue.addOperation(cacheOp)
        
        OperationQueue.main.addOperation(completOp)
        operations[profileId] = fetchOp
        
    }
}
