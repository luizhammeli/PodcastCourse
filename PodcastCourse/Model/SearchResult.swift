//
//  SearchResult.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 07/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
