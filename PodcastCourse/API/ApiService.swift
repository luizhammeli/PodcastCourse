//
//  ApiService.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 11/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class ApiService{
    
    static let shared = ApiService()
    let baseURL = "https://itunes.apple.com/search"
    
    func downloadEpisode(_ episode: Episode){
        let newEpisode = episode
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        var episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            }.response { (response) in
                if(response.response?.statusCode == 200){
                   guard let index =  episodes.index(where: { (episode) -> Bool in return (episode.author == newEpisode.author && episode.title == newEpisode.title)
                   }) else {return}
                    guard let url = response.destinationURL?.absoluteString else {return}
                    episodes[index].fileUrl = url
                    UserDefaults.standard.saveAllEpisodes(episodes: episodes)
                    NotificationCenter.default.post(name: DownloadsViewController.finishDownloadsViewControllerName, object: nil)
                }
        }
    }
    
    func fetchPodcasts(_ searchText: String, completionHandler: @escaping ([Podcast])->Void){
        
        let parameters = ["entity":"podcast", "term": searchText]
        
        Alamofire.request(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataReponse) in
            
            if let error = dataReponse.error{
                print(error)
            }
            
            guard let data = dataReponse.data else {return}
            let results = self.convertJson(data)
            completionHandler(results)
        }
    }
    
    func fetchEpisodes(podcast: Podcast?, completionHandler: @escaping (([Episode])->Void)){
        guard let stringUrl = podcast?.feedUrl else {return}        
        guard let url = URL(string: stringUrl) else {return}
        var episodes = [Episode]()
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in
                
                if let error = result.error{
                    print("error to parse episodes feed: \(error)")
                    return
                }
                
                if let rss = result.rssFeed{
                    episodes = rss.getFeedEpisodes()
                }
                
                completionHandler(episodes)
            })
        }
    }
    
    func convertJson(_ data: Data)->[Podcast]{
        do{
            let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
            return searchResult.results
        }catch let error{
            print(error)
        }
        return [Podcast]()
    }
}
