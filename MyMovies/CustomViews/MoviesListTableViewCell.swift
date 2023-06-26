//
//  MoviesListTableViewCell.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit
import SkeletonView

class MoviesListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet var loadView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        moviesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        genreLabel.isSkeletonable = true
        loadView.isSkeletonable = true
    }
    
    func setGenre(genre: Genre) {
        
        genreLabel.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        
        self.genre = genre
        movieList = []
        page = 1
        loadInProcess = false
        
        self.genreLabel.text = genre.name
        self.moviesCollectionView.reloadData()
        
        loadMovies()
    }
    
    func setLoadStyle() {
        genreLabel.showAnimatedGradientSkeleton()
        loadView.showAnimatedGradientSkeleton()
    }
    
    // MARK: private
    private var genre: Genre?
    private var movieList: [DiscoverMovie] = []
    private var page = 1
    private var loadInProcess = false
    
    private func loadMovies() {
        
        if self.loadInProcess { return }
        
        guard let genreId = self.genre?.id else { return }
        
        self.loadInProcess = true
        NetworkManager.main.loadMoviesListByGenreId(genreId: genreId, page: self.page) { movieList in
            
            self.loadView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.loadView.isHidden = true
            
            self.movieList.append(contentsOf: movieList)
            self.page += 1
            self.moviesCollectionView.reloadData()
            self.loadInProcess = false
        } onError: { error in
            
            print(error.description)
            self.loadInProcess = false
        }

    }
}

extension MoviesListTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            
            return MovieCollectionViewCell()
        }
        
        cell.setMovie(movie: self.movieList[indexPath.row])
        return cell
    }
    
}

extension MoviesListTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 166, height: 327)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let lastIndex = moviesCollectionView.indexPathsForVisibleItems.last?.row {
            
            if lastIndex > self.movieList.count - 5 {
                loadMovies()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let movieId = self.movieList[indexPath.row].id {
            
            StackViewController.detailsDelegate?.showMovieDetails(movieId: movieId)
        }
    }
}
