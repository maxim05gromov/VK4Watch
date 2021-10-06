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
    let first_name: String?
    let id: Int?
    let last_name: String?
    let can_access_closed: Bool?
    let is_closed: Bool?
    let sex: Int?
    let screen_name: String?
    let photo_50: String?
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

struct messages:Decodable{
    let response: MsgResponse?
}
struct MsgResponse: Decodable{
    let count: Int?
    let items: [MsgItems]?
}
struct MsgItems: Decodable {
    let conversation: MsgConversation?
    let last_message: Last_message?
}
struct Last_message: Decodable {
    let date: Int?
    let from_id: Int?
    let id: Int?
    let out: Int?
    let peer_id: Int?
    let text: String?
    let conversation_message_id: Int?
    
    
}
struct MsgConversation: Decodable {
    let peer: Peer?
    let last_message_id: Int?
    let in_reed: Int?
    let out_reed: Int?
    let sort_id: Sort_id?
    let is_marked_unread: Bool?
    let important: Bool?
    let unanswered: Bool?
    let can_write: Can_write?
}
struct Can_write: Decodable {
    let allowed: Bool?
    let reason: Int?
}
struct Sort_id: Decodable {
    let major_id: Int?
    let minor_id: Int?
}
struct Peer: Decodable{
    let id: Int?
    let type: String?
    let local_id: Int?
}
struct UserInfo: Decodable {
    let response: [Response]
}
struct Response: Decodable {
    let first_name: String?
    let id: Int?
    let last_name: String?
    let can_access_closed: Bool?
    let is_closed: Bool?
    let photo_50: String?
}


struct Chat: Decodable{
    let response: ChatResponse?
}
struct ChatResponse: Decodable{
    let count: Int?
    let items: [ChatItem]?
}
struct ChatItem: Decodable {
    let date: Int?
    let from_id: Int?
    let id: Int?
    let out: Int?
    let peer_id: Int?
    let text: String?
    let conversation_message_id: Int?
    let fwd_messages: [ChatFwdMessages]?
    let important: Bool?
    let random_id: Int?
    let attachments: [ChatAttachments]?
    let is_hidden: Bool?
}
struct ChatFwdMessages: Decodable{
    
}
struct ChatAttachments: Decodable {
    
}
