//
//  MovieItemTableViewCell.swift
//  MyMovies
//
//  Created by Aleksandr on 14.05.2023.
//

import UIKit

class MovieItemTableViewCell: UITableViewCell {

    @IBOutlet var shadowView: UIView!
    @IBOutlet var clipsView: UIView!
    
    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var voteFieldWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsView.layer.cornerRadius = Config.movieListItemCornerRadius
        clipsView.backgroundColor = Config.movieListItemBGColor
        
        shadowView.layer.cornerRadius = Config.movieListItemCornerRadius
        shadowView.layer.borderWidth = 2
        shadowView.layer.borderColor = Config.movieListItemBGColor.cgColor
        shadowView.layer.shadowColor = Config.movieListItemShadowColor.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.4
        
    }

    
    func setMovie(_ movie: SMovie) {
        
        if let posterPath = movie.posterPath,
            let posterURL = URL(string: NetworkManager.main.getPosterUrlString(posterPath)) {

                self.posterImageView.sd_setImage(with: posterURL)
            }
        
        titleLabel.text = movie.originalTitle
        
        overviewLabel.text = movie.overview

        if let releaseDate = movie.releaseDate {
            let rdArray = releaseDate.components(separatedBy: "-")
            if rdArray.count == 3 {
                if let month = Config.monthes[rdArray[1]] {
                    releaseLabel.text = "\(month) \(rdArray[2]), \(rdArray[0])"
                }
            } else {
                releaseLabel.text = releaseDate
            }
        } else {
            releaseLabel.text = ""
        }

        if let vote = movie.voteAverage {
            voteFieldWidthConstraint.constant = 14.0*vote
        }
    }
    
}
