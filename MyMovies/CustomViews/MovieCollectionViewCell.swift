//
//  MovieCollectionViewCell.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var starsConstaint: NSLayoutConstraint!
    @IBOutlet var yellowStarsBackWidthConstrant: NSLayoutConstraint!
    
    @IBOutlet var shadowView: UIView!
    @IBOutlet weak var clipsView: UIView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    func setMovie(movie: DiscoverMovie) {
        
        if let posterPath = movie.posterPath,
            let posterURL = URL(string: NetworkManager.main.getPosterUrlString(posterPath)) {

                self.posterImageView.sd_setImage(with: posterURL)
            }

        titleLabel.text = movie.originalTitle

        if let releaseDate = movie.releaseDate {
            let rdArray = releaseDate.components(separatedBy: "-")
            if rdArray.count == 3 {
                if let month = Config.monthes[rdArray[1]] {
                    self.releaseLabel.text = "\(month) \(rdArray[2]), \(rdArray[0])"
                }
            } else {
                self.releaseLabel.text = releaseDate
            }
        } else {
            self.releaseLabel.text = ""
        }

        if let vote = movie.voteAverage {
            self.starsConstaint.constant = 14.0*vote
        }
    }
    
    
    private func configure() {
        
        clipsView.layer.cornerRadius = Config.movieListItemCornerRadius
        clipsView.backgroundColor = Config.movieListItemBGColor
        
        shadowView.layer.cornerRadius = Config.movieListItemCornerRadius
        shadowView.layer.borderWidth = 2
        shadowView.layer.borderColor = Config.movieListItemBGColor.cgColor
        shadowView.layer.shadowColor = Config.movieListItemShadowColor.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.4
        
        titleLabel.textColor = Config.movieListItemTitleColor
        releaseLabel.textColor = Config.moveiListItemRealeseDateColor
    }
}
