//
//  JobHistoryModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

// MARK: - JobHistoryModel
class JobHistoryModel: Codable ,Equatable {
    
    // Adding This Model comparing the Details
    static func == (lhs: JobHistoryModel, rhs: JobHistoryModel) -> Bool {
        lhs.statusCode == rhs.statusCode &&
        lhs.statusMessage == rhs.statusMessage &&
        lhs.currentPage == rhs.currentPage &&
        lhs.totalPages == rhs.totalPages &&
        lhs.data == rhs.data
    }
    
    let statusCode, statusMessage: String
    var currentPage, totalPages: Int
    var data: [JobDetailModel]
    

    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case data
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        let datas = try? container.decodeIfPresent([JobDetailModel].self, forKey: .data)
        self.data = datas ?? [JobDetailModel]()
    }
    func updateWithNewData(_ newData : JobHistoryModel){
        self.currentPage = newData.currentPage
        
        self.data.append(contentsOf: newData.data)
    }

}

class OrderDataModel:Codable,Equatable{
    static func == (lhs: OrderDataModel, rhs: OrderDataModel) -> Bool {
        lhs.totalFare == rhs.totalFare &&
        lhs.vehicleName == rhs.vehicleName &&
        lhs.id == rhs.id &&
        lhs.status == rhs.status &&
        lhs.mapImage == rhs.mapImage &&
        lhs.isConfirmed == rhs.isConfirmed &&
        lhs.groupId == rhs.groupId
    }
    
    
    
    let totalFare, vehicleName: String
    var id, status: Int
    var mapImage,isConfirmed,groupId:String
    enum CodingKeys: String, CodingKey {
        case totalFare = "total_fare"
        case vehicleName = "vehicle_name"
        case id = "id"
        case status = "status"
        case mapImage = "map_image"
        case isConfirmed = "is_confirmed"
        case groupId = "group_id"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.vehicleName = container.safeDecodeValue(forKey: .vehicleName)
        self.id = container.safeDecodeValue(forKey: .id)
        self.status = container.safeDecodeValue(forKey: .status)
        self.mapImage = container.safeDecodeValue(forKey: .mapImage)
        self.isConfirmed = container.safeDecodeValue(forKey: .isConfirmed)
        self.groupId = container.safeDecodeValue(forKey: .groupId)
    }
}
