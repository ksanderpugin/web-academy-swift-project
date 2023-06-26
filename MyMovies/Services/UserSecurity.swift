//
//  UserSecurity.swift
//  MyMovies
//
//  Created by Aleksandr on 11.05.2023.
//

import Foundation
import KeychainSwift

class UserSecurity {
    
    public static let main = UserSecurity()
    
    public func saveLoginAndPassword(login: String, password: String) {
        
        self.keychain.set(login, forKey: "login-tmdb")
        self.keychain.set(password, forKey: "pass-tmdb")
    }
    
    public func isSaved() -> Bool {
        
        var savedLogin = false
        var savedPassword = false
        
        for key in self.keychain.allKeys {
            
            if key == "login-tmdb" {
                savedLogin = true
            }
            
            if key == "pass-tmdb" {
                savedPassword = true
            }
        }
        
        return savedLogin && savedPassword
    }
    
    public func getLogin() -> String? {
        
        return self.keychain.get("login-tmdb")
    }
    
    public func getPass() -> String? {
        
        return self.keychain.get("pass-tmdb")
    }
    
    public func deleteLoginAndPassword() {
        
        self.keychain.delete("login-tmdb")
        self.keychain.delete("pass-tmdb")
    }
    
    // MARK: private zone
    
    private let keychain: KeychainSwift
    
    private init() {
        self.keychain = KeychainSwift()
    }
}
