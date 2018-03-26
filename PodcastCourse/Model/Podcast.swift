//
//  Podcast.swift
//  PodcastCourse
//
//  Created by iOS Developer on 07/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

class Podcast: NSObject, Decodable, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(trackName ?? "", forKey: "trackName")
        aCoder.encode(artistName ?? "", forKey: "artistName")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artworkUrl600")
    }
    
    required init?(coder aDecoder: NSCoder) {
        trackName = aDecoder.decodeObject(forKey: "trackName") as? String ?? ""
        artistName = aDecoder.decodeObject(forKey: "artistName") as? String ?? ""
        artworkUrl600 = aDecoder.decodeObject(forKey: "artworkUrl600") as? String ?? ""
    }
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
