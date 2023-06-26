//
//  StrartViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit

class StackViewController: UIViewController {
    
    static var detailsDelegate: ShowMovieDetails?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        StackViewController.detailsDelegate = self
        
        let userIsAuth = UserSecurity.main.isSaved()
        
        if userIsAuth {
            self.showMainController()
        } else {
            self.showAuthController()
        }
    }
    
    
    
    private func showAuthController() {
        
        if let authVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
            
            self.addChild(authVC)
            authVC.view.frame = self.view.bounds
            authVC.delegate = self
            self.view.addSubview(authVC.view)
            
            authVC.didMove(toParent: self)
        }
    }
    
    private func showMainController() {
        
        if let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            
            self.addChild(mainVC)
            mainVC.view.frame = self.view.bounds
            self.view.addSubview(mainVC.view)
            
            mainVC.didMove(toParent: self)
        }
    }
    
    private func pushDetailsViewController(_ movie: Movie) {
        
        if let detailsVC = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            
            self.addChild(detailsVC)
            detailsVC.view.frame = self.view.bounds
            self.view.addSubview(detailsVC.view)
            
            detailsVC.didMove(toParent: self)
            
            detailsVC.setMovie(movie: movie)
        }
    }
}

extension StackViewController: AuthCompleted {
    
    func showWindowForAuthUser() {
        
        self.showMainController()
    }
}


extension StackViewController: ShowMovieDetails {
    
    func showMovieDetails(movieId: Int) {
        
        print("get details by id: \(movieId)")
        
        if let movie = Movie.findById(movieId) {
            self.pushDetailsViewController(movie)
            return
        }
        
        NetworkManager.main.loadMovieDetails(movieId: movieId) { movie in
            
            self.pushDetailsViewController(movie)
        } onError: { error in
            
            Toast.show(message: error.description, viewControler: self, duration: 4)
        }

    }
    
    func reloadIfNeeded() {
        self.viewWillAppear(true)
    }
}
