//
//  ApiService.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 11/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import Alamofire

class ApiService{
    
    static let shared = ApiService()
    let baseURL = "https://itunes.apple.com/search"
    
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
