//
//  AutomCompletePrediction.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
// MARK: - GoogleAutoCompletePredictions
class GoogleAutoCompletePredictions: Codable {
    let predictions: [Prediction]
    let status: String

    required init(from coder : Decoder) throws{
        let container = try coder.container(keyedBy: CodingKeys.self)
        self.predictions = try container.decodeIfPresent([Prediction].self,
                                                     forKey: .predictions) ?? []
        self.status = container.safeDecodeValue(forKey: .status)
    }
}

// MARK: - Prediction
class Prediction: Codable {
    let predictionDescription: String
    let matchedSubstrings: [MatchedSubstring]
    let placeID, reference: String
    let structuredFormatting: StructuredFormatting
    let terms: [Term]
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case predictionDescription = "description"
        case matchedSubstrings = "matched_substrings"
        case placeID = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
        case terms, types
    }

    required init(from coder : Decoder) throws{
        let container = try coder.container(keyedBy: CodingKeys.self)
        self.predictionDescription = container.safeDecodeValue(forKey: .predictionDescription)
        self.placeID = container.safeDecodeValue(forKey: .placeID)
        self.reference = container.safeDecodeValue(forKey: .reference)
        self.structuredFormatting = try  container.decode(StructuredFormatting.self, forKey: .structuredFormatting)
        
        
        self.matchedSubstrings = try container.decodeIfPresent([MatchedSubstring].self,
                                                     forKey: .matchedSubstrings) ?? []
        
        
        self.terms = try container.decodeIfPresent([Term].self,
                                                     forKey: .terms) ?? []
        self.types = try container.decodeIfPresent([String].self,
                                                     forKey: .types) ?? []
    }
}

// MARK: - MatchedSubstring
class MatchedSubstring: Codable {
    let length, offset: Int

    required init(from coder : Decoder) throws{
        let container = try coder.container(keyedBy: CodingKeys.self)
        self.offset = container.safeDecodeValue(forKey: .offset)
        self.length = container.safeDecodeValue(forKey: .length)
    }
}

// MARK: - StructuredFormatting
class StructuredFormatting: Codable {
    let mainText: String
    let mainTextMatchedSubstrings: [MatchedSubstring]
    let secondaryText: String

    enum CodingKeys: String, CodingKey {
        case mainText = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
    }

    required init(from coder : Decoder) throws{
        let container = try coder.container(keyedBy: CodingKeys.self)
        self.mainText = container.safeDecodeValue(forKey: .mainText)
        self.secondaryText = container.safeDecodeValue(forKey: .secondaryText)
        self.mainTextMatchedSubstrings = try container.decodeIfPresent([MatchedSubstring].self,
                                                     forKey: .mainTextMatchedSubstrings) ?? []
    }
}

// MARK: - Term
class Term: Codable {
    let offset: Int
    let value: String

    required init(from coder : Decoder) throws{
        let container = try coder.container(keyedBy: CodingKeys.self)
        self.offset = container.safeDecodeValue(forKey: .offset)
        self.value = container.safeDecodeValue(forKey: .value)
    }
}
