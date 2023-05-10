//
//  Config.swift
//  MyMovies
//
//  Created by Aleksandr on 08.05.2023.
//

import Foundation

class Config {
    
    public static let authWindowInputAndButtonCornerRadius: CGFloat = 24.0
    
    // themoviedb.org config
    public static let theMovieDBAPIKey = "0053f5cc922062c130bbb83d4f264ac0"
    public static let theMovieDBAPIUrlString = "https://api.themoviedb.org/3/"
    public static let theMovieDBCreateRequestTokenCommand = "authentication/token/new"
    public static let theMovieDBValidateLoginAndPassword = "authentication/token/validate_with_login"
    public static let theMovieDBCreateNewSessionCommand = "authentication/session/new"
}
