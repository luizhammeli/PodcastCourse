//
//  UserDefaultsExtensions.swift
//  PodcastCourse
//
//  Created by iOS Developer on 27/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

extension UserDefaults{
    static let favoriteObjectKey = "favoriteObjectKey"
    static func fetchFavorites()->[Podcast]{
        guard let data = UserDefaults.standard.object(forKey: favoriteObjectKey) as? Data else {return [Podcast]()}
        guard let podcast = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast] else{return [Podcast]()}
        return podcast
    }
    
    static func saveFavorites(_ podcasts: [Podcast]){
        let data = NSKeyedArchiver.archivedData(withRootObject: podcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoriteObjectKey)
    }
}
