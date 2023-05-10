//
//  AuthService.swift
//  MyMovies
//
//  Created by Aleksandr on 09.05.2023.
//

import Foundation
import Alamofire

class AuthService {
    
    public static var delegate: AuthServiceSuccessAndErrorProtocol?
    
    public static func getSessionID() -> String {
        
        return self.sessionID
    }
    
    public static func singIn(login: String, password: String) {
        
        var APICommand = theMovieDBUrlString(command: Config.theMovieDBCreateRequestTokenCommand)
            AF.request(APICommand).responseDecodable(of: NewRequestTokenRespond.self) { responce in
               
                switch responce.result {
                case .success(let newRequestToken):
                    guard let requestToken = newRequestToken.request_token else {
                        delegate?.onError(AuthError(code: .getNewRespondError, description: "Can`t get new request token"))
                        return
                    }
                    
                    print("new request token geted")
                    
                    let requestParameters = [
                        "username": login,
                        "password": password,
                        "request_token": requestToken
                    ]
                    APICommand = theMovieDBUrlString(command: Config.theMovieDBValidateLoginAndPassword)
                    
                    AF.request(APICommand, method: .post, parameters: requestParameters, encoding: JSONEncoding.default).responseDecodable(of: NewRequestTokenRespond.self) { responce in
                        
                        switch responce.result {
                        case .success(let requestToken):
                            guard let successState = requestToken.success else {
                                delegate?.onError(AuthError(code: .badValidateRequest, description: "Bad request for validate login and password"))
                                return
                            }
                            if successState {
                                // get sessionID
                                APICommand = theMovieDBUrlString(command: Config.theMovieDBCreateNewSessionCommand)
                                let parameters = [
                                    "request_token": requestToken
                                ]
                                AF.request(APICommand, method: .post, parameters: requestParameters, encoding: JSONEncoding.default).responseDecodable(of: SessionRespond.self) { responce in
                                    
                                    switch responce.result {
                                    case .success(let sessionRespond):
                                        guard let sessionID = sessionRespond.session_id else {
                                            delegate?.onError(AuthError(code: .getSessionIDError, description: "Can`t get session ID"))
                                            return
                                        }
                                        self.sessionID = sessionID
                                        delegate?.onSuccess(sessionID)
                                        
                                    case .failure(let error):
                                        
                                        delegate?.onError(AuthError(code: .internetOrServerError, description: error.localizedDescription))
                                    }
                                }
                                
                            } else {
                                delegate?.onError(AuthError(code: .loginOrPasswordError, description: "login or password incorrect"))
                            }
                            
                        case .failure(let error):
                            delegate?.onError(AuthError(code: .internetOrServerError, description: error.localizedDescription))
                        }
                    }
                    
                case .failure(let error):
                    
                    delegate?.onError(AuthError(code: .internetOrServerError, description: error.localizedDescription))
                }
            }
    }
    
    private static var sessionID: String = ""
    private static func theMovieDBUrlString(command: String) -> String {
        return Config.theMovieDBAPIUrlString + command + "?api_key=" + Config.theMovieDBAPIKey
    }
}

struct AuthError {
    
    let code: AuthErrorCode
    let description: String
}

enum AuthErrorCode {
    case internetOrServerError
    case getNewRespondError
    case loginOrPasswordError
    case badValidateRequest
    case getSessionIDError
}

protocol AuthServiceSuccessAndErrorProtocol {
    func onSuccess(_ sessionID: String)
    func onError(_ authError: AuthError)
}
