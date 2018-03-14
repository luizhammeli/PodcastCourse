//
//  Podcast.swift
//  PodcastCourse
//
//  Created by iOS Developer on 07/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
}
