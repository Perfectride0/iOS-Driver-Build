//
//  APIEnums.swift
//  GoferDriver
//
//  Created by trioangle on 05/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire

enum APIEnums : String{
    case service_description = "service_description"
    case language_content = "content"
    case force_update = "check_version"
    case login = "login"
    case register = "register"
    case validateNumber = "numbervalidation"
    case checkDriverStatus = "check_status"
    case stripeCountries = "stripe_supported_country_list"
    case allCountries = "country_list"
    
    case currencyConversion = "currency_conversion"
    case getPaymentOptions = "get_payment_list"
    case getPayoutList = "get_payout_list"
    case getEssetntials = "common_data"
    case getHeatMapData = "heat_map"
    case payToAdmin = "pay_to_admin"
    case provider_bid_action = "provider_bid_action"    
    case cancelReasons = "cancel_reasons"
    case inCompleteJobs = "incomplete_job_details"
    case getInvoice = "get_invoice"
    case cashCollected = "cash_collected"
    case acceptRequest = "accept_request"
    case getServiceCategory = "get_services_category"
    case getCategoryItems = "provider_items"
    case otpVerification = "otp_verification"
    
    case driver_bank_details = "driver_bank_details"
    case updatePayoutData = "update_payout_preference"
    case getReferals = "get_referral_details"
    
    case jobWeekDetails = "weekly_job"
    case weeklyEarnings = "weekly_statement"
    case dailyEarnings = "daily_statement"
    case particularJobDetails = "particular_job"
    
    case updateDriverLocation = "updatelocation"
    case getCallerDetails = "get_caller_detail"
    case getExtraFeeOptions = "toll_reasons"
    
    case getCompletedJobs = "get_completed_jobs"
    case getPendingJobs = "get_pending_jobs"
    
    case getJobDetails = "get_job_details"
    case questionList = "question_list"
    case sendMessage = "send_message"
    case arrivedPickupNow = "arive_now"
    case beginingJobNow = "begin_job"
    case endingJobNow = "end_job"
    case get_user_vehicle_detail = "get_user_vehicle_detail"
    case addStripeCard = "add_card_details"
    case getStripeCard = "get_card_details"
    
    case updateVehicleDetails = "vehicle_details"
    case updateLanguage = "language"
    case updateUserCurrency = "update_user_currency"
    case getCurrencyList = "currency_list"
    case logout = "logout"
    case getRiderProfile = "get_rider_profile"
    case getRiderFeedbacks = "rider_feedback"
    case getEarningDetail = "earning_chart"
    case updateDeviceToken = "update_device"
    case cancelJob = "cancel_job"
    case addUpdatePayout = "add_payout"
    case deleteAccount = "delete_account"
    case deleteOtpVerification = "otp_verify_account"
    case forgotPassword = "forgotpassword"
    case getDriverRatings = "provider_rating"
    case uploadProfileImage = "upload_profile_image"
    case getPayoutDetails = "payout_details"
    case updatePayoutChanges = "payout_changes"
    case vehicleDescription = "vehicle_descriptions"
    case addUpdaeVehicle = "update_vehicle"
    case updateDefaultVehicle = "update_default_vehicle"
    case deleteVehicle = "delete_vehicle"
    //yam
    case addAmountToWallet = "add_provider_wallet"
    case getProviderProfile = "get_provider_profile"
    case updateProviderProfile = "update_provider_profile"
    case getServices = "services"
    case updateServiceItems = "update_service_items"
    case updateItemPrice = "update_item_price"
    case getGalleryImages = "get_gallery_images"
    case addGalleryImage = "add_gallery_image"
    case deleteGalleryImage = "delete_gallery_image"
    case providerAvailabilityList = "provider_availability_list"
    case updateAvailabilityList = "update_availability_list"
    case updateWorkLocation = "update_work_location"
    case bookJob = "book_job"
    case updateCurrentLocation = "update_location"
    case getJobRequest = "get_job_request"
    case cancelJobRequest = "cancel_job_request"
    case updateStatus = "update_status"
    case getJobImage = "get_job_image"
    case saveJobImage = "save_job_image"
    case deleteJobImage = "delete_job_image"
    case jobRating = "job_rating"
    case cancelScheduleJob = "cancel_schedule_job"
    case userFeedBack = "user_feedback"
    case updateNewPassword = "update_password"
    case none
    case webPayment = "web_payment"
    
    //  MARK: - DeliveryAll
    case getCompletedTrips = "get_completed_trips"
    case getPendingTrips = "get_pending_trips"
    case getDeliveryHistory = "order_delivery_history"
    case getPastDeliveryHistory = "past_delivery"
    case getTodayDeliveryHistory = "today_delivery"
    case getParticlarOrderDetail = "particular_order"
    case getDeliveryDetail = "driver_order_details"
    case getDeliveryDropOptions = "dropoff_data"
    case startDelivery = "start_order_delivery"
    case droppedDeliveryItems = "drop_off_delivery"
    case endDelivery = "complete_order_delivery"
    case pickedDeliveryItems = "confirm_order_delivery"
    case getPickupDislikeReasons = "pickup_data"
    case driver_received_order = "driver_received_order"
    case getTripDetails = "get_trip_details"
    case beginingTripNow = "begin_trip"
    case endingTripNow = "end_trip"
    case getDriverProfile = "get_driver_profile"
    case driverAcceptedOrders = "driver_accepted_orders"
    
    // MARK: - DELIVERY
    case recipientDetails = "recipient_details"
    case endRecipientDelivery = "end_recipient_delivery"

    //  MARK: - GOJEK
    case ourService = "our_service"
    case updateDriverService = "update_driver_service"
    case appleServiceId = "apple_service_id"
    
    // MARK: - Instacart
    
    case addSpecialItem = "update_order_item"
    case proceed = "proceed_order_driver"
    case countryCode = "all_country_details"
    case wayPointCompleted = "completed_waypoint"
    case wayPointStarted = "started_waypoint"

}

extension APIEnums{//Return method for API
    var method : HTTPMethod{
        switch self {
        case .getEssetntials,
             .currencyConversion,
             .addAmountToWallet,
             .getPaymentOptions,
             .updatePayoutData,
             .addUpdaeVehicle,
             .beginingJobNow,
             .endingJobNow,
             .payToAdmin,
             .deleteVehicle:
            return .post
        default:
            return .get
        }
    }
    var cacheAttribute : Bool {
        switch self {
        case .getCompletedJobs,
             .getGalleryImages,
             .userFeedBack,
             .jobWeekDetails,
             .weeklyEarnings,
             .dailyEarnings,
             .getServices,
             .getServiceCategory,
             .getCategoryItems,
             .providerAvailabilityList,
             .getParticlarOrderDetail,
             .getJobDetails:
            return true
        default:
            return false
        }
    }
    var canHandleFailureCases : Bool {
        return [APIEnums.validateNumber,
                .inCompleteJobs]
            .contains(self)
    }
}


