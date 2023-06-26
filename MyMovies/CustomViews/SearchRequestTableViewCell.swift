//
//  SearchRequestTableViewCell.swift
//  MyMovies
//
//  Created by Aleksandr on 14.05.2023.
//

import UIKit

class SearchRequestTableViewCell: UITableViewCell {

    @IBOutlet var wrapperView: UIView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wrapperView.layer.borderWidth = 1
        wrapperView.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        wrapperView.layer.cornerRadius = 16
    }
}
