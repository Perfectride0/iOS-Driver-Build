//
//  AppRouter.swift
//  GoferDriver
//
//  Created by trioangle on 28/05/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire


class AppRouter {
    
    //MARK:- local variables
    fileprivate let currentViewController : UIViewController
    //MARK:- initalizers
    init(_ currentVC : UIViewController){
        self.currentViewController = currentVC
    }
    
    
}
extension AppRouter{
    //MARK:- UDF APIHandling
//    func getInvoiceAndRoute(forTrip trip : RiderDataModel){
//        var params = Parameters()
//        params["trip_id"] = trip.description
//        ConnectionHandler.shared.getRequest(for: APIEnums.getInvoice, params: params, showLoader: true)
////            .responseJSON({ (json) in
////                var customizedJSON = JSON()
////                customizedJSON["riders"] = [json]
////                let trip = TripDetailDataModel( customizedJSON)
////                   if json.isSuccess{
////                    self.routeInCompleteTrips(trip)
////                   }else{
////                    appDelegate.createToastMessage(json.status_message)
////                   }
////               })
//            .responseDecode(to: JobDetailModel.self,{ (response) in
//                   if response.statusCode == "1"{
//                    self.routeInCompleteTrips(response)
//                   }else{
//                    appDelegate.createToastMessage(response.statusMessage)
//                   }
//
//            })
//            .responseFailure({ (error) in
//                appDelegate.createToastMessage(error.description)
//               })
//    }
}


extension AppRouter{
    //MARK:- UDF ROUTERS
    
//    func getPaymentInvoiceAndRoute(_ trip : RiderDataModel){
//        var params = Parameters()
//        params["trip_id"] = trip.description
//        ConnectionHandler.shared.getRequest(for: APIEnums.getInvoice, params: params, showLoader: true)
////            .responseJSON({ (json) in
////                var customizedJSON = JSON()
////                customizedJSON["riders"] = [json]
////                let trip = TripDetailDataModel( customizedJSON)
////                   if json.isSuccess{
////                    self.routeInCompleteTrips(trip)
////                   }else{
////                    appDelegate.createToastMessage(json.status_message)
////                   }
////               })
//            .responseDecode(to: JobDetailModel.self,{ (response) in
//                   if response.statusCode == "1"{
//                    self.routeInCompleteTrips(response)
//                   }else{
//                    appDelegate.createToastMessage(response.statusMessage)
//                   }
//
//            })
//
//            .responseFailure({ (error) in
//                appDelegate.createToastMessage(error.description)
//               })
//    }
    //Laundry splitup start
    //Instacart splitup start

    //MARK: Redierect to incomplet trips
    func routeInCompleteTrips(_ trip : JobDetailModel){
        var current : JobDetailModel?
        switch AppWebConstants.businessType {
        case .Ride:
            current = trip
        case .Tow:
            current = trip
        default:
            current = trip
        }
        switch current?.getCurrentTrip()?.jobStatus ?? .pending {
        case .rating:
            
            
            
            
            self.route2Rating(forTrip: trip)
        case .cancelled,.completed:
            self.route2TripDetailsInfo(forTrip: trip)
        case .payment:
          self.route2Payment(forTrip: trip)
        case .scheduled,.beginTrip,.endTrip:
            print("need to be connect")
            //self.route2TripScreen(forTrip: trip)
        default:
            print("")
        }
        
    }
    
    //New_Delivery_splitup_Start
    //Gofer splitup start
    //Handy_NewSplitup_Start
    func routeInCompleteOrders(orderID: Int, status : TripStatus){
       
        switch status{
        case .rating:
            self.route2RatingDel(orderID, status)
        case .cancelled,.completed:
            self.route2DelAllOrderDetailsDel(orderID)
        case .payment:
          self.route2PaymentDel(orderID: orderID, status: status)
        case .scheduled,.beginTrip,.endTrip,
             .accepetedOrderDel,.confirmedOrderDel,.declinedOrderDel,
             .startedTripDel,.deliverdOrderDel, .pending:
            self.route2DeliveryAllRouteScreen(orderID)
        default:
            print("")
        }
    }
    //Laundry splitup end
    //Deliveryall_Newsplitup_start
    func routeInCompleteOrdersLaundry(orderID: Int, status : TripStatus){
       
        switch status{
        case .rating:
            break
            //self.route2RatingDel(orderID, status)
        case .cancelled,.completed:
            
            self.route2LaundryOrderDetailsDel(orderID)
            
        case .payment:
            break
          //self.route2PaymentDel(orderID: orderID, status: status)
        case .scheduled,.beginTrip,.endTrip,
             .accepetedOrderDel,.confirmedOrderDel,.declinedOrderDel,
             .startedTripDel,.deliverdOrderDel, .pending:
            self.route2LaundryRouteScreen(orderID)
        default:
            print("")
        }
    }
    //Instacart splitup end

    //Laundry splitup start

    func routeInCompleteOrdersInstacart(orderID: Int, status : TripStatus){
       
        switch status{
        case .rating:
           // self.route2RatingDel(orderID, status)
            break
        case .cancelled,.completed:
            //Deliveryall splitup start
            self.route2InstaOrderDetailsDel(orderID)
            //Deliveryall splitup End
        case .payment:
          //self.route2PaymentDel(orderID: orderID, status: status)
            break
        case .scheduled,.beginTrip,.endTrip,
             .accepetedOrderDel,.confirmedOrderDel,.declinedOrderDel,
             .startedTripDel,.deliverdOrderDel, .pending:
            self.route2InstaRouteScreen(orderID)
        default:
            print("")
        }
    }
    //Deliveryall_Newsplitup_end
    //Gofer splitup end

    //Instacart splitup start
    //Gofer
    func routeInGoferCompleteOrders(_ trip : JobDetailModel){
        route_Gofer(forTrip: trip)
    }

    //Gofer splitup start
    func routeInCompleteOrdersAfterAccept(_ trip : TripDataModel,shouldPopToRoot: Bool){
        
        switch trip.order_details?.status {
        case .rating:
            print("df")
            //self.route2Rating(forTrip: trip)
        case .cancelled,.completed:
            print("df")
            self.route2DelAllOrderDetails(nil, trip)
        case .payment:
            print("df")
          //self.route2Payment(forTrip: trip)
        case .scheduled,.beginTrip,.endTrip,
             .accepetedOrderDel,.confirmedOrderDel,.declinedOrderDel,
             .startedTripDel,.deliverdOrderDel:
            self.route2DelAllScreen(forTrip: trip,ShouldPopToRoot: shouldPopToRoot)

        default:
            print("")
        }
        
    }
    //Instacart splitup end
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end
    //Instacart splitup start
    //Deliveryall splitup End
    // Laundry Splitup End
    func routeInCompleteOrdersAfterAcceptLaundry(_ trip : TripDataModel,shouldPopToRoot: Bool){
        
        switch trip.order_details?.status {
        case .rating:
            print("df")
            //self.route2Rating(forTrip: trip)
        case .cancelled,.completed:
            print("df")
            self.route2DelAllOrderDetailsLaundry(nil, trip)
        case .payment:
            print("df")
          //self.route2Payment(forTrip: trip)
        case .scheduled,.beginTrip,.endTrip,
             .accepetedOrderDel,.confirmedOrderDel,.declinedOrderDel,
             .startedTripDel,.deliverdOrderDel:
            self.route2LaundryScreen(forTrip: trip,ShouldPopToRoot: shouldPopToRoot)

        default:
            print("")
        }
        
    }
    //Deliveryall_Newsplitup_end
    // Laundry Splitup Start
    func route2DelAllOrderDetails(_ jobDetail:JobDetailModel?,_ tripData:TripDataModel?){
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
        
        
    }
    // Instacart Splitup End
    //Deliveryall splitup start

    //Deliveryall_Newsplitup_start

    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end

    //Deliveryall splitup End
    // Instacart Splitup Start
    func route2DelAllOrderDetailsDel(_ orderID : Int){
        // Laundry_NewSplitup_start
    }
    // Laundry Splitup End
    
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    func route2DelAllOrderDetailsLaundry(_ jobDetail:JobDetailModel?,_ tripData:TripDataModel?){
        
        
    }
    
    
    func route2LaundryOrderDetailsDel(_ orderID : Int){
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    // Laundry Splitup Start
    // Instacart Splitup End
    func route2InstaOrderDetailsDel(_ orderID : Int){
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    // Instacart Splitup Start
    //Deliveryall splitup End
    //Deliveryall_Newsplitup_end
    func route2DelAllScreen(forTrip trip: TripDataModel,ShouldPopToRoot: Bool)
    {
        
        if !(trip.order_details?.pickupLatitude.isZero ?? false),
           !(trip.order_details?.pickupLongitude.isZero ?? false){
            let preference = UserDefaults.standard
            preference.set("\(trip.order_details?.pickupLatitude),\(trip.order_details?.pickupLongitude)", forKey: PICKUP_COORDINATES)
            //preference.set(rider.pickup_latitude)
        }
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    // Instacart Splitup End
    //Deliveryall splitup start

    //Deliveryall_Newsplitup_start

    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end
    // Laundry Splitup End
    // Instacart Splitup Start
    func route2LaundryScreen(forTrip trip: TripDataModel,ShouldPopToRoot: Bool)
    {
        
        if !(trip.order_details?.pickupLatitude.isZero ?? false),
           !(trip.order_details?.pickupLongitude.isZero ?? false){
            let preference = UserDefaults.standard
            preference.set("\(trip.order_details?.pickupLatitude),\(trip.order_details?.pickupLongitude)", forKey: PICKUP_COORDINATES)
            //preference.set(rider.pickup_latitude)
        }
        
    }
   
    func route2LaundryRouteScreen(_ orderID : Int){
    }
    // Laundry Splitup Start
    // Instacart Splitup End
    func route2InstaRouteScreen(_ orderID : Int){
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Deliveryall_Newsplitup_end
    // Instacart Splitup Start
    //Deliveryall splitup End
    func route2DeliveryAllRouteScreen(_ orderID : Int){
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Gofer splitup end

    //New Delivery splitup End
    //Handy_NewSplitup_End

    //New_Delivery_splitup_End
    // Handy Splitup End

    
    func route2JobScreen(forTrip tripDetail: JobDetailModel) {
        
        guard let trip = tripDetail.getCurrentTrip() else {return}
           if !trip.pickupLat.isZero,
            !trip.pickupLng.isZero{
            let preference = UserDefaults.standard
            preference.set("\(trip.pickupLat),\(trip.pickupLng)", forKey: PICKUP_COORDINATES)
            //preference.set(rider.pickup_latitude)
        }
        //Gofer splitup start
        //Deliveryall_Newsplitup_start
        //Deliveryall splitup start
        // Laundry_NewSplitup_start
            let tripVC = ShareRouteVC.initWithStory(tripDataModel: nil,
                                                    tripId: trip.jobID,
                                                    tripStatus: trip.jobStatus)
            self.currentViewController.navigationController?.pushViewController(tripVC, animated: true)
        // Laundry_NewSplitup_end
        //delivery splitup end
        //Gofer splitup end
        //Deliveryall splitup End
        //Deliveryall_Newsplitup_end
    }
    //Deliveryall splitup start
    func routeToIncompleteJobs(businessType: BusinessType,
                               jobID: Int,
                               jobStatus : TripStatus,
                               isPool : Bool = false) {
        switch jobStatus {
        case .pending:
            print("It's Pending can't Move")
            //Deliveryall_Newsplitup_start
        case .scheduled,.beginTrip,.endTrip:
            //Gofer splitup start
         
            // Laundry_NewSplitup_start
                let tripVC = ShareRouteVC.initWithStory(tripDataModel: nil,
                                                        tripId: (isPool && jobStatus < .payment) ? 0 : jobID,
                                                        tripStatus: jobStatus)
                self.currentViewController.navigationController?.pushViewController(tripVC, animated: true)
                //Gofer splitup start

                //Handy_NewSplitup_End
                //New Delivery splitup End

                // Handy Splitup End
                //New_Delivery_splitup_End
            // InstaCart_NewSplitup_end

            //Deliveryall_Newsplitup_end


           
            // Laundry_NewSplitup_end
          

         
            //Gofer splitup end
        case .payment,.cancelled,.completed,.rating:
            switch businessType {
            case .Services,.Delivery,.Ride,.Tow:
                let propertyView =  HandyPaymentVC.initWithStory(model: nil,
                                                                 jobID: jobID,
                                                                 jobStatus: jobStatus)
                self.currentViewController.navigationController?.pushViewController(propertyView, animated: true)
            case .DeliveryAll:
                break
            default:
                print("Not a Handling Type")
            }
            
        default:
            print("Not Handled")
        }
    }
    
    
    func routeInCompleteJobs(_ trip : JobDetailModel){
//
//        switch trip.status {
//        case .rating:
//            self.route2Rating(forTrip: trip)
//        case .cancelled,.completed:
//            self.route2TripDetailsInfo(forTrip: trip)
//        case .payment:
//          self.route2Payment(forTrip: trip)
//        case .scheduled,.beginTrip,.endTrip:
//            self.route2JobScreen(forTrip: trip)
//        default:
//            print("")
//        }
        
        
    }
    
    func route2Payment(forTrip trip : JobDetailModel){
        guard let currentTrip = trip.getCurrentTrip() else { return }
        let tripView = HandyPaymentVC.initWithStory(model: trip,
                                                    jobID: currentTrip.jobID,
                                                    jobStatus: currentTrip.jobStatus)
        tripView.isFromTripPage = true
        self.currentViewController.navigationController?.pushViewController(tripView, animated: true)
    }
    func route2PaymentDel(orderID : Int, status : TripStatus){
        
        let tripView = HandyPaymentVC.initWithStory(model: nil,
                                                    jobID: orderID,
                                                    jobStatus: status)
        tripView.isFromTripPage = true
        self.currentViewController.navigationController?.pushViewController(tripView, animated: true)
    }
    func route2Rating(forTrip trip : JobDetailModel){
        guard let currentTrip = trip.getCurrentTrip() else { return }
        let propertyView =  HandyPaymentVC.initWithStory(model: trip,
                                                         jobID: currentTrip.jobID,
                                                         jobStatus: currentTrip.jobStatus)
        self.currentViewController.navigationController?.pushViewController(propertyView, animated: true)

    }
    func route2RatingDel(_ orderID: Int, _ status : TripStatus){
        
        let propertyView =  HandyPaymentVC.initWithStory(model: nil,
                                                         jobID: orderID,
                                                         jobStatus: status)
        self.currentViewController.navigationController?.pushViewController(propertyView, animated: true)

    }
    func route2TripDetailsInfo(forTrip trip : JobDetailModel){
        guard let currentTrip = trip.getCurrentTrip() else { return }
        let propertyView =  HandyPaymentVC.initWithStory(model: trip,
                                                         jobID: currentTrip.jobID,
                                                         jobStatus: currentTrip.jobStatus)
        self.currentViewController.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    
    func route_Gofer(forTrip trip : JobDetailModel){
        guard let currentTrip = trip.getCurrentTrip() else { return }
        let propertyView =  HandyPaymentVC.initWithStory(model: trip,
                                                         jobID: currentTrip.jobID,
                                                         jobStatus: currentTrip.jobStatus)
        self.currentViewController.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    // Laundry Splitup End
    // Instacart Splitup End
}

extension UIViewController {
    
}
