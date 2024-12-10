//
//  BtnPymtStatus.swift
//  GoferDriver
//
//  Created by trioangle on 08/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
enum BtnPymtStatus{
    case proceed
    case cashCollected
    case waitingForConfirmation
    case paid
}
enum MoreOptions:String,CaseIterable{
    case Chat,LiveTrack = "Live Tracking",ThirdPartyNavigation = "Navigate",RequestedServices = "Requested Services",ViewRecipients = "View Recipients",CancelJob = "Cancel Job",JobProgress = "Job Progress", selectedServices, allServices, Call = "call" ,job_details
    var localizedString : String {
      switch self {
      
      case .Call:
        return LangCommon.call.lowercased().capitalized
      case .Chat:
        return LangCommon.message
      case .LiveTrack:
        return LangHandy.liveTrack
      case .JobProgress:
        return LangHandy.jobProgress
      case .ThirdPartyNavigation:
        return LangCommon.navigate.lowercased().capitalized
      case .RequestedServices:
        return LangHandy.requestedService
      case .CancelJob:
        return LangCommon.cancelBooking
      case .selectedServices:
        return LangHandy.myServices
      case .allServices:
        return LangHandy.allServices
      case .ViewRecipients :
        return LangDelivery.viewRecipients
      case .job_details:
          return LangHandy.jobDetails
      }
    }
}
enum enRouteOptions{
    case list,map
}
protocol JobManagerDelegate {
    var shouldFocusPolyline : Bool {get set}
    var gMapView : GMSMapView {get}
    var viewController : UIViewController {get}
    var progressBtn : ProgressButton {get}
    func updateDestination(with detail : JobDetailModel)
    func onSuccessfullTripCompletion()
    func deinitObjects()
    
}
protocol ExtraTripFareDelegate {
    func extraTripFareApplied(_ option : ExtraFareOption)
    func extraTripFareCancelled()
}



class ExtraFareOptionModel: Codable {
    let status_code : String
    let status_message : String
    var toll_reasons : [ExtraFareOption]

    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status_message = "status_message"
        case toll_reasons = "toll_reasons"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        let toll_reasons = try? container.decodeIfPresent([ExtraFareOption].self, forKey: .toll_reasons)
        self.toll_reasons = toll_reasons ?? [ExtraFareOption]()
        
    }
}
    
class ExtraFareOption: Codable {
    let id : Int
    let reason : String
    let commentable : Bool
    var comment : String?
    var amount : Double!

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reason = "reason"
        case commentable = "commendable"
        case comment = "comment"
        case amount = "amount"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.reason = container.safeDecodeValue(forKey: .reason)
        self.commentable = container.safeDecodeValue(forKey: .commentable)
        self.comment = container.safeDecodeValue(forKey: .comment)
        self.amount = container.safeDecodeValue(forKey: .amount)
    }
}
    
extension ExtraFareOption : CustomStringConvertible{
    var description: String{
        return self.reason
    }
}

//class ExtraFareOption{
//    let id : Int
//    let reason : String
//    let commentable : Bool
//    var comment : String?
//    var amount : Double!
//    
//    
//    init(_ json : JSON) {
//        self.id = json.int("id")
//        self.reason = json.string("reason")
//        self.commentable = json.bool("commendable")
//    }
//}
//extension ExtraFareOption : CustomStringConvertible{
//    var description: String{
//        return self.reason
//    }
//}
