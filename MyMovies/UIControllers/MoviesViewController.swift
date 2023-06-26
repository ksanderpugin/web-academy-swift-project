//
//  MoviesViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    static var showDetailsDelegate: ShowMovieDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private var genresList: [Genre] = []
    
    private func configure() {
        
        tableView.register(UINib(nibName: "MoviesListTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesListTableViewCell")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            NetworkManager.main.loadGenresList { genres in
                self.genresList = genres
                self.tableView.reloadData()
            } onError: { error in
                Toast.show(message: error.description, viewControler: self, duration: 4)
            }
        }
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.genresList.count < 1 ? 3 : self.genresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let moviesCell = tableView.dequeueReusableCell(withIdentifier: "MoviesListTableViewCell", for: indexPath) as? MoviesListTableViewCell else {
            
            return UITableViewCell()
        }
        
        moviesCell.setLoadStyle()
        if indexPath.row < self.genresList.count {
            moviesCell.setGenre(genre: self.genresList[indexPath.row])
        }
        return moviesCell
    }
    
}
