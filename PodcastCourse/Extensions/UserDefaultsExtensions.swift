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
    static let downloadEpisodeObjectKey = "downloadEpisodeObjectKey"
    
    func downloadEpisode(episode: Episode){
        do{
            var episodes = fetchDownloadedEpisodes()
            episodes.insert(episode, at: episodes.count)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeObjectKey)
        }catch let err{
            print(err)
        }
    }
    
    func saveAllEpisodes(episodes: [Episode]){
        do{
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeObjectKey)
        }catch let err{
            print(err)
        }
    }
    
    func fetchDownloadedEpisodes()->[Episode]{
        do{
             guard let episodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadEpisodeObjectKey) else {return [Episode]()}
            //guard let episodesData = data(forKey: UserDefaults.downloadEpisodeObjectKey) else {return [Episode]()}
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes            
        }catch let err{
            print(err)
        }
        
        return [Episode]()
    }
    
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
