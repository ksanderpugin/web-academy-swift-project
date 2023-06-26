//
//  DetailsViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit
import youtube_ios_player_helper

class DetailsViewController: UIViewController {
    
    @IBOutlet var backgropImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var genresLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var playerView: YTPlayerView!
    
    private var movieSeted: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showWithAnimate()
    }
    
    func setMovie(movie: Movie) {
        
        let backgropURLString = NetworkManager.main.getBackgropUrlString(movie.backgropPath)
        if let backgropURL = URL(string: backgropURLString) {
            self.backgropImageView.sd_setImage(with: backgropURL)
        }
        
        self.titleLabel.text = movie.title
        
        self.overviewLabel.text = movie.overview
        
        self.genresLabel.text = movie.genres
        
        let rdArray = movie.releaseDate.components(separatedBy: "-")
        if rdArray.count == 3 {
            if let month = Config.monthes[rdArray[1]] {
                releaseLabel.text = "\(month) \(rdArray[2]), \(rdArray[0])"
            }
        } else {
            releaseLabel.text = movie.releaseDate
        }
        
        if (movie.key.isEmpty) {
            self.playerView.isHidden = true
        } else {
            self.playerView.isHidden = false
            self.playerView.load(withVideoId: movie.key)
        }
        
        self.movieSeted = movie
    }
    
    @IBAction func backButtonTouchAction(_ sender: Any) {
        
        hideWithAnimate()
    }
    
    @IBAction func favoriteButtonTouchAction(_ sender: Any) {
        
        self.movieSeted?.saveToFavorite()
        self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    @IBAction func accountButtonTouchAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: {_ in
            UserSecurity.main.deleteLoginAndPassword()
            self.hideWithAnimate()
            MainTabBarController.delegate?.hideWithAnimate()
            StackViewController.detailsDelegate?.reloadIfNeeded()
        })
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func showWithAnimate() {
        
        self.view.transform = CGAffineTransform(translationX: 400, y: 0)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideWithAnimate() {
        
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(translationX: 400, y: 0)
            self.view.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.view.removeFromSuperview()
        }
    }
}
