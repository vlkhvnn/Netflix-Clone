//
//  TV.swift
//  Netflix Clone
//
//  Created by Alikhan Tangirbergen on 17.09.2023.
//

import Foundation
struct TV : Codable{
    let id : Int
    let media_type : String?
    let title : String?
    let original_title: String?
    let original_language: String?
    let poster_path : String?
    let overview : String?
    let vote_count : Int
    let release_date : String?
    let vote_average : Double
}

struct TrendingTVsResponse : Codable {
    let results : [TV]
}
