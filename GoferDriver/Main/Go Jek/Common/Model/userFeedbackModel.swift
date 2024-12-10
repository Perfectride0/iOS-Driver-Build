//
//  userFeedbackModel.swift
//  GoferHandyProvider
//
//  Created by trioangle on 29/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
enum ServiceSelectedState: String, Codable {
    case expand
    case collapsed
}

// MARK: - Welcome
class userFeedbackModel: Codable {
    let statusCode, statusMessage: String
    let currentPage , totalPages : Int
    var userFeedback: [UserFeedback]
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case statusMessage = "status_message"
        case userFeedback = "user_feedback"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        let userFeedback = try container.decodeIfPresent([UserFeedback].self, forKey: .userFeedback)
        self.userFeedback = userFeedback ?? [UserFeedback()]
    }
    
    init(statusCode: String,
         statusMessage: String,
         userFeedback: [UserFeedback],
         totalPages : Int,
         currentPage : Int) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.userFeedback = userFeedback
        self.totalPages = totalPages
        self.currentPage = currentPage
    }
}

// MARK: - UserFeedback
class UserFeedback: Codable {
    let date: String
    let providerRating: Int
    let providerComments, userName: String
    let src: String
    var selectionState: ServiceSelectedState? = nil
    let thumbUp : Int
    var isThumbsUp : Bool
    
    init() {
        self.date = ""
        self.providerRating = 0
        self.providerComments = ""
        self.userName = ""
        self.src = ""
        self.selectionState = .expand
        self.isThumbsUp = false
        self.thumbUp = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case providerRating = "provider_rating"
        case providerComments = "provider_comments"
        case userName = "user_name"
        case src
        case thumbUp = "is_thumbs_up"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = container.safeDecodeValue(forKey: .date)
        self.providerRating = container.safeDecodeValue(forKey: .providerRating)
        self.providerComments = container.safeDecodeValue(forKey: .providerComments)
        self.userName = container.safeDecodeValue(forKey: .userName)
        self.src = container.safeDecodeValue(forKey: .src)
        self.thumbUp = container.safeDecodeValue(forKey: .thumbUp)
        self.isThumbsUp = thumbUp == 1
    }
    
    init(date: String,
         userRating: Int,
         userComments: String,
         userName: String,
         src: String,
         ThumbsUp: Int) {
        self.date = date
        self.providerRating = userRating
        self.providerComments = userComments
        self.userName = userName
        self.src = src
        self.selectionState = .expand
        self.isThumbsUp = ThumbsUp == 1
        self.thumbUp = ThumbsUp
    }
}

