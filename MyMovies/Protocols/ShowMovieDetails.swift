//
//  ShowMovieDetails.swift
//  MyMovies
//
//  Created by Aleksandr on 14.05.2023.
//

import Foundation

protocol ShowMovieDetails {
    func showMovieDetails(movieId: Int)
    func reloadIfNeeded()
}
