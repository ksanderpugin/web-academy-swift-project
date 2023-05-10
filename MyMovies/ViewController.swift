//
//  ViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 04.05.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userIsAuth = false
        
        if !userIsAuth {
            
            if let authVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
                
                self.addChild(authVC)
                authVC.view.frame = self.view.frame
                self.view.addSubview(authVC.view)
                
                authVC.didMove(toParent: self)
            }
        }
    }


}

