//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Aleksandr on 12.05.2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchWrapperView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var emptySearchMesLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let userDefaults = UserDefaults()
    
    private var searchList: [String] = []
    private var movieList: [SMovie] = []
    private var typeOfTableCell: TypeOfTableCell = .search
    
    enum TypeOfTableCell {
        case movie
        case search
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
        
        if let sl = userDefaults.array(forKey: "searchList") as? [String] {
            self.searchList = sl
        }
        
        tableView.register(UINib(nibName: "SearchRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchRequestTableViewCell")
        tableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
        
        configure()
    }
    
    
    private func configure() {
        
        searchWrapperView.layer.borderWidth = 1
        searchWrapperView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        searchWrapperView.layer.cornerRadius = 8
        searchWrapperView.layer.shadowColor = UIColor.white.cgColor
        searchWrapperView.layer.shadowOffset = .zero
        searchWrapperView.layer.shadowRadius = 4
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)]
        )
    }
    
    private func searchMovies(request: String) {
        
        searchTextField.resignFirstResponder()
        
        if !searchList.contains(request) {
            var newSerachList = [request]
            for index in 0...7 {
                guard index < searchList.count else { break }
                newSerachList.append(searchList[index])
            }
            searchList = newSerachList
            userDefaults.set(searchList, forKey: "searchList")
        }
        
        UIView.animate(withDuration: 0.5) {
            
            self.tableView.isHidden = true
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            NetworkManager.main.loadSearchMoviesList(request: request) { movies in
                
                self.movieList = movies
                self.showMovies()
            } onError: { error in
                
                Toast.show(message: error.description, viewControler: self, duration: 5)
            }

        }

    }
    
    private func showLastSearches() {
        
        guard searchList.count > 0 else { return }
        typeOfTableCell = .search
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.tableView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func showMovies() {
        
        guard movieList.count > 0 else {
            tableView.isHidden = true
            emptySearchMesLabel.isHidden = false
            return
        }
        
        typeOfTableCell = .movie
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.tableView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func searchEditingDidBeginAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.searchWrapperView.layer.borderColor = UIColor.white.cgColor
            self.searchWrapperView.layer.shadowOpacity = 0.5
            self.view.layoutIfNeeded()
        }
        showLastSearches()
    }
    
    @IBAction func searchEditingDidEndAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.searchWrapperView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
            self.searchWrapperView.layer.shadowOpacity = 0
            self.view.layoutIfNeeded()
        }
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let request = textField.text else { return false }

        let requestBody = request.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard requestBody.count >= 3 else {
            Toast.show(message: "Request must be at least 3 characters", viewControler: self, duration: 3)
            return false
        }
        
        self.searchMovies(request: requestBody)
        typeOfTableCell = .movie
        textField.resignFirstResponder()
        return false
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        switch self.typeOfTableCell {
            
        case .movie:
            return self.movieList.count
            
        case .search:
            return self.searchList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.typeOfTableCell {
            
        case .search:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRequestTableViewCell", for: indexPath) as? SearchRequestTableViewCell {
                
                cell.label.text = self.searchList[indexPath.row]
                return cell
            }
            
        case .movie:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
                
                cell.setMovie(self.movieList[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.typeOfTableCell {
            
        case .search:
            self.searchMovies(request: self.searchList[indexPath.row])
            
        case .movie:
            if let movieId = movieList[indexPath.row].id {
                StackViewController.detailsDelegate?.showMovieDetails(movieId: movieId)
            }
        }
    }
}

