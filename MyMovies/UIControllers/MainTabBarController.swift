//
//  MainTabBarController.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit

class MainTabBarController: UITabBarController, MainControllerDelegate {

    static var delegate: MainControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MainTabBarController.delegate = self
    }
    
    func hideWithAnimate() {
        
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 800)
            self.view.alpha = 0.0
        } completion: { _ in
            self.view.removeFromSuperview()
        }
    }
}

protocol MainControllerDelegate {
    func hideWithAnimate()
}
