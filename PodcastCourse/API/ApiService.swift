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
    
    typealias completedDownloadTuple = (fileUrl: String, title: String)
    
    static let shared = ApiService()
    let baseURL = "https://itunes.apple.com/search"
    
    func downloadEpisode(_ episode: Episode){        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            NotificationCenter.default.post(name: .updateDownloadProgressLabelName, object: self, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            }.response { (response) in
                if(response.response?.statusCode == 200){
                    guard let url = response.destinationURL?.absoluteString else {return}
                    NotificationCenter.default.post(name: .finishDownloadsViewControllerName, object: self, userInfo: ["title": episode.title, "fileUrl": url])
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
