//
//  Config.swift
//  MyMovies
//
//  Created by Aleksandr on 08.05.2023.
//

import UIKit

class Config {
    
    static let monthes = [
            "01": "January",
            "02": "February",
            "03": "March",
            "04": "April",
            "05": "May",
            "06": "June",
            "07": "July",
            "08": "August",
            "09": "September",
            "10": "October",
            "11": "November",
            "12": "December"]
    
    static let appBGColor = UIColor(red: 3/255, green: 37/255, blue: 65/255, alpha: 1)
    
    static let authWindowInputAndButtonCornerRadius: CGFloat = 24.0
    
    // MovieListItem styles
    static let movieListItemCornerRadius = 20.0
    static let movieListItemBGColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let movieListItemShadowColor = UIColor.white.withAlphaComponent(0.8)
    static let movieListItemTitleColor = UIColor.white
    static let moveiListItemRealeseDateColor = UIColor.white.withAlphaComponent(0.6)
}
