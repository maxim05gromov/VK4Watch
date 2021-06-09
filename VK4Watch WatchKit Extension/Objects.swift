//
//  Objects.swift
//  VK4Watch WatchKit Extension
//
//  Created by Максим on 08.06.2021.
//

import Foundation
struct Attachments: Decodable{
    let type: String?
    let photo: Photo?
}
struct Photo: Decodable {
    let album_id: Int?
    let date: Int?
    let id: Int?
    let owner_id: Int?
    let has_tags: Bool?
    let access_key: String?
    let post_id: Int?
    let sizes: [Sizes]?
}
struct Sizes: Decodable {
    let height: Int?
    let url: String?
    let type: String?
    let width: Int?
}
struct Items: Decodable {
    let source_id: Int?
    let date: Int?
    let can_doubt_category: Bool?
    let can_set_category: Bool?
    let type: String?
    let post_type: String?
    let text: String?
    let marked_as_ads: Int?
    let attachments: [Attachments]?
}
struct Profiles: Decodable {
    let first_name: String
}
struct Groups: Decodable{
    let id: Int
    let name: String
    let screen_name: String
    let is_closed: Int
    let type: String
    let photo_50: String
}
struct News: Decodable{
    struct Response: Decodable {
        let items: [Items]
        let profiles: [Profiles]
        let groups: [Groups]
    }
    let response: Response
}


struct ContextNews: Decodable{
    let news: News
    let row: Int
}
