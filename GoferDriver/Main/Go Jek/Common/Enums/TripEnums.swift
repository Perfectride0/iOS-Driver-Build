//
//  TripEnums.swift
//  GoferDriver
//
//  Created by trioangle on 08/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
typealias DistanceClosure = (_ distance : Double,_ path : String)->Void

enum TripStatus : String,Codable,CaseIterable{
    case manuallyBooked = "manual_booking_job_assigned"
    case manuallyBookedReminder = "manual_booking_job_reminder"
    case manualBookiingCancelled = "manual_booking_job_canceled_info"
    case manualBookingInfo = "manual_booking_job_booked_info"
    
    case pending = "Pending"
    case scheduled = "Scheduled"
    case request = "Request"
    case beginTrip = "Begin job"
    case endTrip =  "End job"
    case payment = "Payment"
    case cancelled = "Cancelled"
    case completed = "Completed"
    case rating = "Rating"
    
    //deliveryAll
    case beginTripDel = "Begin trip"
    case endTripDel =  "End trip"
    case manuallyBookedDel = "manual_booking_trip_assigned"
    case manuallyBookedReminderDel = "manual_booking_trip_reminder"
    case manualBookiingCancelledDel = "manual_booking_trip_canceled_info"
    case manualBookingInfoDel = "manual_booking_trip_booked_info"
    case accepetedOrderDel = "Accepted"
    case confirmedOrderDel = "Confirmed"
    case declinedOrderDel = "Declined"
    case startedTripDel = "Started"//started trip
    case deliverdOrderDel = "Delivered"
    
    
    var isTripStarted :Bool{
        return !(self < .endTrip)
    }
    var isDelOrderStarted :Bool{
        return [TripStatus.startedTripDel,.deliverdOrderDel,.completed].contains(self)//confirmedOrder,.
    }
    var isDelOrder2Started :Bool{
        return [TripStatus.startedTripDel,.deliverdOrderDel,.completed].contains(self)//confirmedOrder,.
    }
    
    var isTripCompleted : Bool {
        return (self == .completed ||
                self == .cancelled ||
                self == .rating)
    }
    
    var isDeliveryTripStarted : Bool {
        return false
    }
    init(fromDeliveryCode code : String){
        let codeStat = TripStatus(rawValue: code.capitalized)
        switch codeStat {
        case .accepetedOrderDel://Pending
            self = .accepetedOrderDel
        case .confirmedOrderDel:
            self = .confirmedOrderDel
        case .declinedOrderDel:
            self = .declinedOrderDel
        case .startedTripDel:
            self = .startedTripDel
        case .deliverdOrderDel:
            self = .deliverdOrderDel
        case .completed:
            self = .completed
        case .cancelled:
            self = .cancelled
        default:
            self = .accepetedOrderDel
        }
    }
  var deliveryCode : Int{
      switch self {
      case .accepetedOrderDel:
          return 0
      case .confirmedOrderDel:
          return 1
      case .declinedOrderDel:
          return 2
      case .startedTripDel:
          return 3
      case .deliverdOrderDel:
          return 4
      case .completed:
          return 5
      case .cancelled:
          return 6
      default:
          return 0
      }
  }
 
    var localizedString: String {
      switch self {
      case .pending:
        return LangCommon.pendingStatus.capitalized
      case .scheduled:
        return LangCommon.scheduledStatus.capitalized
      case .request:
        return LangCommon.requestStatus.capitalized
      case .manuallyBooked:
        return ""
      case .manuallyBookedReminder:
        return ""
      case .manualBookiingCancelled:
        return ""
      case .manualBookingInfo:
        return ""
      case .beginTrip:
        return LangCommon.beginJob.capitalized
      case .endTrip:
        return LangCommon.endJob.capitalized
      case .payment:
        return LangCommon.paymentStatus.capitalized
      case .cancelled:
        return LangCommon.cancelledStatus.capitalized
      case .completed:
        return LangCommon.completedStatus.capitalized
      case .rating:
        return LangCommon.ratingStatus.capitalized
        
      case .beginTripDel :
        return LangDeliveryAll.beginTrip
      case .endTripDel :
        return LangDeliveryAll.endTrip
      case .accepetedOrderDel:
        return LangDeliveryAll.accepted
      case .confirmedOrderDel :
        return LangDeliveryAll.confirmed
      case .startedTripDel:
        return LangDeliveryAll.picked
      case .deliverdOrderDel:
        return LangDeliveryAll.delivered
      case .declinedOrderDel:
        return LangDeliveryAll.declined
          default : return self.rawValue
      
      }
    }

}
extension TripStatus : Comparable{
    static func < (lhs: TripStatus, rhs: TripStatus) -> Bool {
        let items = Self.allCases
        let lhsItemPos = items.find(includedElement: {$0 == lhs}) ?? 0
        let rhsItemPos = items.find(includedElement: {$0 == rhs}) ?? 0
        return lhsItemPos < rhsItemPos
        
    }
    
    
}
enum BookingEnum : String, Codable{
    case schedule = "Schedule Booking"
    case auto = ""
    case manualBooking = "Manual Booking"
    var localizedString: String {
      switch self {
      case .schedule:
        return  LangCommon.scheduleBooking
      case .manualBooking:
         return LangCommon.manualBooking
      case .auto:
         return ""
      }
    }
}

extension TripStatus{
    var getDisplayText : String{
        // MARK: - Variable for Language Protocol
        switch self {
        case .beginTrip:
            return LangCommon.beginJob
        case .endTrip:
            return LangCommon.endJob
        case .scheduled:
            return LangCommon.arrive
        case .beginTripDel :
          return LangCommon.beginTrip
        case .endTripDel :
          return LangCommon.endTrip
        case .accepetedOrderDel:
          return LangDeliveryAll.startTrip
        case .confirmedOrderDel :
          return LangDeliveryAll.startTrip
        case .startedTripDel:
          return LangDeliveryAll.collectCash
        case .deliverdOrderDel:
            return LangDeliveryAll.complete + LangDeliveryAll.trip
        case .declinedOrderDel:
            return LangHandy.decline
        default:
            return ""
        }
    }
    var getDeliveryDisplayText : String{
        // MARK: - Variable for Language Protocol
        switch self {
        case .beginTrip:
            return LangDelivery.startDelivery
        case .endTrip:
            return LangDelivery.endDelivery
        case .scheduled:
            return LangDelivery.reached
        case .beginTripDel :
          return LangCommon.beginTrip
        case .endTripDel :
          return LangCommon.endTrip
        case .accepetedOrderDel:
          return LangDeliveryAll.accepted
        case .confirmedOrderDel :
          return LangDeliveryAll.confirmed
        case .startedTripDel:
          return LangDeliveryAll.picked
        case .deliverdOrderDel:
          return LangDeliveryAll.delivered
        case .declinedOrderDel:
            return LangHandy.decline
        default:
            return ""
        }
    }
    var localizedValue : String{
        switch self {
            case .pending :  return LangCommon.pendingStatus
            case .cancelled :  return LangCommon.cancelledStatus
            case .completed :  return LangCommon.completedStatus
            case .rating :  return LangCommon.ratingStatus
            case .payment :  return LangCommon.paymentStatus
            case .request :  return LangCommon.requestStatus
            case .beginTrip :  return LangCommon.beginJob
            case .endTrip :  return LangCommon.endJob
            case .scheduled :  return LangCommon.scheduledStatus
            default : return self.rawValue
        }
    }
   
}
