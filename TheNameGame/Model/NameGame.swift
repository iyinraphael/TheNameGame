//
//  NameGame.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 4/13/21.
//

import UIKit

class NameGame: GameiSCorrectDelegate {
    
    // MARK: - Property
    var attemptCount = 0
    var scoreCount = 0
    var isCorrect: Bool = false
    weak var delegate: PlayModeDelegate?
    
    // MARK: - Game logic method
    func playGuess(for profile: Profile, with name: String, at cell: ProfileCollectionViewCell,
                   show alert: (Bool) -> ()) {
        let guessName = "\(profile.firstName) \(profile.lastName)"
        cell.delegate = self
        attemptCount += 1
        
        switch delegate?.playmode {
        case .practiceMode:
            if name != guessName {
                isCorrect = false
                cell.profile = profile
                alert(isCorrect)
                return
            }
            scoreCount += 1
            isCorrect = true
            cell.profile = profile
            alert(isCorrect)
        case .timedMode:
            if name != guessName {
                isCorrect = false
                cell.profile = profile
                return
            }
            scoreCount += 1
            isCorrect = true
            cell.profile = profile
            alert(isCorrect)
        default:
            fatalError()
        }
        
    }
}
