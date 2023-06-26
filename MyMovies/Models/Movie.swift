//
//  Movie.swift
//  MyMovies
//
//  Created by Aleksandr on 13.05.2023.
//

import Foundation
import RealmSwift

class Movie: Object {
    
    @Persisted(primaryKey: true) private var id: Int
    @Persisted var posterPath: String
    @Persisted var backgropPath: String
    @Persisted var title: String
    @Persisted var releaseDate: String
    @Persisted var overview: String
    @Persisted var rating: Double
    @Persisted var genres: String
    @Persisted var key: String
    
    convenience init(posterPath: String,
                     backgropPath: String,
                     title: String,
                     releaseDate: String,
                     overview: String,
                     rating: Double,
                     genres: String,
                     key: String) {
        
        self.init()
        self.posterPath = posterPath
        self.backgropPath = backgropPath
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
        self.rating = rating
        self.genres = genres
        self.key = key
    }
    
    func getId() -> Int {
        return self.id
    }
    
    func setId(_ id: Int) {
        self.id = id
//        return true
    }
    
    func saveToFavorite() {
        do {
            let realm = try Realm()
            guard let _ = realm.object(ofType: Movie.self, forPrimaryKey: self.id) else {
                
                try realm.write({
                    realm.add(self)
                })
                return
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func findById(_ id: Int) -> Movie? {
        
        do {
            let realm = try Realm()
            return realm.object(ofType: Movie.self, forPrimaryKey: id)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func findAll() -> [Movie] {
        
        var movies: [Movie] = []
        do {
            let realm = try Realm()
            let results = realm.objects(Movie.self)
            for index in 0..<results.count {
                movies.append(results[index])
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return movies
    }
}
