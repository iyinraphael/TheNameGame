//
//  AppCoordinator.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import UIKit

class AppCoordinator {
    
    func beginAppFlow() -> UIViewController {
        let menuVC = MenuViewController()
        let navController = UINavigationController()
        navController.viewControllers = [menuVC]
        
        return navController
        
        
    }
}
