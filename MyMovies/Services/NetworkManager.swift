//
//  NetworkManager.swift
//  MyMovies
//
//  Created by Aleksandr on 10.05.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let main = NetworkManager()
    
    var signInDelegate: SignInSuccessAndErrorDelegate?
    
    func signInRequest(login: String, password: String) {
        
        self.sendNewRequstTokenQuery { token in
            
            self.sendValidateRequestTokenQuery(login: login, password: password, requestToken: token) {
                
                self.sendCreateSessionIDQuery(requestToken: token) { sessionID in
                    
                    print("signIn successed, sessionID: \(sessionID)")
                    self.sessionID = sessionID
                    self.signInDelegate?.onSuccess()
                    
                } onError: { error in
                    self.signInDelegate?.onError(error)
                }

            } onError: { error in
                self.signInDelegate?.onError(error)
            }

        } onError: { error in
            self.signInDelegate?.onError(error)
        }

    }
    
    func getSessionID() -> String {
        return self.sessionID
    }
    
    func getPosterUrlString(_ posterPath: String) -> String {
        return self.TMDB_API_UrlToPosterPath + posterPath
    }
    
    func getBackgropUrlString(_ backgropPath: String) -> String {
        return self.TMDB_API_UrlToBackdropPath + backgropPath
    }
    
    func loadGenresList(onSuccess: @escaping ([Genre]) -> Void,
                       onError: @escaping (NetworkManagerError) -> Void ) {
        
        guard let genres = self.genresList else {
            
            let urlString = self.getTMDBUrlString(self.TMDB_API_GetGenresListCommand)
            AF.request(urlString).responseDecodable(of: GenreListRespond.self) { respond in
                
                switch respond.result {
                    
                case .success(let genreList):
                    guard let genres = genreList.genres else {
                        onError(NetworkManagerError(code: .APIError, description: "API Error, pleace, write comment to admin"))
                        return
                    }
                    self.genresList = genres
                    onSuccess(genres)
                    
                case .failure(let error):
                    onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
                }
            }
            return
        }
        
        onSuccess(genres)
    }
    
    func loadMoviesListByGenreId(genreId: Int,
                                 page: Int,
                                 onSuccess: @escaping ([DiscoverMovie]) -> Void,
                                 onError: @escaping (NetworkManagerError) -> Void) {
        
        let urlString = self.getTMDBUrlString(self.TMDB_API_GetDiscoverMovies) + "&sort_by=popularity.desc&with_genres=\(genreId)&page=\(page)"
        
        AF.request(urlString).responseDecodable(of: DiscoverMovieRespond.self) { respond in
            
            switch respond.result {
                
            case .success(let movieRespond):
                guard let movieList = movieRespond.results else {
                    onError(NetworkManagerError(code: .APIError, description: "Can`t get movies"))
                    return
                }
                onSuccess(movieList)
                
            case .failure(let error):
                onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
            }
        }
    }
    
    func loadSearchMoviesList(request: String,
                              onSuccess: @escaping ([SMovie]) -> Void,
                              onError: @escaping (NetworkManagerError) -> Void) {
        
        if let query = request.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            
            let urlString = self.getTMDBUrlString(self.TMDB_API_SearchMoviesCommand) + "&query=\(query)"
            
            AF.request(urlString).responseDecodable(of: SearchMovieRespond.self) { respond in
                
                switch respond.result {
                    
                case .success(let sRespond):
                    guard let movieList = sRespond.results else {
                        onError(NetworkManagerError(code: .APIError, description: "API Error"))
                        return
                    }
                    onSuccess(movieList)
                    
                case .failure(let error):
                    onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
                }
            }
        } else {
            
            onError(NetworkManagerError(code: .APIError, description: "Bad query"))
        }
    }
    
    
    func loadMovieDetails(movieId: Int,
                          onSuccess: @escaping (Movie) -> Void,
                          onError: @escaping (NetworkManagerError) -> Void) {
        
        let urlString1 = self.getTMDBUrlString(self.TMDB_API_MovieDelailsCommand+String(movieId))
        let urlString2 = self.getTMDBUrlString(self.TMDB_API_MovieDelailsCommand+String(movieId)+"/videos")
//        print ("mdr: \(urlString2)")
        
        AF.request(urlString1).responseDecodable(of: MovieDetailsRespond.self) { respond in
            
            switch respond.result {
                
            case .success(let movieDetails):
                
                var genresStr: String = ""
                if let genres = movieDetails.genres {
                    genresStr = genres.first?.name ?? ""
                    let count = genres.count
                    for index in 1..<count {
                        genresStr += " | " + genres[index].name
                    }
                }
                
                
                let movie = Movie(posterPath: movieDetails.posterPath, backgropPath: movieDetails.backdropPath, title: movieDetails.originalTitle, releaseDate: movieDetails.releaseDate, overview: movieDetails.overview, rating: movieDetails.voteAverage, genres: genresStr, key: "")
                movie.setId(movieDetails.id)
                
                AF.request(urlString2).responseDecodable(of: MovieVideosRespond.self) { respond in
                    
                    switch respond.result {
                        
                    case .success(let mVideos):
                        movie.key = mVideos.results.first?.key ?? ""
                        onSuccess(movie)
                        
                    case .failure(let error):
                        onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
                    }
                }
                
            case .failure(let error):
                onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
            }
        }
    }
    
    
    // MARK: private zone
    private var sessionID: String
    private var genresList: [Genre]?
    
    private init() {
        sessionID = ""
    }
    
    
    private func sendNewRequstTokenQuery(
        onSuccess: @escaping (String) -> Void,
        onError: @escaping (NetworkManagerError) -> Void
    ) {
        
        let urlString = getTMDBUrlString(TMDB_API_CreateRequestTokenCommand)
        
        AF.request(urlString).responseDecodable(of: NewRequestTokenRespond.self) { respond in
            
            switch respond.result {
                
            case .success(let requestToken):
                guard let token = requestToken.request_token else {
                    onError(NetworkManagerError(code: .getNewRespondError, description: "Can`t get new respond token!"))
                    return
                }
                onSuccess(token)
                
            case .failure(let error):
                onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
            }
        }
    }
    
    
    private func sendValidateRequestTokenQuery(
        login: String,
        password: String,
        requestToken: String,
        onSuccess: @escaping () -> Void,
        onError: @escaping (NetworkManagerError) -> Void
    ) {
        
        let urlString = getTMDBUrlString(TMDB_API_ValidateRequestTokenCommand)
        
        let parameters = [
            "username": login,
            "password": password,
            "request_token": requestToken
        ]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: NewRequestTokenRespond.self) { respond in
            
            switch respond.result {
                
            case .success(let requestToken):
                guard let success = requestToken.success else {
                    onError(NetworkManagerError(code: .APIError, description: "Application error, please, write to service comment"))
                    return
                }
                if success {
                    onSuccess()
                } else {
                    onError(NetworkManagerError(code: .loginOrPasswordError, description: "Incorrect login or password"))
                }
                
            case .failure(let error):
                onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
            }
            
        }
    }
    
    
    private func sendCreateSessionIDQuery(
        requestToken: String,
        onSuccess: @escaping (String) -> Void,
        onError: @escaping (NetworkManagerError) -> Void
    ) {
        
        let urlString = getTMDBUrlString(TMDB_API_CreateSessionCommand)
        let parameters = ["request_token": requestToken]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: SessionRespond.self) { respond in
            
            switch respond.result {
                
            case .success(let sessionRespond):
                guard let sessionID = sessionRespond.session_id else {
                    onError(NetworkManagerError(code: .APIError, description: "Application error, please, write to service comment"))
                    return
                }
                onSuccess(sessionID)
                
            case .failure(let error):
                onError(NetworkManagerError(code: .internetOrServerError, description: error.localizedDescription))
            }
        }
    }
    
    // TMDB API config
    private let TMDB_API_Url = "https://api.themoviedb.org/3"
    private let TMDB_API_Key = "0053f5cc922062c130bbb83d4f264ac0"
    private let TMDB_API_UrlToBackdropPath = "https://image.tmdb.org/t/p/w533_and_h300_bestv2"
    private let TMDB_API_UrlToPosterPath = "https://image.tmdb.org/t/p/w440_and_h660_face"
    
    // TMDB API Commands
    private let TMDB_API_CreateRequestTokenCommand = "/authentication/token/new"
    private let TMDB_API_ValidateRequestTokenCommand = "/authentication/token/validate_with_login"
    private let TMDB_API_CreateSessionCommand = "/authentication/session/new"
    private let TMDB_API_GetGenresListCommand = "/genre/movie/list"
    private let TMDB_API_GetDiscoverMovies = "/discover/movie"
    private let TMDB_API_SearchMoviesCommand = "/search/movie"
    private let TMDB_API_MovieDelailsCommand = "/movie/"
    
    
    private func getTMDBUrlString(_ command: String) -> String {
        
        return self.TMDB_API_Url + command + "?api_key=" + self.TMDB_API_Key
    }
}


struct NetworkManagerError {
    
    let code: NetworkManagerErrorCode
    let description: String
}

enum NetworkManagerErrorCode {
    
    case internetOrServerError
    case getNewRespondError
    case loginOrPasswordError
    case badValidateRequest
    case getSessionIDError
    case APIError
}

protocol SignInSuccessAndErrorDelegate {
    
    func onSuccess()
    func onError(_ signInError: NetworkManagerError)
}
