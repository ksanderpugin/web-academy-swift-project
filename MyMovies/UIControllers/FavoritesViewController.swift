//
//  ViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 04.05.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var movieFavoriteList: [Movie] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieFavoriteList = Movie.findAll()
        
        tableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
    
    
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieFavoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            
            //            cell.setMovie(self.movieList[indexPath.row])
            cell.setMovie(convertMovieToSMovie(movieFavoriteList[indexPath.row]))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        StackViewController.detailsDelegate?.showMovieDetails(movieId: movieFavoriteList[indexPath.row].getId())
    }
    
    private func convertMovieToSMovie(_ movie: Movie) -> SMovie {
        
        return SMovie(adult: nil, backdropPath: movie.backgropPath, genreIDS: nil, id: movie.getId(), originalLanguage: nil, originalTitle: movie.title, overview: movie.overview, popularity: nil, posterPath: movie.posterPath, releaseDate: movie.releaseDate, title: movie.title, video: !movie.key.isEmpty, voteAverage: movie.rating, voteCount: nil)
    }
}
