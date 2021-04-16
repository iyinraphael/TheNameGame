//
//  MenuViewModel.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 4/15/21.
//

import Foundation

enum GameMode: Int {
    case practiceMode, timeMode
}

class MenuViewModel {
    
    // MARK: - Property
    private(set) lazy var currentGameMode = loadGameMode()
    private let gameDefault = UserDefaults.standard
    private let gameDefaultKey = "gameMode"
    
    // MARK: - Methods
    func changeGameMode(to mode: GameMode) {
        currentGameMode = mode
        gameDefault.setValue(mode.rawValue, forKey: gameDefaultKey)
        print(mode.rawValue)
    }
    
    private func loadGameMode() -> GameMode {
        let rawValue = gameDefault.integer(forKey: gameDefaultKey)
        return GameMode(rawValue: rawValue) ?? .practiceMode
    }
}
