//
//  LangCommon.swift
//  GoferHandyProvider
//
//  Created by trioangle on 29/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation

// MARK: - LanguageContentModel
class LanguageContentModel: Codable {
    let statusCode,statusMessage ,defaultLanguage ,currentLanguage: String
    let language: [Language]
    let common: Common
    let handyman: Handyman
    let gofer: Gofer
    let goferDeliveryAll: goferdeliveryall
    let delivery: DeliveryLang
    let laundry: Laundry

    enum CodingKeys : String,CodingKey {
        case statusCode = "status_code", statusMessage = "status_message", defaultLanguage = "default_language_code", currentLanguage = "current_language", language, common
        case handyman = "Handy", gofer
        case goferDeliveryAll = "goferdeliveryall",delivery = "Delivery"
        case laundry = "Laundry"
    }
    
    init() {
        self.statusCode = ""
        self.statusMessage = ""
        self.defaultLanguage = ""
        self.currentLanguage = ""
        self.language = []
        self.common = Common()
        self.handyman = Handyman()
        self.gofer = Gofer()
        self.goferDeliveryAll = goferdeliveryall()
        self.delivery = DeliveryLang()
        self.laundry = Laundry()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.defaultLanguage = container.safeDecodeValue(forKey: .defaultLanguage)
        self.currentLanguage = container.safeDecodeValue(forKey: .currentLanguage)
        
        let langs = try container.decodeIfPresent([Language].self, forKey: .language)
        self.language = langs ?? []
        let _common = try container.decode(Common.self, forKey: .common)
        self.common = _common
        let _handy = try container.decode(Handyman.self, forKey: .handyman)
        self.handyman = _handy
        let _gofer = try container.decode(Gofer.self, forKey: .gofer)
        self.gofer = _gofer
        //self.goferDeliveryAll = goferdeliveryall()
        let _delivery = try container.decodeIfPresent(DeliveryLang.self, forKey: .delivery)
        self.delivery = _delivery ?? DeliveryLang()
        
        let _goferDelAll = try container.decodeIfPresent(goferdeliveryall.self, forKey: .goferDeliveryAll)
        self.goferDeliveryAll = _goferDelAll ?? goferdeliveryall()
        
        let laundry = try container.decodeIfPresent(Laundry.self, forKey: .laundry)
        self.laundry = laundry ?? Laundry()
        //some core logics
        
        ///set default language to session if none is available
        if UserDefaults.isNull(for: .default_language_option) {
            UserDefaults.set(self.defaultLanguage, for: .default_language_option)
        }    
    }
    //MARK:- UDF
    
    func currentLangage() -> Language?{
        self.language
            .filter({$0.key == self.currentLanguage})
            .first
    }
    func isRTLLanguage() -> Bool{
        if let currentLanguage = self.currentLangage(){
            return currentLanguage.isRTL
        }
        return false
    }
    func getBackBtnText() -> String{
        return self.isRTLLanguage() ? "I" : "e"
    }
    var locale : Locale{
        switch self.currentLangage()?.key.lowercased() {
        case "ar":
            return Locale(identifier: "ar")
        case "fa":
            return Locale(identifier: "fa")
        default:
            return Locale(identifier: "en")
        }
    }
    func semantic() -> UISemanticContentAttribute{
        return self.isRTLLanguage() ? .forceRightToLeft : .forceLeftToRight
    }
    //MARK:- for Text Alignment
    func getTextAlignment(align : NSTextAlignment) -> NSTextAlignment{
        guard self.semantic() == .forceRightToLeft else {
            return align
        }
        switch align {
        case .left:
            return .right
        case .right:
            return .left
        case .natural:
            return .natural
        default:
            return align
        }
    }
}

// MARK: - Common
class Common: Codable {
    let accept_bid,reject_bid,bid_amount_requested,bid_accepted_successfully,bid_rejected_successfully: String
    let heatMap : String
    let miles: String
    let appName : String
    let completedStatus ,passwordValidationMsg ,noDataFound ,endTripStatus,wallet_amount : String
    let beginTripStatus ,cancelledStatus ,reqStatus ,pendingStatus : String
    let sheduledStatus ,paymentStatus ,login ,register : String
    let signUp ,online ,offline ,checkStatus : String
    let totalPayout ,payStatement ,sunday ,monday : String
    let tuesday ,wednesday ,thursday ,friday : String
    let saturday ,week ,ok ,m : String
    let tu ,w ,th ,f : String
    let sa ,su : String
    let jobCancelledUSer:String
    let noData ,mostRecentPayout ,fiveStarTrips ,yourCurrentRating : String
    let noVehicleAssigned ,referral ,documents ,payout : String
    let bankDetails ,payTo ,edit ,view : String
    let signOut ,manualBookingReminder ,manualBookingCancelled ,apply : String
    let amount ,selectExtraFee ,applyExtraFee ,enterExtraFee : String
    let enterOtp ,done ,cancel ,weeklyStatement : String
    let weeklyEarnings : String
    let baseFare ,accessFee ,total ,cashCollected : String
    let bankDeposit ,dailyEarnings ,noDailyEarnings  : String
    let duration ,distance ,km ,mins : String
    let pending ,cancelReason ,writeYourComment : String
    let wrongAddressShown ,involvedInAnAccident ,minute ,minutes : String
    let cancellingRequest ,cancelled ,pleaseEnablePushNotification ,alreadyAccepted : String
    let manageHome ,loginText ,welcomeLoginText : String
    let yourJob ,tapToChange ,dontHaveAcc ,alreadyHaveAcc : String
    let tocText ,logout ,pleaseSetLocation ,of : String
    let rUSureToLogOut ,areYouSureToDelete ,deleteAnyWay ,managePayouts : String
    let cancelBooking ,arrive ,beginJob ,endJob : String
    let slideTo ,specialInstruction ,areYouSure ,sec : String
    let alreadyAcceptedBySomeone ,selectAPhoto ,takePhoto ,chooseFromLibrary : String
    let firstName ,lastName ,email ,phoneNumber : String
    let addressLineFirst ,addressLineSecond ,city ,postalCode : String
    let state ,personalInformation ,address ,message : String
    let error ,deviceHasNoCamera ,warning ,pleaseGivePermission : String
    let setLocation : String
    let uploadLimit,uploadFailed ,enRoute ,navigate ,cancelTripByDriver : String
    let cancelTrips ,hereYouCanChangeYourMap ,byClicking ,googleMap : String
    let wazeMap ,doYouWant ,pleaseInstallGoogleMapsApp ,doYouWantToAccessdirection : String
    let pleaseInstallWazeMapsApp ,networkDisconnected ,submit : String
    let pickUp ,contact ,help ,about : String
    let callsOnly ,call ,messages ,vehicleInformation : String
    let rider ,typeAMessage ,noMessagesYet ,country : String
    let currency ,bsb ,accountNumber ,accountHolderName : String
    let addressOne ,addressTwo ,address1 ,address2 : String
    let postal ,pleaseEnter ,ibanNumber ,sortCode : String
    let branchCode ,clearingCode ,transitNumber ,institutionNumber,clabe : String
    let rountingNumber ,bankName ,branchName ,bankCode : String
    let accountOwnerName ,pleaseUpdateDocument,pleaseUpdateAdditionalDocument ,gender ,male : String
    let female ,payouts ,choosePhoto ,noCamera : String
    let alert ,cameraAccess ,allowCamera ,setupPayout : String
    let uber ,add ,emailID ,pleaseEnterValidEmail : String
    let swiftCode ,common4Required ,paid ,waitingForPayment : String
    let proceed ,success ,riderPaid ,paymentDetails : String
    let paypalEmail ,save ,addNewPayout ,account : String
    let payment ,addPayoutMethod ,trip ,history : String
    let payStatements ,changeCreditCard ,addCreditCard ,pleaseEnterValidCard : String
    let pay ,change ,enterTheAmount ,referralAmount : String
    let applied ,addCard ,yourPayTo ,getUpto : String
    let forEveryFriend ,signUpGet ,yourReferralCode ,yourInviteCode : String

    let forEveryFriendJobs ,shareMyCode ,referralCopied ,referralCodeCopied : String
    let useMyReferral ,startYourJourney ,declineServiceRequest ,noReferralsYet : String
    let friendsIncomplete ,friendsCompleted ,earned ,referralExpired : String
    let cash ,paypal ,promoCode ,promotions : String
    let wallet ,stripeDetails ,addressKana ,addressKanji : String
    let yes ,no ,pleaseEnterExtraFare ,pleaseSelectAnOption : String
    let pleaseEnterYourComment ,stripe ,defaults ,signIn : String
    let close ,password : String
    let forgotPassword ,enablePushNotify ,resetPassword ,confirmPassword : String
    let selectVehicle ,chooseVehicle ,vehicleName ,vehicleNumber : String
    let continues ,selectCountry ,search ,uploadDoc : String
    let verify ,toDriveWith ,vehicleMust ,licenseBack : String
    let licenseFront ,licenseInsurance ,licenseRC ,licensePermit : String
    let docSection ,takeYourPhoto ,readAllDetails ,agreeTerms : String
    let termsConditions ,privacyPolicy ,connectionLost ,tryAgain : String
    let tapToAdd ,mobileno ,refCode ,likeResetPassword : String
    let mobile ,mobileVerify : String
    let enterMobileno ,resendOtp ,smsMobileVerify ,didntReceiveOtp : String
    let otpAgain ,nameOfBank ,bankLocation ,pleaseGiveRating : String
    let passwordMismatch ,credentialsDontLook ,nameEmail ,beginTrip : String
    let endTrip ,confirmArrived ,newVersionAvail ,updateApp : String
    let visitAppStore ,internalServerError ,dropOff ,timelyEarnings : String
    let quantity ,clientNotInitialized ,jsonSerialaizationFailed ,noInternetConnection : String
    let driverEarnings ,onlinePay ,connecting ,ringing : String
    let callEnded ,placehodlerMail ,enterValidOtp : String
    let locationService ,tracking ,camera ,photoLibrary : String
    let service ,app ,pleaseEnable ,requires : String
    let common7For ,functionality ,successFullyUpdated ,enterYourOldPassword : String
    let enterYourNewPassword ,enterYourConformPassword ,confirm ,home : String

    let trips ,earnings ,ratings ,acount : String
    let swipeTo ,acceptingRequest ,requestStatus ,ratingStatus : String
    let scheduledStatus ,microphoneSerivce ,inAppCall ,choose : String
    let choosePaymentMethod ,delete ,whatLike2_Do ,update : String
    let makeDefault ,min ,hr ,hrs : String
    let language ,selectLanguage ,legalDocuments,additionalDocuments ,active : String
    let gettingLocationTryAgain ,settings ,goOnline ,goOffline : String
    let manageVehicle ,manageDocuments ,addEarnings ,addPayouts : String
    let editVehicle ,addVehicle ,allProgressDiscard ,make : String
    let model ,year : String
    let license ,color ,selectMake ,selectModel : String
    let selectYear ,pleaseSelectMake ,expiryDate ,pleaseSelectOption : String
    let sureToDeleteVehicle ,approved ,rejected ,addDocument : String
    let busyTryAgain ,inTripComplete ,searchLocation ,yourOnlineGoOffline : String
    let vehicleIsNotActive ,addNew ,person ,persons : String
    let manageServices,remove,updatedSuccessfully : String
    let rate,maximum,hours,per,minimum,fare,kilometer,skip : String
    let pullToRefresh,status,number : String

    
    let paymentMethods : String
    let ssnLastDigit :String
    let kanaAddress1:String
    let kanaAddress2:String
    let kanaCity :String
    let kanaState: String
    let kanaPostal:String
    let japan:String
    let driver:String
    let inActive :String
    let serverIssueError :String
    let dayLeftToComplete :String
    let daysLeftToComplete  :String
   
    let myProfile,editProfile,updateInformation,serviceDescription,changePassword :String
    let paymentType : String
    let priceType: String
    let ratingUpdatedSuccess: String
    let category,subCategory,fareType : String
    let provideYourFeedback : String
    let selectAll : String
    let deSelectAll : String
    let pleaseGivePermissionToAccessCamera : String
    let welcomeToThe : String
    let goferHandyServiceProviderApp : String
    let payToAdmin : String
    let thanksText : String
    let jobRequestedDate : String
    let support : String
    let notAValidData : String
    let fromHere : String
    let minimumFare : String
    let perMins,perKm : String
    let baseFareValidatonMsg : String
    let quantityValidatonMsg : String
    let minimumHourValidatonMsg : String
    let minimumFareValidatonMsg : String
    let perMinFareValidatonMsg : String
    let perKmFareValidatonMsg : String
    let howWasYourJob : String
    let setServices : String
    let setAvailability : String
    let manageAvailability : String
    let setBothAvailabilityAndServices : String
    let locationPermissionDescription : String
    let toAccessYourLocation : String
    let iAgreeToThe : String
    let and : String
    let addProviderProof : String
    let cancelAccountCreation : String
    let infoNotSaved : String
    let forceUpdate : String
    let imageSelected : String
    let imagesSelected : String
    let requestAcceptMsg : String
    let hello : String
    let haveAnAccount : String
    let loginToContinue : String
    let welcomeBack : String
    let continueWithPhone : String
    let looking_for_user : String
    let font : String
    let theme : String
   
    let businessType : String
    let orderCompleted : String
    let changeTheme : String
    let changeFont : String
    let pleaseEnterYourOldPassword : String
    let pleaseEnterYourNewPassword : String
    let pleaseEnterYourConfirmPassword : String
    let whatYouProvide : String
    let expired : String
    let completed : String
    let cashTrip : String
    let cancelTrip : String
    let sendMessage : String
    let scheduleBooking : String
    let manualBooking : String
    let onlinepayment: String
    let VehicleType:String
    let promo : String
    
    let continueText : String
    let deleteAccount : String
    let doyouwantdelete : String
    let pleasemakesuredelete : String
    let deleteotpmessage : String
    let accountdeletion : String
    let passwordWarn : String
    let minChar : String
    let maxChar : String
    let enterTheBidAmountForTheService : String
    let vehicleDetails : String
    let addAmount : String

    let dropoffLocation,enter_service_description,newDescription: String
    let fixed : String
    let hourly : String
    let time_distance : String
    let registration : String
    let engineSize : String
    let weight : String
    var engineCode : String
    let transmission : String
    let vehicleRecovery : String
    let vehiclename : String
    let noOfStops : String
    let startedAtStop : String
    let reachedAtStop : String
    let areyousureyouwanttodeclinethisrequest : String

    enum CodingKeys : String,CodingKey {
        case heatMap = "heat_map"
        case miles = "miles"
       case wallet_amount = "wallet_amount"
        case appName = "app_name"
        case completedStatus = "completed_status", passwordValidationMsg = "password_validation_msg", noDataFound = "no_data_found", endTripStatus = "end_trip_status", beginTripStatus = "begin_trip_status", cancelledStatus = "cancelled_status", reqStatus = "req_status", pendingStatus = "pending_status", sheduledStatus = "sheduled_status", paymentStatus = "payment_status", login, register
        case signUp = "sign_up", online, offline
        case checkStatus = "check_status", totalPayout = "total_payout", payStatement = "pay_statement", sunday, monday, tuesday, wednesday, thursday, friday, saturday, week, ok, m, tu, w, th, f, sa, su
        case noData = "no_data", mostRecentPayout = "most_recent_payout", fiveStarTrips = "five_star_trips", yourCurrentRating = "your_current_rating", noVehicleAssigned = "no_vehicle_assigned", referral, documents, payout
        case bankDetails = "bank_details", payTo = "pay_to", edit, view
        case signOut = "sign_out", manualBookingReminder = "manual_booking_reminder", manualBookingCancelled = "manual_booking_cancelled", apply, amount
        case selectExtraFee = "select_extra_fee", applyExtraFee = "apply_extra_fee", enterExtraFee = "enter_extra_fee_description", enterOtp = "enter_otp", done, cancel
        case weeklyStatement = "weekly_statement", baseFare = "base_fare", accessFee = "access_fee", total
        case cashCollected = "cash_collected", bankDeposit = "bank_deposit", dailyEarnings = "daily_earnings", noDailyEarnings = "no_daily_earnings", duration, distance, km, mins
        case rejected
        case addDocument = "add_document", busyTryAgain = "busy_try_again", inTripComplete = "in_trip_complete", searchLocation = "search_location", yourOnlineGoOffline = "your_online_go_offline", vehicleIsNotActive = "vehicle_is_not_active", addNew = "add_new", person, persons
        case manageServices = "manage_services", manageHome = "manage_home", loginText = "login_text", welcomeLoginText = "welcome_login_text", yourJob = "your_job", tapToChange = "tap_to_change", dontHaveAcc = "dont_have_acc", alreadyHaveAcc = "already_have_acc", tocText = "toc_text", logout
        case pleaseSetLocation = "please_set_location", of
        case rUSureToLogOut = "r_u_sure_to_log_out", areYouSureToDelete = "are_you_sure_to_delete", deleteAnyWay = "delete_any_way", managePayouts = "manage_payouts", cancelBooking = "cancel_booking", arrive
        case beginJob = "begin_job", endJob = "end_job", slideTo = "slide_to", specialInstruction = "special_instruction", areYouSure = "are_you_sure", sec
        case pending
        case cancelReason = "cancel_reason", writeYourComment = "write_your_comment", wrongAddressShown = "wrong_address_shown", involvedInAnAccident = "involved_in_an_accident", minute, minutes
        case cancellingRequest = "cancelling_request", cancelled
        case pleaseEnablePushNotification = "please_enable_push_notification", alreadyAccepted = "already_accepted", alreadyAcceptedBySomeone = "already_accepted_by_someone", selectAPhoto = "select_a_photo", takePhoto = "take_photo", chooseFromLibrary = "choose_from_library", firstName = "first_name", lastName = "last_name", email
        case phoneNumber = "phone_number", addressLineFirst = "address_line_first", addressLineSecond = "address_line_second", city
        case postalCode = "postal_code", state
        case personalInformation = "personal_information", address, message, error
        case deviceHasNoCamera = "device_has_no_camera", warning
        case pleaseGivePermission = "please_give_permission", uploadFailed = "upload_failed", enRoute = "en_route", navigate
        case cancelTripByDriver = "cancel_trip_by_driver", cancelTrips = "cancel_trips", hereYouCanChangeYourMap = "here_you_can_change_your_map", byClicking = "by_clicking", googleMap = "google_map", wazeMap = "waze_map", doYouWant = "do_you_want", pleaseInstallGoogleMapsApp = "please_install_google_maps_app", doYouWantToAccessdirection = "do_you_want_to_accessdirection", pleaseInstallWazeMapsApp = "please_install_waze_maps_app", networkDisconnected = "network_disconnected", submit
        case pickUp = "pick_up", contact, help, about
        case callsOnly = "calls_only", call, messages
        case vehicleInformation = "vehicle_information", rider
        case typeAMessage = "type_a_message", noMessagesYet = "no_messages_yet", country, currency, bsb
        case accountNumber = "account_number", accountHolderName = "account_holder_name", addressOne = "address_one", addressTwo = "address_two", address1 = "address_1", address2 = "address_2", postal
        case pleaseEnter = "please_enter", ibanNumber = "iban_number", sortCode = "sort_code", branchCode = "branch_code", clearingCode = "clearing_code", transitNumber = "transit_number", institutionNumber = "institution_number",clabe, rountingNumber = "rounting_number", bankName = "bank_name", branchName = "branch_name", bankCode = "bank_code", accountOwnerName = "account_owner_name", pleaseUpdateDocument = "please_update_document",pleaseUpdateAdditionalDocument = "please_update_additional_document", gender, male, female, payouts
        case jobCancelledUSer = "job_declined_by_User"
        case choosePhoto = "choose_photo", noCamera = "no_camera", alert
        case cameraAccess = "camera_access", allowCamera = "allow_camera", setupPayout = "setup_payout", uber, add
        case emailID = "email_id", pleaseEnterValidEmail = "please_enter_valid_email", swiftCode = "swift_code", common4Required = "required", paid
        case waitingForPayment = "waiting_for_payment", proceed, success
        case riderPaid = "rider_paid", paymentDetails = "payment_details", paypalEmail = "paypal_email", save
        case addNewPayout = "add_new_payout", account, payment
        case addPayoutMethod = "add_payout_method", trip = "job", history
        case payStatements = "pay_statements", changeCreditCard = "change_credit_card", addCreditCard = "add_credit_card", pleaseEnterValidCard = "please_enter_valid_card", pay, change
        case enterTheAmount = "enter_the_amount", referralAmount = "referral_amount", applied
        case addCard = "add_card", yourPayTo = "your_pay_to", getUpto = "get_upto", forEveryFriend = "for_every_friend", signUpGet = "sign_up_get", yourReferralCode = "your_referral_code", yourInviteCode = "your_invite_code", forEveryFriendJobs = "for_every_friend_jobs", shareMyCode = "share_my_code", referralCopied = "referral_copied", referralCodeCopied = "referral_code_copied", useMyReferral = "use_my_referral", startYourJourney = "start_your_journey", declineServiceRequest = "decline_service_request", noReferralsYet = "no_referrals_yet", friendsIncomplete = "friends_incomplete", friendsCompleted = "friends_completed", earned
        case referralExpired = "referral_expired", cash, paypal
        case promoCode = "promo_code", promotions, wallet
        case stripeDetails = "stripe_details", addressKana = "address_kana", addressKanji = "address_kanji", yes, no
        case pleaseEnterExtraFare = "please_enter_extra_fare", pleaseSelectAnOption = "please_select_an_option", pleaseEnterYourComment = "please_enter_your_comment", stripe, defaults
        case signIn = "sign_in", close, password
        case forgotPassword = "forgot_password", enablePushNotify = "enable_push_notify", resetPassword = "reset_password", confirmPassword = "confirm_password", selectVehicle = "select_vehicle", chooseVehicle = "choose_vehicle", vehicleName = "vehicle_name", vehicleNumber = "vehicle_number", continues
        case selectCountry = "select_country", search
        case uploadDoc = "upload_doc", verify
        case toDriveWith = "to_drive_with", vehicleMust = "vehicle_must", licenseBack = "license_back", licenseFront = "license_front", licenseInsurance = "license_insurance", licenseRC = "license_rc", licensePermit = "license_permit", docSection = "doc_section", takeYourPhoto = "take_your_photo", readAllDetails = "read_all_details", agreeTerms = "agree_terms", termsConditions = "terms_conditions", privacyPolicy = "privacy_policy", connectionLost = "connection_lost", tryAgain = "try_again", tapToAdd = "tap_to_add", mobileno
        case refCode = "ref_code", likeResetPassword = "like_reset_password", mobile
        case mobileVerify = "mobile_verify", enterMobileno = "enter_mobileno", resendOtp = "resend_otp", smsMobileVerify = "sms_mobile_verify", didntReceiveOtp = "didnt_receive_otp", otpAgain = "otp_again", nameOfBank = "name_of_bank", bankLocation = "bank_location", pleaseGiveRating = "please_give_rating", passwordMismatch = "password_mismatch", credentialsDontLook = "credentials_dont_look", nameEmail = "name_email", beginTrip = "begin_trip", endTrip = "end_trip", confirmArrived = "confirm_arrived", newVersionAvail = "new_version_available", updateApp = "update_app", visitAppStore = "visit_app_store", internalServerError = "internal_server_error", dropOff = "drop_off", timelyEarnings = "timely_earnings", quantity
        case clientNotInitialized = "client_not_initialized", jsonSerialaizationFailed = "json_serialaization_failed", noInternetConnection = "no_internet_connection", driverEarnings = "total_earnings", onlinePay = "online_pay", connecting, ringing
        case callEnded = "call_ended"
        case placehodlerMail = "placehodler_mail", enterValidOtp = "enter_valid_otp", locationService = "location_service", tracking, camera
        case photoLibrary = "photo_library", service, app
        case pleaseEnable = "please_enable", requires
        case common7For = "for", functionality
        case successFullyUpdated = "success_fully_updated", enterYourOldPassword = "enter_your_old_password", enterYourNewPassword = "enter_your_new_password", enterYourConformPassword = "enter_your_conform_password", confirm, home, trips = "jobs", earnings, ratings, acount
        case swipeTo = "swipe_to", acceptingRequest = "accepting_request", requestStatus = "request_status", ratingStatus = "rating_status", scheduledStatus = "scheduled_status", microphoneSerivce = "microphone_serivce", inAppCall = "in_app_call", choose
        case choosePaymentMethod = "choose_payment_method", delete
        case whatLike2_Do = "what_like_2_do", update = "update"
        case makeDefault = "make_default", min, hr, hrs, language
        case selectLanguage = "select_language", legalDocuments = "legal_documents",additionalDocuments = "additional_documents", active
        case gettingLocationTryAgain = "getting_location_try_again", settings
        case goOnline = "go_online", goOffline = "go_offline", manageVehicle = "manage_vehicle", manageDocuments = "manage_documents", addEarnings = "add_earnings", addPayouts = "add_payouts", editVehicle = "edit_vehicle", addVehicle = "add_vehicle", allProgressDiscard = "all_progress_discard", make, model, year, license, color
        case selectMake = "select_make", selectModel = "select_model", selectYear = "select_year", pleaseSelectMake = "please_select_make", expiryDate = "expiry_date", pleaseSelectOption = "please_select_option", sureToDeleteVehicle = "sure_to_delete_vehicle", approved,remove,updatedSuccessfully = "updated_successfully",rate,maximum,hours,per,minimum,fare,kilometer,skip
        case pullToRefresh = "pull_to_refresh",status,number

        
        
        case paymentMethods = "payment_methods" //"Payment Methods"
        case ssnLastDigit = "ssn_last_digit"   //"SSN Last 4 Digits"
        case kanaAddress1 = "kana_address1" //"KanaAddress1"
        case kanaAddress2 = "kana_address2" //"KanaAddress2"
        case kanaCity = "kana_city" // "KanaCity"
        case kanaState = "kana_state" // "KanaState / Province"
        case kanaPostal = "kana_postal_code" // "KanaPostal Code"
        case japan = "japan" // "Japan"
        case driver = "driver"  //"Driver"
        case inActive = "in_active" // "Inactive"
        case serverIssueError = "service_issue_error" // "Server issue, Please try again."
        case dayLeftToComplete = "day_left_to_complete" // "day left | Need to Complete"
        case daysLeftToComplete = "days_left_to_complete"  // "days left | Need to Complete"
        case myProfile = "my_profile",editProfile = "edit_profile",updateInformation = "update_information" ,serviceDescription = "service_description",changePassword = "change_password"
        
        case paymentType = "payment_type" // "Payment Type"
        case priceType = "price_type" // "Price Type"
        case ratingUpdatedSuccess = "rating_updated_successfully" // "Rating Updated Successfully"
        case category,subCategory = "sub_category",fareType = "fare_type"

        case provideYourFeedback = "provide_your_feedback"
        case selectAll = "select_all"
        case deSelectAll = "deselect_all"
        case pleaseGivePermissionToAccessCamera = "please_give_access_to_access_camera"
        case welcomeToThe = "welcome_text"
        case goferHandyServiceProviderApp = "goferhandy_service_provider_app"
        case payToAdmin = "pay_to_admin"
        case thanksText = "thanks_text"
        case jobRequestedDate = "job_requested_date"
        case support
        case notAValidData = "not_a_valid_data"
        case fromHere = "from_here"
        case minimumFare = "minimum_fare"
        case perMins = "per_mins",perKm = "per_kilometer"
        case baseFareValidatonMsg = "please_add_base_fare"
        case quantityValidatonMsg = "please_add_quantity"
        case minimumHourValidatonMsg = "please_add_minimum_hour"
        case minimumFareValidatonMsg = "please_add_minimum_fare"
        case perMinFareValidatonMsg = "please_add_per_min_fare"
        case perKmFareValidatonMsg = "please_add_per_km_fare"
        case howWasYourJob = "how_was_your_job"
        case setServices = "set_services"
        case setAvailability = "set_availability"
        case manageAvailability = "manage_availability"
        case setBothAvailabilityAndServices = "set_both_availability_and_services"
        case locationPermissionDescription = "location_permission_description1"
        case toAccessYourLocation = "to_access_your_a"
        case iAgreeToThe = "sigin_terms1"
        case and = "sigin_terms3"
        case addProviderProof = "add_provider_proof"
        case cancelAccountCreation = "cancel_acc_creation",infoNotSaved = "cancelaccount_msg"
        case forceUpdate = "force_update",uploadLimit = "upload_limit",imageSelected = "image_selected",imagesSelected = "images_selected"
        case requestAcceptMsg = "request_accept_msg"
        case hello
        case setLocation = "set_location"
        case haveAnAccount = "already_have_an_account_sign_in"
        case loginToContinue = "login_to_continue"
        case welcomeBack = "welcome_back"
        case continueWithPhone = "continue_with_phone_number"
        case looking_for_user = "looking_for_user"
        case weeklyEarnings = "weekly_earnings"
        case font = "font"
        case theme = "theme"
        case businessType = "business_Type"
        case orderCompleted = "order_completed"
        case changeTheme = "change_theme"
        case changeFont = "change_font"
        case pleaseEnterYourOldPassword = "please_enter_old_password"
        case pleaseEnterYourNewPassword = "please_enter_new_password"
        case pleaseEnterYourConfirmPassword = "please_enter_confirm_password"
        case whatYouProvide = "what_you_provide"
        case expired = "expired"
        case completed = "completed"
        case cashTrip = "cash_trip"
        case cancelTrip = "cancel_trip"
        case sendMessage = "send_message"
        case scheduleBooking = "schedule_booking"
        case manualBooking = "manual_booking"
        case onlinepayment = "online_payment"
        case VehicleType = "vehicleType"
        case promo = "promo"
        case continueText = "continue_text"
        case deleteAccount = "delete_account"
        case doyouwantdelete = "do_you_want_delete"
        case pleasemakesuredelete = "please_make_sure_delete"
        case deleteotpmessage = "delete_otp_message"
        case accountdeletion = "account_deletion"
        case passwordWarn = "passwordWarn"
        case minChar = "minChar"
        case maxChar = "maxChar"

        case dropoffLocation = "dropoffLocation"
        case enter_service_description = "enter_service_description"
      case newDescription = "description"
        case accept_bid = "accept_bid"
        case reject_bid = "reject_bid"
        case bid_amount_requested = "bid_amount_requested"
        case bid_accepted_successfully = "bid_accepted_successfully"
        case bid_rejected_successfully = "bid_rejected_successfully"
        case enterTheBidAmountForTheService = "enter_the_bid_amount_for_the_service"
        case vehicleDetails = "vehicle_details"
        case addAmount = "add_amount"
        case fixed = "fixed"
        case hourly = "hourly"
        case time_distance = "time_distance"
        case weight = "weight"
        case transmission = "transmission"
        case engineCode = "engine_code"
        case engineSize = "engine_size"
        case registration = "registration"
        case vehicleRecovery = "vehicle_recovery"
        case vehiclename = "vehicle_Name"
        case noOfStops = "no_of_stops"
        case startedAtStop = "startat"
        case reachedAtStop = "dropat"
        case areyousureyouwanttodeclinethisrequest = "are_you_sure_you_want_to_decline_this_request"
        
    }

    init() {
        self.enter_service_description = ""
        self.newDescription = ""
        self.heatMap = ""
        self.promo = ""
        self.appName = ""
        self.completedStatus = ""
        self.passwordValidationMsg  = ""
        self.noDataFound  = ""
        self.endTripStatus  = ""
        self.beginTripStatus  = ""
        self.cancelledStatus  = ""
        self.reqStatus  = ""
        self.pendingStatus  = ""
        self.sheduledStatus  = ""
        self.paymentStatus  = ""
        self.login = ""
        self.register   = ""
        self.signUp  = ""
        self.online   = ""
        self.offline   = ""
        self.checkStatus  = ""
        self.totalPayout  = ""
        self.payStatement  = ""
        self.sunday =  ""
        self.monday = ""
        self.tuesday = ""
        self.wednesday = ""
        self.thursday = ""
        self.friday = ""
        self.saturday = ""
        self.week = ""
        self.ok = ""
        self.m =  ""
        self.tu =  ""
        self.w =  ""
        self.th =  ""
        self.f =  ""
        self.sa =  ""
        self.su =  ""
        self.noData  =  ""
        self.mostRecentPayout  =  ""
        self.fiveStarTrips  =  ""
        self.yourCurrentRating  =  ""
        self.noVehicleAssigned  =  ""
        self.referral =  ""
        self.documents =  ""
        self.payout =  ""
        self.bankDetails  =  ""
        self.payTo  =  ""
        self.edit =  ""
        self.view =  ""
        self.signOut  =  ""
        self.manualBookingReminder  =  ""
        self.manualBookingCancelled  =  ""
        self.apply =  ""
        self.amount =  ""
        self.selectExtraFee  =  ""
        self.applyExtraFee  =  ""
        self.enterExtraFee  =  ""
        self.enterOtp  =  ""
        self.done =  ""
        self.cancel =  ""
        self.weeklyStatement  =  ""
        self.baseFare  =  ""
        self.accessFee  =  ""
        self.total =  ""
        self.cashCollected  =  ""
        self.bankDeposit  =  ""
        self.dailyEarnings  =  ""
        self.noDailyEarnings  =  ""
        self.duration =  ""
        self.distance =  ""
        self.km =  ""
        self.mins =   ""
        self.rejected =  ""
        self.addDocument  =  ""
        self.busyTryAgain  =  ""
        self.inTripComplete  =  ""
        self.searchLocation  =  ""
        self.yourOnlineGoOffline  =  ""
        self.vehicleIsNotActive  =  ""
        self.addNew  = ""
        self.person = ""
        self.persons = ""
        self.manageServices  =  ""
        self.manageHome  = ""
        self.loginText  = ""
        self.welcomeLoginText  =  ""
        self.yourJob  = ""
        self.tapToChange  = ""
        self.dontHaveAcc  = ""
        self.alreadyHaveAcc  =  ""
        self.tocText  = ""
        self.logout = ""
        self.pleaseSetLocation  =  ""
        self.of = ""
        self.rUSureToLogOut  =  ""
        self.areYouSureToDelete  =  ""
        self.deleteAnyWay  =  ""
        self.managePayouts  =  ""
        self.cancelBooking  =  ""
        self.arrive = ""
        self.beginJob  = ""
        self.endJob  = ""
        self.slideTo  = ""
        self.specialInstruction  =  ""
        self.areYouSure  = ""
        self.sec = ""
        self.pending = ""
        self.cancelReason  =  ""
        self.writeYourComment  =  ""
        self.wrongAddressShown  =  ""
        self.involvedInAnAccident  =  ""
        self.minute = ""
        self.minutes = ""
        self.cancellingRequest  =  ""
        self.cancelled = ""
        self.pleaseEnablePushNotification  =  ""
        self.alreadyAccepted  =  ""
        self.alreadyAcceptedBySomeone  =  ""
        self.selectAPhoto  =  ""
        self.takePhoto  = ""
        self.chooseFromLibrary  =  ""
        self.firstName  = ""
        self.lastName  = ""
        self.email = ""
        self.phoneNumber  = ""
        self.addressLineFirst  =  ""
        self.addressLineSecond  =  ""
        self.city = ""
        self.postalCode  = ""
        self.state = ""
        self.personalInformation  =  ""
        self.address = ""
        self.message = ""
        self.error = ""
        self.deviceHasNoCamera  =  ""
        self.warning = ""
        self.pleaseGivePermission  =  ""
        self.uploadFailed  =  ""
        self.enRoute  = ""
        self.navigate = ""
        self.cancelTripByDriver  =  ""
        self.cancelTrips  = ""
        self.hereYouCanChangeYourMap  =  ""
        self.byClicking  = ""
        self.googleMap  = ""
        self.wazeMap  = ""
        self.doYouWant  = ""
        self.pleaseInstallGoogleMapsApp  = ""
        self.doYouWantToAccessdirection  = ""
        self.pleaseInstallWazeMapsApp  =  ""
        self.networkDisconnected  =  ""
        self.submit = ""
        self.pickUp  = ""
        self.contact = ""
        self.help = ""
        self.about = ""
        self.callsOnly  = ""
        self.call = ""
        self.messages = ""
        self.vehicleInformation  =  ""
        self.rider = ""
        self.typeAMessage  =  ""
        self.noMessagesYet  =  ""
        self.country = ""
        self.currency = ""
        self.bsb = ""
        self.accountNumber  =  ""
        self.accountHolderName  =  ""
        self.addressOne  = ""
        self.addressTwo  = ""
        self.address1  = ""
        self.address2  = ""
        self.postal = ""
        self.pleaseEnter  = ""
        self.ibanNumber  = ""
        self.sortCode  = ""
        self.branchCode  = ""
        self.clearingCode  =  ""
        self.transitNumber  =  ""
        self.institutionNumber  =  ""
        self.clabe = ""
        self.rountingNumber  =  ""
        self.bankName  = ""
        self.branchName  = ""
        self.bankCode  = ""
        self.accountOwnerName  =  ""
        self.pleaseUpdateDocument  =  ""
        self.pleaseUpdateAdditionalDocument  =  ""
        self.jobCancelledUSer = ""
        self.gender = ""
        self.male = ""
        self.female = ""
        self.payouts = ""
        self.choosePhoto  = ""
        self.noCamera  = ""
        self.alert = ""
        self.cameraAccess  =  ""
        self.allowCamera  = ""
        self.setupPayout  = ""
        self.uber = ""
        self.add = ""
        self.emailID  = ""
        
        self.pleaseEnterValidEmail =  ""
        self.swiftCode = ""
        self.common4Required =  ""
        self.paid = ""
        self.waitingForPayment =  ""
        self.proceed = ""
        self.success = ""
        self.riderPaid = ""
        self.paymentDetails =  ""
        self.paypalEmail = ""
        self.save = ""
        self.addNewPayout =  ""
        self.account = ""
        self.payment = ""
        self.addPayoutMethod =  ""
        self.trip = ""
        self.history = ""
        self.payStatements =  ""
        self.changeCreditCard =  ""
        self.addCreditCard =  ""
        self.pleaseEnterValidCard =  ""
        self.pay = ""
        self.change = ""
        self.enterTheAmount =  ""
        self.referralAmount =  ""
        self.applied = ""
        self.addCard = ""
        self.yourPayTo = ""
        self.getUpto = ""
        self.forEveryFriend =  ""
        self.signUpGet = ""
        self.yourReferralCode =  ""
        self.yourInviteCode =  ""
        
        self.forEveryFriendJobs =  ""
        self.shareMyCode = ""
        self.referralCopied =  ""
        self.referralCodeCopied =  ""
        self.useMyReferral =  ""
        self.startYourJourney =  ""
        self.declineServiceRequest =  ""
        self.noReferralsYet =  ""
        self.friendsIncomplete =  ""
        self.friendsCompleted =  ""
        self.earned = ""
        self.referralExpired =  ""
        self.cash = ""
        self.paypal = ""
        self.promoCode = ""
        self.promotions = ""
        self.wallet = ""
        self.stripeDetails =  ""
        self.addressKana = ""
        self.addressKanji =  ""
        self.yes = ""
        self.no = ""
        self.pleaseEnterExtraFare =  ""
        self.pleaseSelectAnOption =  ""
        self.pleaseEnterYourComment =  ""
        self.stripe = ""
        self.defaults = ""
        self.signIn = ""
        self.close = ""
        self.password = ""
        self.forgotPassword =  ""
        self.enablePushNotify =  ""
        self.resetPassword =  ""
        self.confirmPassword =  ""
        self.selectVehicle =  ""
        self.chooseVehicle =  ""
        self.vehicleName = ""
        self.vehicleNumber =  ""
        self.continues = ""
        self.selectCountry =  ""
        self.search = ""
        self.uploadDoc = ""
        self.verify = ""
        self.toDriveWith = ""
        
        
        self.vehicleMust = ""
        self.licenseBack = ""
        self.licenseFront =  ""
        self.licenseInsurance =  ""
        self.licenseRC = ""
        self.licensePermit =  ""
        self.docSection = ""
        self.takeYourPhoto =  ""
        self.readAllDetails =  ""
        self.agreeTerms = ""
        self.termsConditions =  ""
        self.privacyPolicy =  ""
        self.connectionLost =  ""
        self.tryAgain = ""
        self.tapToAdd = ""
        self.mobileno = ""
        self.refCode = ""
        self.likeResetPassword =  ""
        self.mobile = ""
        self.mobileVerify =  ""
        self.enterMobileno =  ""
        self.resendOtp = ""
        self.smsMobileVerify =  ""
        self.didntReceiveOtp =  ""
        self.otpAgain = ""
        self.nameOfBank = ""
        self.bankLocation =  ""
        self.pleaseGiveRating =  ""
        self.passwordMismatch =  ""
        self.credentialsDontLook =  ""
        self.nameEmail = ""
        self.beginTrip = ""
        self.endTrip = ""
        self.confirmArrived =  ""
        self.newVersionAvail =  ""
        self.updateApp = ""
        self.visitAppStore =  ""
        self.internalServerError =  ""
        self.dropOff  = ""
        self.timelyEarnings  = ""
        self.quantity  = ""
        self.clientNotInitialized  = ""
        self.jsonSerialaizationFailed  = ""
        self.noInternetConnection  = ""
        self.driverEarnings  = ""
        self.onlinePay  = ""
        self.connecting  = ""
        self.ringing  = ""
        self.callEnded  = ""
        self.placehodlerMail  = ""
        self.enterValidOtp  = ""
        self.locationService  = ""
        self.tracking  = ""
        self.camera  = ""
        self.photoLibrary  = ""
        self.service  = ""
        self.app  = ""
        self.pleaseEnable  = ""
        self.requires  = ""
        self.common7For  = ""
        self.functionality  = ""
        self.successFullyUpdated  = ""
        self.enterYourOldPassword  = ""
        self.enterYourNewPassword  = ""
        self.enterYourConformPassword  = ""
        self.confirm  = ""
        self.home  = ""
        self.trips  = ""
        self.earnings  = ""
        self.ratings  = ""
        self.acount  = ""
        self.swipeTo  = ""
        self.acceptingRequest  = ""
        self.requestStatus  = ""
        self.ratingStatus  = ""
        self.scheduledStatus  = ""
        self.microphoneSerivce  = ""
        self.inAppCall  = ""
        self.choose  = ""
        self.choosePaymentMethod  = ""
        self.delete  = ""
        self.whatLike2_Do  = ""
        self.update  = ""
        self.makeDefault  = ""
        self.min  = ""
        self.hr  = ""
        self.hrs  = ""
        self.language  = ""
        self.selectLanguage  = ""
        self.legalDocuments  = ""
        self.additionalDocuments  = ""
        self.active  = ""
        self.gettingLocationTryAgain  = ""
        self.settings  = ""
        self.goOnline  = ""
        self.goOffline  = ""
        self.manageVehicle  = ""
        self.manageDocuments  = ""
        self.addEarnings  = ""
        self.addPayouts  = ""
        self.editVehicle  = ""
        self.addVehicle  = ""
        self.allProgressDiscard  = ""
        self.make  = ""
        self.model  = ""
        self.year  = ""
        self.license  = ""
        self.color  = ""
        self.selectMake  = ""
        self.selectModel  = ""
        self.selectYear  = ""
        self.pleaseSelectMake  = ""
        self.expiryDate  = ""
        self.pleaseSelectOption  = ""
        self.sureToDeleteVehicle  = ""
        self.approved  = ""
        self.remove  = ""
        self.updatedSuccessfully  = ""
        self.rate  = ""
        self.maximum  = ""
        self.hours  = ""
        self.per  = ""
        self.minimum  = ""
        self.fare  = ""
        self.kilometer  = ""
        self.skip  = ""
        self.pullToRefresh  = ""
        self.status  = ""
        self.number  = ""
        self.paymentMethods  = ""
        self.ssnLastDigit  = ""
        self.kanaAddress1  = ""
        self.kanaAddress2  = ""
        self.kanaCity  = ""
        self.kanaState  = ""
        self.kanaPostal  = ""
        self.japan  = ""
        self.driver  = ""
        self.inActive  = ""
        self.serverIssueError  = ""
        self.dayLeftToComplete  = ""
        self.daysLeftToComplete  = ""
        self.myProfile  = ""
        self.editProfile  = ""
        self.updateInformation  = ""
        self.serviceDescription  = ""
        self.changePassword  = ""
        self.paymentType  = ""
        self.priceType  = ""
        self.ratingUpdatedSuccess  = ""
        self.category  = ""
        self.subCategory  = ""
        self.fareType  = ""
        self.provideYourFeedback  = ""
        self.selectAll  = ""
        self.deSelectAll  = ""
        self.pleaseGivePermissionToAccessCamera  = ""
        self.welcomeToThe  = ""
        self.goferHandyServiceProviderApp  = ""
        self.payToAdmin  = ""
        self.thanksText  = ""
        self.jobRequestedDate  = ""
        self.support  = ""
        self.notAValidData  = ""
        self.fromHere  = ""
        self.minimumFare  = ""
        self.perMins  = ""
        self.perKm  = ""
        self.baseFareValidatonMsg  = ""
        self.quantityValidatonMsg  = ""
        self.minimumHourValidatonMsg  = ""
        self.minimumFareValidatonMsg  = ""
        self.perMinFareValidatonMsg  = ""
        self.perKmFareValidatonMsg  = ""
        self.howWasYourJob  = ""
        self.setServices  = ""
        self.setAvailability  = ""
        self.manageAvailability  = ""
        self.setBothAvailabilityAndServices  = ""
        self.locationPermissionDescription  = ""
        self.toAccessYourLocation  = ""
        self.iAgreeToThe  = ""
        self.and  = ""
        self.addProviderProof  = ""
        self.cancelAccountCreation  = ""
        self.infoNotSaved  = ""
        self.forceUpdate  = ""
        self.uploadLimit  = ""
        self.imageSelected  = ""
        self.imagesSelected  = ""
        self.requestAcceptMsg  = ""
        self.hello  = ""
        self.setLocation  = ""
        self.haveAnAccount  = ""
        self.welcomeBack  = ""
        self.loginToContinue  = ""
        self.continueWithPhone  = ""
        self.looking_for_user  = ""
        self.weeklyEarnings  = ""
        self.font  = ""
        self.theme  = ""
        self.businessType  = ""
        self.orderCompleted  = ""
        self.changeTheme  = ""
        self.changeFont  = ""
        self.pleaseEnterYourOldPassword  = ""
        self.pleaseEnterYourNewPassword  = ""
        self.pleaseEnterYourConfirmPassword  = ""
        self.whatYouProvide  = ""
        self.expired  = ""
        self.completed  = ""
        self.cashTrip  = ""
        self.cancelTrip  = ""
        self.sendMessage  = ""
        self.scheduleBooking  = ""
        self.manualBooking  = ""
        self.onlinepayment  = ""
        self.VehicleType  = ""
        self.continueText = ""
        self.deleteAccount = ""
        self.doyouwantdelete = ""
        self.pleasemakesuredelete = ""
        self.deleteotpmessage = ""
        self.accountdeletion = ""
        self.wallet_amount  = ""
        self.miles = ""
        self.passwordWarn = ""
        self.minChar = ""
        self.maxChar = ""

        self.dropoffLocation = ""
        self.accept_bid = ""
        self.reject_bid = ""
        self.bid_amount_requested = ""
        self.bid_accepted_successfully = ""
        self.bid_rejected_successfully = ""
        self.enterTheBidAmountForTheService = ""
        self.vehicleDetails = ""
        self.addAmount = ""
        self.fixed = ""
        self.hourly = ""
        self.time_distance = ""
        self.registration = ""
        self.engineCode = ""
        self.engineSize = ""
        self.transmission = ""
        self.weight = ""
        self.vehicleRecovery = ""
        self.vehiclename = ""
        self.noOfStops = ""
        self.startedAtStop = ""
        self.reachedAtStop = ""
        self.areyousureyouwanttodeclinethisrequest = ""
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.transmission = container.safeDecodeValue(forKey: .transmission)
        self.weight = container.safeDecodeValue(forKey: .weight)
        self.engineCode = container.safeDecodeValue(forKey: .engineCode)
        self.engineSize = container.safeDecodeValue(forKey: .engineSize)
        self.registration = container.safeDecodeValue(forKey: .registration)
        self.miles = container.safeDecodeValue(forKey: .miles)
        self.wallet_amount = container.safeDecodeValue(forKey: .wallet_amount)
        self.heatMap = container.safeDecodeValue(forKey: .heatMap)
        self.appName = container.safeDecodeValue(forKey: .appName)
        self.completedStatus = container.safeDecodeValue(forKey: .completedStatus)
        self.passwordValidationMsg  = container.safeDecodeValue(forKey: .passwordValidationMsg)
        self.noDataFound  = container.safeDecodeValue(forKey: .noDataFound)
        self.endTripStatus  = container.safeDecodeValue(forKey: .endTripStatus)
        self.beginTripStatus  = container.safeDecodeValue(forKey: .beginTripStatus)
        self.cancelledStatus  = container.safeDecodeValue(forKey: .cancelledStatus)
        self.reqStatus  = container.safeDecodeValue(forKey: .reqStatus)
        self.pendingStatus  = container.safeDecodeValue(forKey: .pendingStatus)
        self.sheduledStatus  = container.safeDecodeValue(forKey: .sheduledStatus)
        self.paymentStatus  = container.safeDecodeValue(forKey: .paymentStatus)
        self.login = container.safeDecodeValue(forKey: .login)
        self.register   = container.safeDecodeValue(forKey: .register)
        self.signUp  = container.safeDecodeValue(forKey: .signUp)
        self.online   = container.safeDecodeValue(forKey: .online)
        self.offline   = container.safeDecodeValue(forKey: .offline)
        self.checkStatus  = container.safeDecodeValue(forKey: .checkStatus)
        self.totalPayout  = container.safeDecodeValue(forKey: .totalPayout)
        self.payStatement  = container.safeDecodeValue(forKey: .payStatement)
        self.sunday =  container.safeDecodeValue(forKey: .sunday)
        self.monday = container.safeDecodeValue(forKey: .monday)
        self.tuesday = container.safeDecodeValue(forKey: .tuesday)
        self.wednesday = container.safeDecodeValue(forKey: .wednesday)
        self.thursday = container.safeDecodeValue(forKey: .thursday)
        self.friday = container.safeDecodeValue(forKey: .friday)
        self.saturday = container.safeDecodeValue(forKey: .saturday)
        self.week = container.safeDecodeValue(forKey: .week)
        self.ok = container.safeDecodeValue(forKey: .ok)
        self.m = container.safeDecodeValue(forKey: .m)
        self.tu = container.safeDecodeValue(forKey: .tu)
        self.w = container.safeDecodeValue(forKey: .w)
        self.th = container.safeDecodeValue(forKey: .th)
        self.f = container.safeDecodeValue(forKey: .f)
        self.sa = container.safeDecodeValue(forKey: .sa)
        self.su = container.safeDecodeValue(forKey: .su)
        self.noData  = container.safeDecodeValue(forKey: .noData)
        self.mostRecentPayout  = container.safeDecodeValue(forKey: .mostRecentPayout)
        self.fiveStarTrips  = container.safeDecodeValue(forKey: .fiveStarTrips)
        self.yourCurrentRating  = container.safeDecodeValue(forKey: .yourCurrentRating)
        self.noVehicleAssigned  = container.safeDecodeValue(forKey: .noVehicleAssigned)
        self.referral = container.safeDecodeValue(forKey: .referral)
        self.documents = container.safeDecodeValue(forKey: .documents)
        self.payout = container.safeDecodeValue(forKey: .payout)
        self.bankDetails  = container.safeDecodeValue(forKey: .bankDetails)
        self.payTo  = container.safeDecodeValue(forKey: .payTo)
        self.edit = container.safeDecodeValue(forKey: .edit)
        self.view = container.safeDecodeValue(forKey: .view)
        self.signOut  = container.safeDecodeValue(forKey: .signOut)
        self.manualBookingReminder  = container.safeDecodeValue(forKey: .manualBookingReminder)
        self.manualBookingCancelled  = container.safeDecodeValue(forKey: .manualBookingCancelled)
        self.apply = container.safeDecodeValue(forKey: .apply)
        self.amount = container.safeDecodeValue(forKey: .amount)
        self.selectExtraFee  = container.safeDecodeValue(forKey: .selectExtraFee)
        self.applyExtraFee  = container.safeDecodeValue(forKey: .applyExtraFee)
        self.enterExtraFee  = container.safeDecodeValue(forKey: .enterExtraFee)
        self.enterOtp  = container.safeDecodeValue(forKey: .enterOtp)
        self.done = container.safeDecodeValue(forKey: .done)
        self.cancel = container.safeDecodeValue(forKey: .cancel)
        self.weeklyStatement  = container.safeDecodeValue(forKey: .weeklyStatement)
        self.baseFare  = container.safeDecodeValue(forKey: .baseFare)
        self.accessFee  = container.safeDecodeValue(forKey: .accessFee)
        self.total = container.safeDecodeValue(forKey: .total)
        self.cashCollected  = container.safeDecodeValue(forKey: .cashCollected)
        self.bankDeposit  = container.safeDecodeValue(forKey: .bankDeposit)
        self.dailyEarnings  = container.safeDecodeValue(forKey: .dailyEarnings)
        self.noDailyEarnings  = container.safeDecodeValue(forKey: .noDailyEarnings)
        self.duration = container.safeDecodeValue(forKey: .duration)
        self.distance = container.safeDecodeValue(forKey: .distance)
        self.km = container.safeDecodeValue(forKey: .km)
        self.mins =  container.safeDecodeValue(forKey: .mins)
        self.rejected = container.safeDecodeValue(forKey: .rejected)
        self.addDocument  = container.safeDecodeValue(forKey: .addDocument)
        self.busyTryAgain  = container.safeDecodeValue(forKey: .busyTryAgain)
        self.inTripComplete  = container.safeDecodeValue(forKey: .inTripComplete)
        self.searchLocation  = container.safeDecodeValue(forKey: .searchLocation)
        self.yourOnlineGoOffline  = container.safeDecodeValue(forKey: .yourOnlineGoOffline)
        self.vehicleIsNotActive  = container.safeDecodeValue(forKey: .vehicleIsNotActive)
        self.addNew  = container.safeDecodeValue(forKey: .addNew)
        self.person = container.safeDecodeValue(forKey: .person)
        self.persons = container.safeDecodeValue(forKey: .persons)
        self.manageServices  = container.safeDecodeValue(forKey: .manageServices)
        self.manageHome  = container.safeDecodeValue(forKey: .manageHome)
        self.loginText  = container.safeDecodeValue(forKey: .loginText)
        self.welcomeLoginText  = container.safeDecodeValue(forKey: .welcomeLoginText)
        self.yourJob  = container.safeDecodeValue(forKey: .yourJob)
        self.tapToChange  = container.safeDecodeValue(forKey: .tapToChange)
        self.dontHaveAcc  = container.safeDecodeValue(forKey: .dontHaveAcc)
        self.alreadyHaveAcc  = container.safeDecodeValue(forKey: .alreadyHaveAcc)
        self.tocText  = container.safeDecodeValue(forKey: .tocText)
        self.logout = container.safeDecodeValue(forKey: .logout)
        self.pleaseSetLocation  = container.safeDecodeValue(forKey: .pleaseSetLocation)
        self.of = container.safeDecodeValue(forKey: .of)
        self.rUSureToLogOut  = container.safeDecodeValue(forKey: .rUSureToLogOut)
        self.areYouSureToDelete  = container.safeDecodeValue(forKey: .areYouSureToDelete)
        self.deleteAnyWay  = container.safeDecodeValue(forKey: .deleteAnyWay)
        self.managePayouts  = container.safeDecodeValue(forKey: .managePayouts)
        self.cancelBooking  = container.safeDecodeValue(forKey: .cancelBooking)
        self.arrive = container.safeDecodeValue(forKey: .arrive)
        self.beginJob  = container.safeDecodeValue(forKey: .beginJob)
        self.endJob  = container.safeDecodeValue(forKey: .endJob)
        self.slideTo  = container.safeDecodeValue(forKey: .slideTo)
        self.specialInstruction  = container.safeDecodeValue(forKey: .specialInstruction)
        self.areYouSure  = container.safeDecodeValue(forKey: .areYouSure)
        self.sec = container.safeDecodeValue(forKey: .sec)
        self.pending = container.safeDecodeValue(forKey: .pending)
        self.cancelReason  = container.safeDecodeValue(forKey: .cancelReason)
        self.writeYourComment  = container.safeDecodeValue(forKey: .writeYourComment)
        self.wrongAddressShown  = container.safeDecodeValue(forKey: .wrongAddressShown)
        self.involvedInAnAccident  = container.safeDecodeValue(forKey: .involvedInAnAccident)
        self.minute = container.safeDecodeValue(forKey: .minute)
        self.minutes = container.safeDecodeValue(forKey: .minutes)
        self.cancellingRequest  = container.safeDecodeValue(forKey: .cancellingRequest)
        self.cancelled = container.safeDecodeValue(forKey: .cancelled)
        self.pleaseEnablePushNotification  = container.safeDecodeValue(forKey: .pleaseEnablePushNotification)
        self.alreadyAccepted  = container.safeDecodeValue(forKey: .alreadyAccepted)
        self.alreadyAcceptedBySomeone  = container.safeDecodeValue(forKey: .alreadyAcceptedBySomeone)
        self.selectAPhoto  = container.safeDecodeValue(forKey: .selectAPhoto)
        self.takePhoto  = container.safeDecodeValue(forKey: .takePhoto)
        self.chooseFromLibrary  = container.safeDecodeValue(forKey: .chooseFromLibrary)
        self.firstName  = container.safeDecodeValue(forKey: .firstName)
        self.lastName  = container.safeDecodeValue(forKey: .lastName)
        self.email = container.safeDecodeValue(forKey: .email)
        self.phoneNumber  = container.safeDecodeValue(forKey: .phoneNumber)
        self.addressLineFirst  = container.safeDecodeValue(forKey: .addressLineFirst)
        self.addressLineSecond  = container.safeDecodeValue(forKey: .addressLineSecond)
        self.city = container.safeDecodeValue(forKey: .city)
        self.postalCode  = container.safeDecodeValue(forKey: .postalCode)
        self.state = container.safeDecodeValue(forKey: .state)
        self.personalInformation  = container.safeDecodeValue(forKey: .personalInformation)
        self.address = container.safeDecodeValue(forKey: .address)
        self.message = container.safeDecodeValue(forKey: .message)
        self.error = container.safeDecodeValue(forKey: .error)
        self.deviceHasNoCamera  = container.safeDecodeValue(forKey: .deviceHasNoCamera)
        self.warning = container.safeDecodeValue(forKey: .warning)
        self.pleaseGivePermission  = container.safeDecodeValue(forKey: .pleaseGivePermission)
        self.uploadFailed  = container.safeDecodeValue(forKey: .uploadFailed)
        self.enRoute  = container.safeDecodeValue(forKey: .enRoute)
        self.navigate = container.safeDecodeValue(forKey: .navigate)
        self.cancelTripByDriver  = container.safeDecodeValue(forKey: .cancelTripByDriver)
        self.cancelTrips  = container.safeDecodeValue(forKey: .cancelTrips)
        self.hereYouCanChangeYourMap  = container.safeDecodeValue(forKey: .hereYouCanChangeYourMap)
        self.byClicking  = container.safeDecodeValue(forKey: .byClicking)
        self.googleMap  = container.safeDecodeValue(forKey: .googleMap)
        self.wazeMap  = container.safeDecodeValue(forKey: .wazeMap)
        self.doYouWant  = container.safeDecodeValue(forKey: .doYouWant)
        self.pleaseInstallGoogleMapsApp  = container.safeDecodeValue(forKey: .pleaseInstallGoogleMapsApp)
        self.doYouWantToAccessdirection  = container.safeDecodeValue(forKey: .doYouWantToAccessdirection)
        self.pleaseInstallWazeMapsApp  = container.safeDecodeValue(forKey: .pleaseInstallWazeMapsApp)
        self.networkDisconnected  = container.safeDecodeValue(forKey: .networkDisconnected)
        self.submit = container.safeDecodeValue(forKey: .submit)
        self.pickUp  = container.safeDecodeValue(forKey: .pickUp)
        self.contact = container.safeDecodeValue(forKey: .contact)
        self.help = container.safeDecodeValue(forKey: .help)
        self.about = container.safeDecodeValue(forKey: .about)
        self.callsOnly  = container.safeDecodeValue(forKey: .callsOnly)
        self.call = container.safeDecodeValue(forKey: .call)
        self.messages = container.safeDecodeValue(forKey: .messages)
        self.vehicleInformation  = container.safeDecodeValue(forKey: .vehicleInformation)
        self.rider = container.safeDecodeValue(forKey: .rider)
        self.typeAMessage  = container.safeDecodeValue(forKey: .typeAMessage)
        self.noMessagesYet  = container.safeDecodeValue(forKey: .noMessagesYet)
        self.country = container.safeDecodeValue(forKey: .country)
        self.currency = container.safeDecodeValue(forKey: .currency)
        self.bsb = container.safeDecodeValue(forKey: .bsb)
        self.accountNumber  = container.safeDecodeValue(forKey: .accountNumber)
        self.accountHolderName  = container.safeDecodeValue(forKey: .accountHolderName)
        self.addressOne  = container.safeDecodeValue(forKey: .addressOne)
        self.addressTwo  = container.safeDecodeValue(forKey: .addressTwo)
        self.address1  = container.safeDecodeValue(forKey: .address1)
        self.address2  = container.safeDecodeValue(forKey: .address2)
        self.postal = container.safeDecodeValue(forKey: .postal)
        self.pleaseEnter  = container.safeDecodeValue(forKey: .pleaseEnter)
        self.ibanNumber  = container.safeDecodeValue(forKey: .ibanNumber)
        self.sortCode  = container.safeDecodeValue(forKey: .sortCode)
        self.branchCode  = container.safeDecodeValue(forKey: .branchCode)
        self.clearingCode  = container.safeDecodeValue(forKey: .clearingCode)
        self.transitNumber  = container.safeDecodeValue(forKey: .transitNumber)
        self.institutionNumber  = container.safeDecodeValue(forKey: .institutionNumber)
        self.clabe = container.safeDecodeValue(forKey: .clabe)
        self.rountingNumber  = container.safeDecodeValue(forKey: .rountingNumber)
        self.bankName  = container.safeDecodeValue(forKey: .bankName)
        self.branchName  = container.safeDecodeValue(forKey: .branchName)
        self.bankCode  = container.safeDecodeValue(forKey: .bankCode)
        self.accountOwnerName  = container.safeDecodeValue(forKey: .accountOwnerName)
        self.pleaseUpdateDocument  = container.safeDecodeValue(forKey: .pleaseUpdateDocument)
        self.pleaseUpdateAdditionalDocument  = container.safeDecodeValue(forKey: .pleaseUpdateAdditionalDocument)
        self.jobCancelledUSer = container.safeDecodeValue(forKey: .jobCancelledUSer)
        self.gender = container.safeDecodeValue(forKey: .gender)
        self.male = container.safeDecodeValue(forKey: .male)
        self.female = container.safeDecodeValue(forKey: .female)
        self.payouts = container.safeDecodeValue(forKey: .payout)
        self.choosePhoto  = container.safeDecodeValue(forKey: .choosePhoto)
        self.noCamera  = container.safeDecodeValue(forKey: .noCamera)
        self.alert = container.safeDecodeValue(forKey: .alert)
        self.cameraAccess  = container.safeDecodeValue(forKey: .cameraAccess)
        self.allowCamera  = container.safeDecodeValue(forKey: .allowCamera)
        self.setupPayout  = container.safeDecodeValue(forKey: .setupPayout)
        self.uber = container.safeDecodeValue(forKey: .uber)
        self.add = container.safeDecodeValue(forKey: .add)
        self.emailID  = container.safeDecodeValue(forKey: .emailID)
        
        self.pleaseEnterValidEmail = container.safeDecodeValue(forKey: .pleaseEnterValidEmail)
        self.swiftCode = container.safeDecodeValue(forKey: .swiftCode)
        self.common4Required = container.safeDecodeValue(forKey: .common4Required)
        self.paid = container.safeDecodeValue(forKey: .paid)
        self.waitingForPayment = container.safeDecodeValue(forKey: .waitingForPayment)
        self.proceed = container.safeDecodeValue(forKey: .proceed)
        self.success = container.safeDecodeValue(forKey: .success)
        self.riderPaid = container.safeDecodeValue(forKey: .riderPaid)
        self.paymentDetails = container.safeDecodeValue(forKey: .paymentDetails)
        self.paypalEmail = container.safeDecodeValue(forKey: .paypalEmail)
        self.save = container.safeDecodeValue(forKey: .save)
        self.addNewPayout = container.safeDecodeValue(forKey: .addNewPayout)
        self.account = container.safeDecodeValue(forKey: .account)
        self.payment = container.safeDecodeValue(forKey: .payment)
        self.addPayoutMethod = container.safeDecodeValue(forKey: .addPayoutMethod)
        self.trip = container.safeDecodeValue(forKey: .trip)
        self.history = container.safeDecodeValue(forKey: .history)
        self.payStatements = container.safeDecodeValue(forKey: .payStatements)
        self.changeCreditCard = container.safeDecodeValue(forKey: .changeCreditCard)
        self.addCreditCard = container.safeDecodeValue(forKey: .addCreditCard)
        self.pleaseEnterValidCard = container.safeDecodeValue(forKey: .pleaseEnterValidCard)
        self.pay = container.safeDecodeValue(forKey: .pay)
        self.change = container.safeDecodeValue(forKey: .change)
        self.enterTheAmount = container.safeDecodeValue(forKey: .enterTheAmount)
        self.referralAmount = container.safeDecodeValue(forKey: .referralAmount)
        self.applied = container.safeDecodeValue(forKey: .applied)
        self.addCard = container.safeDecodeValue(forKey: .addCard)
        self.yourPayTo = container.safeDecodeValue(forKey: .yourPayTo)
        self.getUpto = container.safeDecodeValue(forKey: .getUpto)
        self.forEveryFriend = container.safeDecodeValue(forKey: .forEveryFriend)
        self.signUpGet = container.safeDecodeValue(forKey: .signUpGet)
        self.yourReferralCode = container.safeDecodeValue(forKey: .yourReferralCode)
        self.yourInviteCode = container.safeDecodeValue(forKey: .yourInviteCode)
        
        self.forEveryFriendJobs = container.safeDecodeValue(forKey: .forEveryFriendJobs)
        self.shareMyCode = container.safeDecodeValue(forKey: .shareMyCode)
        self.referralCopied = container.safeDecodeValue(forKey: .referralCopied)
        self.referralCodeCopied = container.safeDecodeValue(forKey: .referralCodeCopied)
        self.useMyReferral = container.safeDecodeValue(forKey: .useMyReferral)
        self.startYourJourney = container.safeDecodeValue(forKey: .startYourJourney)
        self.declineServiceRequest = container.safeDecodeValue(forKey: .declineServiceRequest)
        self.noReferralsYet = container.safeDecodeValue(forKey: .noReferralsYet)
        self.friendsIncomplete = container.safeDecodeValue(forKey: .friendsIncomplete)
        self.friendsCompleted = container.safeDecodeValue(forKey: .friendsCompleted)
        self.earned = container.safeDecodeValue(forKey: .earned)
        self.referralExpired = container.safeDecodeValue(forKey: .referralExpired)
        self.cash = container.safeDecodeValue(forKey: .cash)
        self.paypal = container.safeDecodeValue(forKey: .paypal)
        self.promoCode = container.safeDecodeValue(forKey: .promoCode)
        self.promotions = container.safeDecodeValue(forKey: .promotions)
        self.wallet = container.safeDecodeValue(forKey: .wallet)
        self.stripeDetails = container.safeDecodeValue(forKey: .stripeDetails)
        self.addressKana = container.safeDecodeValue(forKey: .addressKana)
        self.addressKanji = container.safeDecodeValue(forKey: .addressKanji)
        self.yes = container.safeDecodeValue(forKey: .yes)
        self.no = container.safeDecodeValue(forKey: .no)
        self.pleaseEnterExtraFare = container.safeDecodeValue(forKey: .pleaseEnterExtraFare)
        self.pleaseSelectAnOption = container.safeDecodeValue(forKey: .pleaseSelectAnOption)
        self.pleaseEnterYourComment = container.safeDecodeValue(forKey: .pleaseEnterYourComment)
        self.stripe = container.safeDecodeValue(forKey: .stripe)
        self.defaults = container.safeDecodeValue(forKey: .defaults)
        self.signIn = container.safeDecodeValue(forKey: .signIn)
        self.close = container.safeDecodeValue(forKey: .close)
        self.password = container.safeDecodeValue(forKey: .password)
        self.forgotPassword = container.safeDecodeValue(forKey: .forgotPassword)
        self.enablePushNotify = container.safeDecodeValue(forKey: .enablePushNotify)
        self.resetPassword = container.safeDecodeValue(forKey: .resetPassword)
        self.confirmPassword = container.safeDecodeValue(forKey: .confirmPassword)
        self.selectVehicle = container.safeDecodeValue(forKey: .selectVehicle)
        self.chooseVehicle = container.safeDecodeValue(forKey: .chooseVehicle)
        self.vehicleName = container.safeDecodeValue(forKey: .vehicleName)
        self.vehicleNumber = container.safeDecodeValue(forKey: .vehicleNumber)
        self.continues = container.safeDecodeValue(forKey: .continues)
        self.selectCountry = container.safeDecodeValue(forKey: .selectCountry)
        self.search = container.safeDecodeValue(forKey: .search)
        self.uploadDoc = container.safeDecodeValue(forKey: .uploadDoc)
        self.verify = container.safeDecodeValue(forKey: .verify)
        self.toDriveWith = container.safeDecodeValue(forKey: .toDriveWith)
        
        
        self.vehicleMust = container.safeDecodeValue(forKey: .vehicleMust)
        self.licenseBack = container.safeDecodeValue(forKey: .licenseBack)
        self.licenseFront = container.safeDecodeValue(forKey: .licenseFront)
        self.licenseInsurance = container.safeDecodeValue(forKey: .licenseInsurance)
        self.licenseRC = container.safeDecodeValue(forKey: .licenseRC)
        self.licensePermit = container.safeDecodeValue(forKey: .licensePermit)
        self.docSection = container.safeDecodeValue(forKey: .docSection)
        self.takeYourPhoto = container.safeDecodeValue(forKey: .takeYourPhoto)
        self.readAllDetails = container.safeDecodeValue(forKey: .readAllDetails)
        self.agreeTerms = container.safeDecodeValue(forKey: .agreeTerms)
        self.termsConditions = container.safeDecodeValue(forKey: .termsConditions)
        self.privacyPolicy = container.safeDecodeValue(forKey: .privacyPolicy)
        self.connectionLost = container.safeDecodeValue(forKey: .connectionLost)
        self.tryAgain = container.safeDecodeValue(forKey: .tryAgain)
        self.tapToAdd = container.safeDecodeValue(forKey: .tapToAdd)
        self.mobileno = container.safeDecodeValue(forKey: .mobileno)
        self.refCode = container.safeDecodeValue(forKey: .refCode)
        self.likeResetPassword = container.safeDecodeValue(forKey: .likeResetPassword)
        self.mobile = container.safeDecodeValue(forKey: .mobile)
        self.mobileVerify = container.safeDecodeValue(forKey: .mobileVerify)
        self.enterMobileno = container.safeDecodeValue(forKey: .enterMobileno)
        self.resendOtp = container.safeDecodeValue(forKey: .resendOtp)
        self.smsMobileVerify = container.safeDecodeValue(forKey: .smsMobileVerify)
        self.didntReceiveOtp = container.safeDecodeValue(forKey: .didntReceiveOtp)
        self.otpAgain = container.safeDecodeValue(forKey: .otpAgain)
        self.nameOfBank = container.safeDecodeValue(forKey: .nameOfBank)
        self.bankLocation = container.safeDecodeValue(forKey: .bankLocation)
        self.pleaseGiveRating = container.safeDecodeValue(forKey: .pleaseGiveRating)
        self.passwordMismatch = container.safeDecodeValue(forKey: .passwordMismatch)
        self.credentialsDontLook = container.safeDecodeValue(forKey: .credentialsDontLook)
        self.nameEmail = container.safeDecodeValue(forKey: .nameEmail)
        self.beginTrip = container.safeDecodeValue(forKey: .beginTrip)
        self.endTrip = container.safeDecodeValue(forKey: .endTrip)
        self.confirmArrived = container.safeDecodeValue(forKey: .confirmArrived)
        self.newVersionAvail = container.safeDecodeValue(forKey: .newVersionAvail)
        self.updateApp = container.safeDecodeValue(forKey: .updateApp)
        self.visitAppStore = container.safeDecodeValue(forKey: .visitAppStore)
        self.internalServerError = container.safeDecodeValue(forKey: .internalServerError)
        self.dropOff = container.safeDecodeValue(forKey: .dropOff)
        self.timelyEarnings = container.safeDecodeValue(forKey: .timelyEarnings)
        self.quantity = container.safeDecodeValue(forKey: .quantity)
        self.clientNotInitialized = container.safeDecodeValue(forKey: .clientNotInitialized)
        self.jsonSerialaizationFailed = container.safeDecodeValue(forKey: .jsonSerialaizationFailed)
        self.noInternetConnection = container.safeDecodeValue(forKey: .noInternetConnection)
        self.driverEarnings = container.safeDecodeValue(forKey: .driverEarnings)
        self.onlinePay = container.safeDecodeValue(forKey: .onlinePay)
        self.connecting = container.safeDecodeValue(forKey: .connecting)
        self.ringing = container.safeDecodeValue(forKey: .ringing)
        self.callEnded = container.safeDecodeValue(forKey: .callEnded)
        self.placehodlerMail = container.safeDecodeValue(forKey: .placehodlerMail)
        self.enterValidOtp = container.safeDecodeValue(forKey: .enterValidOtp)
        self.locationService = container.safeDecodeValue(forKey: .locationService)
        self.tracking = container.safeDecodeValue(forKey: .tracking)
        self.camera = container.safeDecodeValue(forKey: .camera)
        self.photoLibrary = container.safeDecodeValue(forKey: .photoLibrary)
        self.service = container.safeDecodeValue(forKey: .service)
        self.app = container.safeDecodeValue(forKey: .app)
        self.pleaseEnable = container.safeDecodeValue(forKey: .pleaseEnable)
        self.requires = container.safeDecodeValue(forKey: .requires)
        self.common7For = container.safeDecodeValue(forKey: .common7For)
        
        self.functionality = container.safeDecodeValue(forKey: .functionality)
        self.successFullyUpdated = container.safeDecodeValue(forKey: .successFullyUpdated)
        self.enterYourOldPassword = container.safeDecodeValue(forKey: .enterYourOldPassword)
        self.enterYourNewPassword = container.safeDecodeValue(forKey: .enterYourNewPassword)
        self.enterYourConformPassword = container.safeDecodeValue(forKey: .enterYourConformPassword)
        self.confirm = container.safeDecodeValue(forKey: .confirm)
        self.home = container.safeDecodeValue(forKey: .home)
        self.trips = container.safeDecodeValue(forKey: .trips)
        self.earnings = container.safeDecodeValue(forKey: .earnings)
        self.ratings = container.safeDecodeValue(forKey: .ratings)
        
        self.acount = container.safeDecodeValue(forKey: .account)
        self.swipeTo = container.safeDecodeValue(forKey: .swipeTo)
        self.acceptingRequest = container.safeDecodeValue(forKey: .acceptingRequest)
        self.requestStatus = container.safeDecodeValue(forKey: .requestStatus)
        self.ratingStatus = container.safeDecodeValue(forKey: .ratingStatus)
        self.scheduledStatus = container.safeDecodeValue(forKey: .scheduledStatus)
        self.microphoneSerivce = container.safeDecodeValue(forKey: .microphoneSerivce)
        self.inAppCall = container.safeDecodeValue(forKey: .inAppCall)
        self.choose = container.safeDecodeValue(forKey: .choose)
        self.choosePaymentMethod = container.safeDecodeValue(forKey: .choosePaymentMethod)
        self.delete = container.safeDecodeValue(forKey: .delete)
        self.whatLike2_Do = container.safeDecodeValue(forKey: .whatLike2_Do)
        self.update = container.safeDecodeValue(forKey: .update)
        self.makeDefault = container.safeDecodeValue(forKey: .makeDefault)
        self.min = container.safeDecodeValue(forKey: .min)
        self.hr = container.safeDecodeValue(forKey: .hr)
        self.hrs = container.safeDecodeValue(forKey: .hrs)
        self.language = container.safeDecodeValue(forKey: .language)
        self.selectLanguage = container.safeDecodeValue(forKey: .selectLanguage)
        self.legalDocuments = container.safeDecodeValue(forKey: .legalDocuments)
        self.additionalDocuments = container.safeDecodeValue(forKey: .additionalDocuments)
        self.active = container.safeDecodeValue(forKey: .active)
        self.gettingLocationTryAgain = container.safeDecodeValue(forKey: .gettingLocationTryAgain)
        self.settings = container.safeDecodeValue(forKey: .settings)
        self.goOnline = container.safeDecodeValue(forKey: .goOnline)
        self.goOffline = container.safeDecodeValue(forKey: .goOffline)
        self.manageVehicle = container.safeDecodeValue(forKey: .manageVehicle)
        self.manageDocuments = container.safeDecodeValue(forKey: .manageDocuments)
        self.addEarnings = container.safeDecodeValue(forKey: .addEarnings)
        self.addPayouts = container.safeDecodeValue(forKey: .addPayouts)
        self.editVehicle = container.safeDecodeValue(forKey: .editVehicle)
        self.addVehicle = container.safeDecodeValue(forKey: .addVehicle)
        self.allProgressDiscard = container.safeDecodeValue(forKey: .allProgressDiscard)
        self.make = container.safeDecodeValue(forKey: .make)
        self.model = container.safeDecodeValue(forKey: .model)
        self.year = container.safeDecodeValue(forKey: .year)
        self.license = container.safeDecodeValue(forKey: .license)
        self.color = container.safeDecodeValue(forKey: .color)
        self.selectMake = container.safeDecodeValue(forKey: .selectMake)
        self.selectModel = container.safeDecodeValue(forKey: .selectModel)
        self.selectYear = container.safeDecodeValue(forKey: .selectYear)
        self.pleaseSelectMake = container.safeDecodeValue(forKey: .pleaseSelectMake)
        self.expiryDate = container.safeDecodeValue(forKey: .expiryDate)
        self.pleaseSelectOption = container.safeDecodeValue(forKey: .pleaseSelectOption)
        self.sureToDeleteVehicle = container.safeDecodeValue(forKey: .sureToDeleteVehicle)
        self.approved = container.safeDecodeValue(forKey: .approved)
        self.remove = container.safeDecodeValue(forKey: .remove)
        self.updatedSuccessfully = container.safeDecodeValue(forKey: .updatedSuccessfully)
        self.rate = container.safeDecodeValue(forKey: .rate)
        self.maximum = container.safeDecodeValue(forKey: .maximum)
        self.hours = container.safeDecodeValue(forKey: .hours)
        self.per = container.safeDecodeValue(forKey: .per)
        self.minimum = container.safeDecodeValue(forKey: .minimum)
        self.fare = container.safeDecodeValue(forKey: .fare)
        self.kilometer = container.safeDecodeValue(forKey: .kilometer)
        self.skip = container.safeDecodeValue(forKey: .skip)
        self.pullToRefresh = container.safeDecodeValue(forKey: .pullToRefresh)
        self.status = container.safeDecodeValue(forKey: .status)
        self.number = container.safeDecodeValue(forKey: .number)
        
        
        
        self.paymentMethods = container.safeDecodeValue(forKey: .paymentMethods)
        
        
        self.ssnLastDigit = container.safeDecodeValue(forKey: .ssnLastDigit)
        
        self.kanaAddress1 = container.safeDecodeValue(forKey: .kanaAddress1)
        self.kanaAddress2 = container.safeDecodeValue(forKey: .kanaAddress2)
        self.kanaCity = container.safeDecodeValue(forKey: .kanaCity)
        self.kanaState = container.safeDecodeValue(forKey: .kanaState)
        self.kanaPostal = container.safeDecodeValue(forKey: .kanaPostal)
        self.japan = container.safeDecodeValue(forKey: .japan)
        
        self.driver = container.safeDecodeValue(forKey: .driver)
        self.inActive = container.safeDecodeValue(forKey: .inActive)
        self.serverIssueError = container.safeDecodeValue(forKey: .serverIssueError)
        
        self.dayLeftToComplete = container.safeDecodeValue(forKey: .dayLeftToComplete)
        self.daysLeftToComplete = container.safeDecodeValue(forKey: .daysLeftToComplete)
        
        self.myProfile = container.safeDecodeValue(forKey: .myProfile)
        self.editProfile = container.safeDecodeValue(forKey: .editProfile)
        self.updateInformation = container.safeDecodeValue(forKey: .updateInformation)
        self.serviceDescription = container.safeDecodeValue(forKey: .serviceDescription)
        self.changePassword = container.safeDecodeValue(forKey: .changePassword)
        self.paymentType = container.safeDecodeValue(forKey: .paymentType)
        self.priceType = container.safeDecodeValue(forKey: .priceType)
        self.ratingUpdatedSuccess = container.safeDecodeValue(forKey: .ratingUpdatedSuccess)
        self.category = container.safeDecodeValue(forKey: .category)
        self.subCategory = container.safeDecodeValue(forKey: .subCategory)
        self.fareType = container.safeDecodeValue(forKey: .fareType)
        self.provideYourFeedback = container.safeDecodeValue(forKey: .provideYourFeedback)
        self.selectAll = container.safeDecodeValue(forKey: .selectAll)
        self.deSelectAll = container.safeDecodeValue(forKey: .deSelectAll)
        self.pleaseGivePermissionToAccessCamera = container.safeDecodeValue(forKey: .pleaseGivePermissionToAccessCamera)
        self.welcomeToThe = container.safeDecodeValue(forKey: .welcomeToThe)
        self.goferHandyServiceProviderApp = container.safeDecodeValue(forKey: .goferHandyServiceProviderApp)
        self.payToAdmin = container.safeDecodeValue(forKey: .payToAdmin)
        self.thanksText = container.safeDecodeValue(forKey: .thanksText)
        self.jobRequestedDate = container.safeDecodeValue(forKey: .jobRequestedDate)
        self.support = container.safeDecodeValue(forKey: .support)
        self.notAValidData = container.safeDecodeValue(forKey: .notAValidData)
        self.fromHere = container.safeDecodeValue(forKey: .fromHere)
        self.minimumFare = container.safeDecodeValue(forKey: .minimumFare)
        self.perMins = container.safeDecodeValue(forKey: .perMins)
        self.perKm = container.safeDecodeValue(forKey: .perKm)
        self.baseFareValidatonMsg = container.safeDecodeValue(forKey: .baseFareValidatonMsg)
        self.quantityValidatonMsg = container.safeDecodeValue(forKey: .quantityValidatonMsg)
        self.minimumHourValidatonMsg = container.safeDecodeValue(forKey: .minimumHourValidatonMsg)
        self.minimumFareValidatonMsg = container.safeDecodeValue(forKey: .minimumFareValidatonMsg)
        self.perMinFareValidatonMsg = container.safeDecodeValue(forKey: .perMinFareValidatonMsg)
        self.perKmFareValidatonMsg = container.safeDecodeValue(forKey: .perKmFareValidatonMsg)
        self.howWasYourJob = container.safeDecodeValue(forKey: .howWasYourJob)
        self.setServices = container.safeDecodeValue(forKey: .setServices)
        self.setAvailability = container.safeDecodeValue(forKey: .setAvailability)
        self.manageAvailability = container.safeDecodeValue(forKey: .manageAvailability)
        self.setBothAvailabilityAndServices = container.safeDecodeValue(forKey: .setBothAvailabilityAndServices)
        self.locationPermissionDescription = container.safeDecodeValue(forKey: .locationPermissionDescription)
        self.toAccessYourLocation = container.safeDecodeValue(forKey: .toAccessYourLocation)
        self.iAgreeToThe = container.safeDecodeValue(forKey: .iAgreeToThe)
        self.and = container.safeDecodeValue(forKey: .and)
        self.addProviderProof = container.safeDecodeValue(forKey: .addProviderProof)
        self.cancelAccountCreation = container.safeDecodeValue(forKey: .cancelAccountCreation)
        self.infoNotSaved = container.safeDecodeValue(forKey: .infoNotSaved)
        self.forceUpdate = container.safeDecodeValue(forKey: .forceUpdate)
        self.uploadLimit = container.safeDecodeValue(forKey: .uploadLimit)
        self.imageSelected = container.safeDecodeValue(forKey: .imageSelected)
        self.imagesSelected = container.safeDecodeValue(forKey: .imagesSelected)
        self.requestAcceptMsg = container.safeDecodeValue(forKey: .requestAcceptMsg)
        self.hello = container.safeDecodeValue(forKey: .hello)
        self.setLocation = container.safeDecodeValue(forKey: .setLocation)
        self.haveAnAccount = container.safeDecodeValue(forKey: .haveAnAccount)
        self.welcomeBack = container.safeDecodeValue(forKey: .welcomeBack)
        self.loginToContinue = container.safeDecodeValue(forKey: .loginToContinue)
        self.continueWithPhone = container.safeDecodeValue(forKey: .continueWithPhone)
        self.looking_for_user = container.safeDecodeValue(forKey: .looking_for_user)
        self.weeklyEarnings = container.safeDecodeValue(forKey: .weeklyEarnings)
        self.font = container.safeDecodeValue(forKey: .font)
        self.theme = container.safeDecodeValue(forKey: .theme)
        self.businessType = container.safeDecodeValue(forKey: .businessType)
        self.orderCompleted = container.safeDecodeValue(forKey: .orderCompleted)
        self.changeTheme = container.safeDecodeValue(forKey: .changeTheme)
        self.changeFont = container.safeDecodeValue(forKey: .changeFont)
        self.pleaseEnterYourOldPassword = container.safeDecodeValue(forKey: .pleaseEnterYourOldPassword)
        self.pleaseEnterYourNewPassword = container.safeDecodeValue(forKey: .pleaseEnterYourNewPassword)
        self.pleaseEnterYourConfirmPassword = container.safeDecodeValue(forKey: .pleaseEnterYourConfirmPassword)
        self.whatYouProvide = container.safeDecodeValue(forKey: .whatYouProvide)
        self.expired = container.safeDecodeValue(forKey: .expired)
        self.completed = container.safeDecodeValue(forKey: .completed)
        self.cashTrip = container.safeDecodeValue(forKey: .cashTrip)
        self.cancelTrip = container.safeDecodeValue(forKey: .cancelTrip)
        self.sendMessage = container.safeDecodeValue(forKey: .sendMessage)
        self.scheduleBooking = container.safeDecodeValue(forKey: .scheduleBooking)
        self.manualBooking = container.safeDecodeValue(forKey: .manualBooking)
        self.onlinepayment = container.safeDecodeValue(forKey: .onlinepayment)
        self.VehicleType = container.safeDecodeValue(forKey: .VehicleType)
        self.promo = container.safeDecodeValue(forKey: .promo)
        self.continueText = container.safeDecodeValue(forKey: .continueText)
        self.deleteAccount = container.safeDecodeValue(forKey: .deleteAccount)
        self.doyouwantdelete = container.safeDecodeValue(forKey: .doyouwantdelete)
        self.pleasemakesuredelete = container.safeDecodeValue(forKey: .pleasemakesuredelete)
        self.deleteotpmessage = container.safeDecodeValue(forKey: .deleteotpmessage)
        self.accountdeletion = container.safeDecodeValue(forKey: .accountdeletion)
        self.passwordWarn = container.safeDecodeValue(forKey: .passwordWarn)
        self.minChar = container.safeDecodeValue(forKey: .minChar)
        self.maxChar = container.safeDecodeValue(forKey: .maxChar)

        self.dropoffLocation = container.safeDecodeValue(forKey: .dropoffLocation)
        self.enter_service_description = container.safeDecodeValue(forKey: .enter_service_description)
        self.newDescription = container.safeDecodeValue(forKey: .newDescription)
        self.accept_bid = container.safeDecodeValue(forKey: .accept_bid)
        self.reject_bid = container.safeDecodeValue(forKey: .reject_bid)
        self.bid_amount_requested = container.safeDecodeValue(forKey: .bid_amount_requested)
        self.bid_accepted_successfully = container.safeDecodeValue(forKey: .bid_accepted_successfully)
        self.bid_rejected_successfully = container.safeDecodeValue(forKey: .bid_rejected_successfully)
        self.enterTheBidAmountForTheService = container.safeDecodeValue(forKey: .enterTheBidAmountForTheService)
        self.vehicleDetails = container.safeDecodeValue(forKey: .vehicleDetails)
        self.addAmount = container.safeDecodeValue(forKey: .addAmount)
        self.fixed = container.safeDecodeValue(forKey: .fixed)
        self.hourly = container.safeDecodeValue(forKey: .hourly)
        self.time_distance = container.safeDecodeValue(forKey: .time_distance)
        self.vehicleRecovery = container.safeDecodeValue(forKey: .vehicleRecovery)
        self.vehiclename = container.safeDecodeValue(forKey: .vehiclename)
        self.noOfStops = container.safeDecodeValue(forKey: .noOfStops)
        self.startedAtStop = container.safeDecodeValue(forKey: .startedAtStop)
        self.reachedAtStop = container.safeDecodeValue(forKey: .reachedAtStop)
        self.areyousureyouwanttodeclinethisrequest = container.safeDecodeValue(forKey: .areyousureyouwanttodeclinethisrequest)
    }
}


// MARK: - Gofer
class Gofer: Codable {
    let manualBookedForRide ,driverEarnings ,riderFaresEarned ,riderNoShow : String
    let riderRequestedCancel ,doNotChargeRider ,lookRiderApp ,seat : String
    let seats ,poolRequest ,gender ,male : String
    let female : String
    let rateYourRide:String
    let trip,trips: String
    let pendingTrips,completedTrips  :String
    let tripCancelledByRider : String
    let noTripToday :String
    let noPastTrip :String
    let tripId : String
    let selectGender : String
    let pleaseSelectYourGender : String
    let Tripno:String
    let Thankstrip:String
    let min:String
    let accept:String
    let ridemanualBook:String
    let ridescheduleBook:String
    let pool: String
    let noOfSeats : String
    enum CodingKeys : String,CodingKey {
        case manualBookedForRide = "manual_booked_for_ride", driverEarnings = "driver_earnings", riderFaresEarned = "rider_fares_earned", riderNoShow = "rider_no_show", riderRequestedCancel = "rider_requested_cancel", doNotChargeRider = "do_not_charge_rider", lookRiderApp = "look_rider_app", seat, seats,noOfSeats = "no_of_seats"
        case poolRequest = "pool_request", gender, male, female
        case rateYourRide = "rate_your_ride" //"Rate Your Ride"
        case trip,trips
        case pendingTrips = "pending_trips" // "Pending Trips"
        case completedTrips = "completed_trips" //"Completed Trips"
        case tripCancelledByRider = "trip_cancelled_by_rider" // "Trip cancelled by rider"
        case noTripToday = "no_trip_today" // "You have no today trips"
        case noPastTrip = "no_past_trip" // "You have no past trips"
        case tripId = "trip_id" // "Trip ID"
        case selectGender = "select_gender"
        case pleaseSelectYourGender = "please_select_your_gender"
        case Tripno = "Trip_no"
        case Thankstrip = "Thanks_trip"
        case min = "min"
        case accept = "accept"
        case ridemanualBook = "ride_manualBook"
        case ridescheduleBook = "ride_scheduleBook"
        case pool = "pool"
    }
    
    init() {
        self.manualBookedForRide = ""
        self.driverEarnings = ""
        self.riderFaresEarned = ""
        self.riderNoShow = ""
        self.riderRequestedCancel = ""
        self.doNotChargeRider = ""
        self.lookRiderApp = ""
        self.seat  = ""
        self.seats = ""
        self.poolRequest = ""
        self.gender  = ""
        self.male  = ""
        self.female  = ""
        self.rateYourRide = ""
        self.trip = ""
        self.trips = ""
        self.pendingTrips = ""
        self.completedTrips = ""
        self.tripCancelledByRider = ""
        self.noTripToday = ""
        self.noPastTrip = ""
        self.tripId = ""
        self.selectGender = ""
        self.pleaseSelectYourGender = ""
        self.Tripno = ""
        self.Thankstrip = ""
        self.min = ""
        self.accept = ""
        self.ridemanualBook = ""
        self.ridescheduleBook = ""
        self.pool = ""
        self.noOfSeats = ""
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.manualBookedForRide = container.safeDecodeValue(forKey: .manualBookedForRide)
        self.driverEarnings = container.safeDecodeValue(forKey: .driverEarnings)
        self.riderFaresEarned = container.safeDecodeValue(forKey: .riderFaresEarned)
        self.riderNoShow = container.safeDecodeValue(forKey: .riderNoShow)
        self.riderRequestedCancel = container.safeDecodeValue(forKey: .riderRequestedCancel)
        self.doNotChargeRider = container.safeDecodeValue(forKey: .doNotChargeRider)
        self.lookRiderApp = container.safeDecodeValue(forKey: .lookRiderApp)
        self.seat  = container.safeDecodeValue(forKey: .seat)
        self.seats = container.safeDecodeValue(forKey: .seats)
        self.poolRequest = container.safeDecodeValue(forKey: .poolRequest)
        self.gender  = container.safeDecodeValue(forKey: .gender)
        self.male  = container.safeDecodeValue(forKey: .male)
        self.female  = container.safeDecodeValue(forKey: .female)
        
        self.rateYourRide = container.safeDecodeValue(forKey: .rateYourRide)
        self.trip = container.safeDecodeValue(forKey: .trip)
        self.trips = container.safeDecodeValue(forKey: .trips)
        self.pendingTrips = container.safeDecodeValue(forKey: .pendingTrips)
        self.completedTrips = container.safeDecodeValue(forKey: .completedTrips)
        self.tripCancelledByRider = container.safeDecodeValue(forKey: .tripCancelledByRider)
        self.noTripToday = container.safeDecodeValue(forKey: .noTripToday)
        self.noPastTrip = container.safeDecodeValue(forKey: .noPastTrip)
        self.tripId = container.safeDecodeValue(forKey: .tripId)
        self.selectGender = container.safeDecodeValue(forKey: .selectGender)
        self.pleaseSelectYourGender = container.safeDecodeValue(forKey: .pleaseSelectYourGender)
        self.Tripno = container.safeDecodeValue(forKey: .Tripno)
        self.Thankstrip = container.safeDecodeValue(forKey: .Thankstrip)
        self.min = container.safeDecodeValue(forKey: .min)
        self.accept = container.safeDecodeValue(forKey: .accept)
        self.ridemanualBook = container.safeDecodeValue(forKey: .ridemanualBook)
        self.ridescheduleBook = container.safeDecodeValue(forKey: .ridescheduleBook)
        self.pool = container.safeDecodeValue(forKey: .pool)
        self.noOfSeats = container.safeDecodeValue(forKey: .noOfSeats)
    }
}

// MARK: - Handyman
class Handyman: Codable {
    let totalJobAmount ,jobPayment ,lastJob ,lifetimeJobs : String
    let ratedJobs ,riderFeedBack ,checkOut ,jobEarnings : String
    let completedJobs ,noJobs ,jobDetail ,jobID : String
    let jobHistory ,youHaveNoJobs ,youHaveNoPastJobs ,cancelYourJob : String
    let cancelJob ,rateYourRide ,cashJob ,yourJobs : String
    let user ,pleaseCompleteJobs ,inJobs ,liveTrack : String
    let jobProgress ,liveTracking ,requestedService : String
    let manageGallery,myAvailability : String
    let updatedServicesSuccessfully,updateServices,selectTheTimeslotMessage : String
    let allServices,myServices,enterServiceAmountBelow : String

    let yourWorkLocation,within,kmWorkRadius,manageWorkLocation,anyLocation,specifiedLocation,allowServiceAtYourLocation,workRadius,workRadiusMessage: String
    let workLocation,areaOfService,selectAddress,enterAddress,buildingPlaceholder,landmarkPlaceholder,nicknamePlaceholder,jobRequest,jobLocation,viewRequestedJob,decline,accept,imageDetailView : String
    let destinationLocation :String
    let viewJob : String
    let setLocationOnMap : String
    
    let providerPaidSuccess : String
    
    let uploadImageBeforeService,uploadImageAfterService,optional,beforeService,afterService : String
    let yourJob : String
    let beforeServices: String
    let afterServices : String
    let fareDetails: String
    let jobDetails : String
    let manageServicesDesc : String
    let searchServices : String
    let setYourProvidingService : String
    let setYourAvailability : String
    let serviceNo : String
    let pendingRequest : String
    let manualBookedFor : String
    let scheduleBookedFor : String
    
    enum CodingKeys : String,CodingKey {
        case viewJob = "view_job"
        case pendingRequest = "pending_request",manualBookedFor = "manual_booked_for",scheduleBookedFor = "schedule_booked_for"
        case totalJobAmount = "total_job_amount", jobPayment = "job_payment", lastJob = "last_job", lifetimeJobs = "lifetime_jobs", ratedJobs = "rated_jobs", riderFeedBack = "rider_feed_back", checkOut = "check_out", jobEarnings = "job_earnings", completedJobs = "completed_jobs", noJobs = "no_jobs", jobDetail = "job_detail", jobID = "job_id", jobHistory = "job_history", youHaveNoJobs = "you_have_no_jobs", youHaveNoPastJobs = "you_have_no_past_jobs", cancelYourJob = "cancel_your_job", cancelJob = "cancel_job", rateYourRide = "rate_your_job", cashJob = "cash_job", yourJobs = "your_jobs", user
        case pleaseCompleteJobs = "please_complete_jobs", inJobs = "in_jobs", liveTrack = "live_track", jobProgress = "job_progress", liveTracking = "live_tracking", requestedService = "requested_service",manageGallery = "manage_gallery",myAvailability = "my_availability",updatedServicesSuccessfully = "updated_services_successfully"
        case yourWorkLocation = "your_work_location",within,kmWorkRadius = "km_work_radius",manageWorkLocation = "manage_work_location",anyLocation = "any_location",specifiedLocation = "specified_location",allowServiceAtYourLocation = "allow_service_at_your_location",workRadius = "work_radius",workRadiusMessage = "work_radius_message"
        case workLocation = "work_location",areaOfService = "area_of_service",selectAddress = "select_address",enterAddress = "enter_address",buildingPlaceholder = "building_placeholder",landmarkPlaceholder = "landmark_placeholder",nicknamePlaceholder = "nickname_placeholder",jobRequest = "job_request",jobLocation = "job_location",viewRequestedJob = "view_requested_job",decline,accept,imageDetailView = "image_detail_view"
        case updateServices = "update_services",selectTheTimeslotMessage = "select_the_timeslot_message",allServices = "all_services",myServices = "my_services",enterServiceAmountBelow = "enter_service_amount_below"
        case destinationLocation = "destination_location"
        case setLocationOnMap = "set_location_on_map"
        
        case providerPaidSuccess = "provider_paid_successfully"  // "Provider successfully paid"
        
        case uploadImageBeforeService = "upload_image_before_service",uploadImageAfterService = "upload_image_after_service",optional,beforeService = "before_service",afterService = "after_service"
        case yourJob = "your_job" // "Your Job"
        case beforeServices = "before_services" // "Before Services"
        case afterServices = "after_services" // "After Services"
        case fareDetails = "fare_details" // "Fare Details"
        case jobDetails = "job_details"
        case manageServicesDesc = "manage_services_desc"
        case searchServices = "search_services" // Search Services
        case setYourProvidingService = "set_your_providing_services"
        case setYourAvailability = "set_your_availability"
        case serviceNo = "service_no"
        
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalJobAmount = container.safeDecodeValue(forKey: .totalJobAmount)
        self.jobPayment = container.safeDecodeValue(forKey: .jobPayment)
        self.lastJob = container.safeDecodeValue(forKey: .lastJob)
        self.lifetimeJobs = container.safeDecodeValue(forKey: .lifetimeJobs)
        self.ratedJobs = container.safeDecodeValue(forKey: .ratedJobs)
        self.riderFeedBack = container.safeDecodeValue(forKey: .riderFeedBack)
        self.checkOut = container.safeDecodeValue(forKey: .checkOut)
        self.jobEarnings = container.safeDecodeValue(forKey: .jobEarnings)
        self.completedJobs = container.safeDecodeValue(forKey: .completedJobs)
        self.noJobs = container.safeDecodeValue(forKey: .noJobs)
        self.jobDetail = container.safeDecodeValue(forKey: .jobDetail)
        self.jobID = container.safeDecodeValue(forKey: .jobID)
        self.jobHistory = container.safeDecodeValue(forKey: .jobHistory)
        self.youHaveNoJobs = container.safeDecodeValue(forKey: .youHaveNoJobs)
        self.youHaveNoPastJobs = container.safeDecodeValue(forKey: .youHaveNoPastJobs)
        self.cancelYourJob = container.safeDecodeValue(forKey: .cancelYourJob)
        self.cancelJob = container.safeDecodeValue(forKey: .cancelJob)
        self.rateYourRide = container.safeDecodeValue(forKey: .rateYourRide)
        self.cashJob = container.safeDecodeValue(forKey: .cashJob)
        self.yourJobs = container.safeDecodeValue(forKey: .yourJobs)
        self.user = container.safeDecodeValue(forKey: .user)
        self.pleaseCompleteJobs = container.safeDecodeValue(forKey: .pleaseCompleteJobs)
        self.inJobs = container.safeDecodeValue(forKey: .inJobs)
        self.liveTrack = container.safeDecodeValue(forKey: .liveTrack)
        self.jobProgress = container.safeDecodeValue(forKey: .jobProgress)
        self.liveTracking = container.safeDecodeValue(forKey: .liveTracking)
        self.requestedService = container.safeDecodeValue(forKey: .requestedService)
        
        self.yourWorkLocation = container.safeDecodeValue(forKey: .yourWorkLocation)
        self.within = container.safeDecodeValue(forKey: .within)
        self.kmWorkRadius = container.safeDecodeValue(forKey: .kmWorkRadius)
        self.manageWorkLocation = container.safeDecodeValue(forKey: .manageWorkLocation)
        self.anyLocation = container.safeDecodeValue(forKey: .anyLocation)
        self.specifiedLocation = container.safeDecodeValue(forKey: .specifiedLocation)
        self.allowServiceAtYourLocation = container.safeDecodeValue(forKey: .allowServiceAtYourLocation)
        self.workRadius = container.safeDecodeValue(forKey: .workRadius)
        self.workRadiusMessage = container.safeDecodeValue(forKey: .workRadiusMessage)
        self.workLocation = container.safeDecodeValue(forKey: .workLocation)
        self.areaOfService = container.safeDecodeValue(forKey: .areaOfService)
        self.selectAddress = container.safeDecodeValue(forKey: .selectAddress)
        self.enterAddress = container.safeDecodeValue(forKey: .enterAddress)
        self.buildingPlaceholder = container.safeDecodeValue(forKey: .buildingPlaceholder)
        self.landmarkPlaceholder = container.safeDecodeValue(forKey: .landmarkPlaceholder)
        self.nicknamePlaceholder = container.safeDecodeValue(forKey: .nicknamePlaceholder)
        self.jobRequest = container.safeDecodeValue(forKey: .jobRequest)
        self.jobLocation = container.safeDecodeValue(forKey: .jobLocation)
        self.viewRequestedJob = container.safeDecodeValue(forKey: .viewRequestedJob)
        self.decline = container.safeDecodeValue(forKey: .decline)
        self.accept = container.safeDecodeValue(forKey: .accept)
        self.imageDetailView = container.safeDecodeValue(forKey: .imageDetailView)
        self.manageGallery = container.safeDecodeValue(forKey: .manageGallery)
        self.myAvailability = container.safeDecodeValue(forKey: .myAvailability)
        self.updatedServicesSuccessfully = container.safeDecodeValue(forKey: .updatedServicesSuccessfully)
        self.updateServices = container.safeDecodeValue(forKey: .updateServices)
        self.selectTheTimeslotMessage = container.safeDecodeValue(forKey: .selectTheTimeslotMessage)
        self.allServices = container.safeDecodeValue(forKey: .allServices)
        self.myServices = container.safeDecodeValue(forKey: .myServices)
        self.enterServiceAmountBelow = container.safeDecodeValue(forKey: .enterServiceAmountBelow)
        self.destinationLocation = container.safeDecodeValue(forKey: .destinationLocation)
        self.setLocationOnMap = container.safeDecodeValue(forKey: .setLocationOnMap)
        
        self.providerPaidSuccess = container.safeDecodeValue(forKey: .providerPaidSuccess)
        self.uploadImageBeforeService = container.safeDecodeValue(forKey: .uploadImageBeforeService)
        self.uploadImageAfterService = container.safeDecodeValue(forKey: .uploadImageAfterService)
        self.optional = container.safeDecodeValue(forKey: .optional)
        self.beforeService = container.safeDecodeValue(forKey: .beforeService)
        self.afterService = container.safeDecodeValue(forKey: .afterService)
        self.yourJob = container.safeDecodeValue(forKey: .yourJob)
        self.beforeServices = container.safeDecodeValue(forKey: .beforeServices)
        self.afterServices = container.safeDecodeValue(forKey: .afterServices)
        self.fareDetails = container.safeDecodeValue(forKey: .fareDetails)
        self.jobDetails = container.safeDecodeValue(forKey: .jobDetails)
        self.manageServicesDesc = container.safeDecodeValue(forKey: .manageServicesDesc)
        self.searchServices = container.safeDecodeValue(forKey: .searchServices)
        self.setYourProvidingService = container.safeDecodeValue(forKey: .setYourProvidingService)
        self.setYourAvailability = container.safeDecodeValue(forKey: .setYourAvailability)
        self.serviceNo = container.safeDecodeValue(forKey: .serviceNo)
        self.pendingRequest = container.safeDecodeValue(forKey: .pendingRequest)
        self.manualBookedFor = container.safeDecodeValue(forKey: .manualBookedFor)
        self.scheduleBookedFor = container.safeDecodeValue(forKey: .scheduleBookedFor)
        self.viewJob = container.safeDecodeValue(forKey: .viewJob)
    }
    
    init() {
        self.totalJobAmount  = ""
        self.jobPayment  = ""
        self.lastJob  = ""
        self.lifetimeJobs  = ""
        self.ratedJobs  = ""
        self.riderFeedBack  = ""
        self.checkOut  = ""
        self.jobEarnings  = ""
        self.completedJobs  = ""
        self.noJobs  = ""
        self.jobDetail  = ""
        self.jobID  = ""
        self.jobHistory  = ""
        self.youHaveNoJobs  = ""
        self.youHaveNoPastJobs  = ""
        self.cancelYourJob  = ""
        self.cancelJob  = ""
        self.rateYourRide  = ""
        self.cashJob  = ""
        self.yourJobs  = ""
        self.user  = ""
        self.pleaseCompleteJobs  = ""
        self.inJobs  = ""
        self.liveTrack  = ""
        self.jobProgress  = ""
        self.liveTracking  = ""
        self.requestedService  = ""
        self.yourWorkLocation  = ""
        self.within  = ""
        self.kmWorkRadius  = ""
        self.manageWorkLocation  = ""
        self.anyLocation  = ""
        self.specifiedLocation  = ""
        self.allowServiceAtYourLocation  = ""
        self.workRadius  = ""
        self.workRadiusMessage  = ""
        self.workLocation  = ""
        self.areaOfService  = ""
        self.selectAddress  = ""
        self.enterAddress  = ""
        self.buildingPlaceholder  = ""
        self.landmarkPlaceholder  = ""
        self.nicknamePlaceholder  = ""
        self.jobRequest  = ""
        self.jobLocation  = ""
        self.viewRequestedJob  = ""
        self.decline  = ""
        self.accept  = ""
        self.imageDetailView  = ""
        self.manageGallery  = ""
        self.myAvailability  = ""
        self.updatedServicesSuccessfully  = ""
        self.updateServices  = ""
        self.selectTheTimeslotMessage  = ""
        self.allServices  = ""
        self.myServices  = ""
        self.enterServiceAmountBelow  = ""
        self.destinationLocation  = ""
        self.setLocationOnMap  = ""
        self.providerPaidSuccess  = ""
        self.uploadImageBeforeService  = ""
        self.uploadImageAfterService  = ""
        self.optional  = ""
        self.beforeService  = ""
        self.afterService  = ""
        self.yourJob  = ""
        self.beforeServices  = ""
        self.afterServices  = ""
        self.fareDetails  = ""
        self.jobDetails  = ""
        self.manageServicesDesc  = ""
        self.searchServices  = ""
        self.setYourProvidingService  = ""
        self.setYourAvailability  = ""
        self.serviceNo  = ""
        self.pendingRequest  = ""
        self.manualBookedFor  = ""
        self.scheduleBookedFor  = ""
        self.viewJob  = ""
    }
}
// MARK: - Delivery
class DeliveryLang: Codable {
    let startDelivery : String
    let endDelivery : String
    let reached : String
    let totalOrders : String
    let uploadImageBeforeStartingTheService : String
    let uploadImageBeforeEndingTheService : String
    let deliveryDetail : String
    let paymentType : String
    let pickupLocation : String
    let manageVehicleDocuments : String
    let viewRecipients : String
    let instruction : String
    let dropoffLocation : String
    init() {
        self.startDelivery = "Start Delivery"
        self.endDelivery = "End Delivery"
        self.reached = "Reached for Pickup"
        self.totalOrders = ""
        self.uploadImageBeforeStartingTheService = ""
        self.uploadImageBeforeEndingTheService = ""
        self.deliveryDetail = ""
        self.paymentType = ""
        self.pickupLocation = ""
        self.manageVehicleDocuments = ""
        self.viewRecipients = ""
        self.instruction = ""
        self.dropoffLocation = ""
    }
    
    enum CodingKeys : String,CodingKey {
        case startDelivery = "start_delivery"
        case endDelivery = "end_delivery"
        case reached
        case totalOrders = "total_Orders"
        case uploadImageBeforeStartingTheService = "upload_image_starting_error"
        case uploadImageBeforeEndingTheService = "upload_image_ending_error"
        case deliveryDetail = "delivery_detail"
        case paymentType = "payment_Type"
        case pickupLocation = "pickup_location"
        case manageVehicleDocuments = "manage_vehicle_documents"
        case viewRecipients = "view_recipients"
        case instruction = "instruction"
        case dropoffLocation = "dropoffLocation"
    }
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDelivery = container.safeDecodeValue(forKey: .startDelivery)
        self.endDelivery = container.safeDecodeValue(forKey: .endDelivery)
        self.reached = container.safeDecodeValue(forKey: .reached)
        self.totalOrders = container.safeDecodeValue(forKey: .totalOrders)
        self.uploadImageBeforeStartingTheService = container.safeDecodeValue(forKey: .uploadImageBeforeStartingTheService)
        self.uploadImageBeforeEndingTheService = container.safeDecodeValue(forKey: .uploadImageBeforeEndingTheService)
        self.deliveryDetail = container.safeDecodeValue(forKey: .deliveryDetail)
        self.paymentType = container.safeDecodeValue(forKey: .paymentType)
        self.pickupLocation = container.safeDecodeValue(forKey: .pickupLocation)
        self.manageVehicleDocuments = container.safeDecodeValue(forKey: .manageVehicleDocuments)
        self.viewRecipients = container.safeDecodeValue(forKey: .viewRecipients)
        self.instruction = container.safeDecodeValue(forKey: .instruction)
        self.dropoffLocation = container.safeDecodeValue(forKey: .dropoffLocation)
    }
}
class goferdeliveryall: Codable {
    let todaysTrips : String
    let pastTrips : String
    let completed : String
    let endTrip : String
    let beginTrip : String
    let cancelled : String
    let request : String
    let pending : String
    let scheduled : String
    let payment : String
    let login : String
    let register : String
    let signup : String
    let online : String
    let offline : String
    let checkStatus : String
    let totalTripsAmount : String
    let totalPayout : String
    let tripsPayments : String
    let payStatement : String
    let sunday : String
    let monday : String
    let tuesday : String
    let wednesday : String
    let thursday : String
    let friday : String
    let saturday : String
    let thisWeek : String
    let ok : String
    let m : String
    let tu : String
    let w : String
    let th : String
    let f : String
    let sa : String
    let su : String
    let youHaveNotDrivenThisWeek : String
    let lastTrip : String
    let mostRecentPayout : String
    let lifetimeTrips : String
    let ratedTrips : String
    let fiveStars : String
    let youHaveNoRatingToDisplay : String
    let riderFeedback : String
    let checkOutFeedbackFromRidersAndLearnHowToImprove : String
    let noVehicleAssigned : String
    let referral : String
    let documents : String
    let payout : String
    let bankDetails : String
    let payToGofer : String
    let edit : String
    let view : String
    let signOut : String
    let manualBookingReminder : String
    let manualBookingCancelled : String
    let manuallyBookedForRide : String
    let apply : String
    let amount : String
    let selectExtraFeeDescription : String
    let applyExtraFare : String
    let enterExtraFeeDescription : String
    let enterOtpToBeginTrip : String
    let done : String
    let cancel : String
    let weeklyStatement : String
    let tripEarnings : String
    let baseFare : String
    let accessFee : String
    let totalGoferDriverEarnings : String
    let cashCollected : String
    let tips : String
    let riderFaresEarnedAndKept : String
    let bankDeposit : String
    let completedTrips : String
    let dailyEarnings : String
    let noDailyEarnings : String
    //let bankDeposit : String
    let noTrips : String
    let tripDetail : String
    let tripId : String
    let duration : String
    let distance : String
    let km : String
    let mins : String
    let tripHistory : String
    //let pending : String
    //let completed : String
    let youHaveNoTodayTrips : String
    let youHaveNoPastTrips : String
    let cancelYourRide : String
    let cancelReason : String
    let writeYourComment : String
    let cancelTrip : String
    let riderNoShow : String
    let riderRequestedCancel : String
    let wrongAddressShown : String
    let involvedInAnAccident : String
    let doNotChargeRider : String
    let minute : String
    let minutes : String
    let cancellingRequest : String
    //let cancelled : String
    let pleaseEnablePushNotificationInSettingsForRequest : String
    let alreadyAccepted : String
    let alreadyAcceptedBySomeone : String
    let selectAPhoto : String
    let takePhoto : String
    let chooseFromLibrary : String
    let firstName : String
    let lastName : String
    let email : String
    let phoneNumber : String
    let addressLine1 : String
    let addressLine2 : String
    let city : String
    let postalcode : String
    let state : String
    let addStateAbbrevationegNewyorkNy : String
    let personalInformation : String
    let address : String
    let message : String
    let error : String
    let deviceHasNoCamera : String
    let warning : String
    let pleaseGivePermissionToAccessPhoto : String
    let uploadFailedPleaseTryAgain : String
    let enRoute : String
    let navigate : String
    let cancelTripByDriver : String
    //let cancelTrip : String
    let hereYouCanChangeYourMap : String
    let byClickingBelowActions : String
    let googleMap : String
    let wazeMap : String
    let doYouWantToAccessDirection : String
    let pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem : String
    //let doYouWantToAccessDirection : String
    let pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem : String
    let networkDisconnected : String
    let rateYourRider : String
    let submit : String
    let pickUp : String
    let contact : String
    let help : String
    let about : String
    let callsOnly : String
    let call : String
    //let message : String
    let vehicleInformation : String
    let rider : String
    let typeAMessage : String
    let noMessagesYet : String
    let country : String
    let currency : String
    let bsb : String
    let accountNumber : String
    let accountHolderName : String
    let address1 : String
    let address2 : String
    let postalCode : String
    let pleaseEnterThe : String
    let ibanNumber : String
    let sortCode : String
    let branchCode : String
    let clearingCode : String
    let transitNumber : String
    let institutionNumber : String
    let rountingNumber : String
    let bankName : String
    let branchName : String
    let bankCode : String
    let accountOwnerName : String
    let pleaseUpdateALegalDocument : String
    let gender : String
    let male : String
    let female : String
    let payouts : String
    let choosePhoto : String
    //let deviceHasNoCamera : String
    let alert : String
    let cameraAccessRequiredForCapturingPhotos : String
    let allowCamera : String
    let setupYourUberPayoutMethod : String
    let uber : String
    let add : String
    let emailId : String
    let pleaseEnterValidMailId : String
    let bicSwiftCode : String
    let required : String
    let paid : String
    let waitingForPayment : String
    let proceed : String
    let success : String
    let riderSuccessfullyPaid : String
    let paymentDetails : String
    let paypalEmailId : String
    let save : String
    let toAddANewPayoutCreateAEmailForYour : String
    let account : String
    //let payment : String
    let addPayoutMethod : String
    let trip : String
    let history : String
    let payStatements : String
    let changeCreditOrDebitCard : String
    let addCreditOrDebitCard : String
    let pleaseEnterValidCardDetails : String
    let pay : String
    let change : String
    let enterTheAmount : String
    let referralAmount : String
    let applied : String
    let addCard : String
    let yourPayToGofer : String
    let getUpto : String
    let forEveryFriendWhoRidesWith : String
    let signupGetPaidForEveryReferralSignupMuchMoreBonusAwaits : String
    let yourReferralCode : String
    let shareMyCode : String
    let referralCopiedToClipBoard : String
    let useMyReferral : String
    let startYourJourneyOnGoferFromHere : String
    let noReferralsYet : String
    let friendsIncomplete : String
    let friendsCompleted : String
    let earned : String
    let referralExpired : String
    let cash : String
    let paypal : String
    let pleaseEnterThePromoCode : String
    let promotions : String
    let wallet : String
    let stripeDetails : String
    let addressKana : String
    let addressKanji : String
    let yes : String
    let no : String
    let pleaseEnterExtraFare : String
    let pleaseSelectAnOption : String
    let pleaseEnterYourComment : String
    let stripe : String
    let defaults : String
    let signIn : String
    let lookingForTheRiderApp : String
    let close : String
    let password : String
    let forgotPassword : String
    let pleaseEnablePushNotificationInSettingsForContinueToLogin : String
    let resetPassword : String
    let confirmPassword : String
    let selectYourVehicle : String
    let chooseVehicleType : String
    let enterYourVehicleName : String
    let enterYourVehicleNumber : String
    let continues : String
    let selectACountry : String
    let search : String
    let pleaseUploadYourDocuments : String
    let verify : String
    let toDriveWith : String
    let referralCodeOptional : String
    let driversLicenseBackReverse : String
    let driversLicenseFront : String
    let motorInsuranceCertificate : String
    let certificateOfRegistration : String
    let contractCarriagePermit : String
    let documentSection : String
    let takeAPhotoOfYour : String
    let pleaseMakeSureWeCanEasilyReadAllTheDetails : String
    let byContinuingIConfirmThatIHaveReadAndAgreeToTheTermsConditionsAndPrivacyPolicy : String
    let termsConditions : String
    let privacyPolicy : String
    let networkConnectionLost : String
    let pleaseTryAgain : String
    let tapToAdd : String
    let mobileNumber : String
    //let referralCodeOptional : String
    let howWouldYouLikeToResetYourPassword : String
    let mobile : String
    let mobileVerification : String
    let pleaseEnterYourMobile : String
    //let  : String
    let resendOtp : String
    let enterOtp : String
    let weHaveSentYouAccessCodeViaSmsForMobileNumberVerification : String
    let dintReceiveTheOtp : String
    let youCanSendOtpAgainIn : String
    let nameOfBank : String
    let bankLocation : String
    let pleaseGiveRating : String
    let passwordMismatch : String
    let thoseCredentialsDontLookRightPleaseTryAgain : String
    let nameexamplecom : String
    let dateOfBirth : String
    let rateYourRide : String
    //let beginTrip : String
    //let endTrip : String
    let confirmYouveArrived : String
    let newVersionAvailable : String
    let pleaseUpdateOurAppToEnjoyTheLatestFeatures : String
    let visitAppStore : String
    let internalServerErrorPleaseTryAgain : String
    let dropOff : String
    let timelyEarnings : String
    //let  : String
    let clientNotInitialized : String
    let jsonSerializationFailed : String
    let noInternetConnection : String
    let driverEarnings : String
    //let  : String
    let connecting : String
    let ringing : String
    let callEnded : String
    //let nameexamplecom : String
    let enterValidOtp : String
    let locationService : String
    let tracking : String
    let camera : String
    let photoLibrary : String
    let service : String
    let app : String
    let pleaseEnable : String
    let requires : String
    let fors : String
    let functionality : String
    let home : String
    let trips : String
    let earnings : String
    let ratings : String
    //let account : String
    let swipeTo : String
    let acceptingPickup : String
    //let request : String
    let rating : String
    //let scheduled : String
    let microphoneService : String
    let inAppCall : String
    let choose : String
    let choosePaymentMethod : String
    let delete : String
    let whatWouldYouLikeToDo : String
    let update : String
    let makeDefault : String
    let min : String
    let hr : String
    let hrs : String
    let legalDocument : String
    let additionalDocument : String
    let collectCash : String
    let orderDetails : String
    let from : String
    let orderId : String
    let startTrip : String
    let confirmed : String
    let confirmOrder : String
    let orderConfirmed : String
    let orderDelivered : String
    let howDidTheDeliveryGo : String
    let howDidThePickupGo : String
    let distanceFare : String
    let pickupFare : String
    let dropFare : String
    let totalTripFare : String
    let driverPayout : String
    let oweAmount : String
    let detectedOweAmount : String
    let store : String
    let user : String
    let next : String
    let pickUpOrder : String
    let step : String
    let selectRecipient : String
    let leaveAdditionalDetails : String
    let lookingForTheUserApp : String
    let complete : String
    let delivered : String
    let accepted : String
    let declined : String
    let picked : String
    let enterThe4DigitCodeSentToYouAt : String
    let selectFile : String
    let deliveryInstructions : String
    //let store : String
    let language : String
    let selectLanguage : String
    let updateApp : String
    let networkFailure : String
    let internalServerError : String
    let doc : String
    let personaldoc : String
    let driverlicenseBack : String
    let driverlicenseFront : String
    let logIn : String
    let haveAnAccount : String
    let taptochange : String
    let getmobilenumber : String
    let paypalemail : String
    let orderlist : String
    let noOrderFound : String
    let orderInstructions : String
    let pickUpOrderInside : String
    let droplocation : String
    let resetpasswords : String
    let errorMsgVehiclename : String
    let errorMsgVehiclenumber : String
    let errorMsgFirstname : String
    let errorMsgLastname : String
    let errorMsgEmail : String
    let errorMsgPhone : String
    let errorMsgPassword : String
    let cameraPermissionDescription : String
    let storagePermissionDescription : String
    let locationPermissionDescription : String
    let audioPermissionDescription : String
    let settings : String
    let enablePermissionsToProceedFurther : String
    let notNow : String
    let vehicle : String
    let vehicleName : String
    let vehicleNumber : String
    let signupwithrider : String
    let or : String
    let resend : String
    let otpMismatch : String
    let otpEmty : String
    let InvalidMobileNumber : String
    let Enteryourpassword : String
    let Confirmyourpassword : String
    let profile : String
    let payoutDetails : String
    let pickup : String
    let stateProvince : String
    let ssn : String
    let kanaAddress1:String
    let kanaAddress2:String
    let kanaCity :String
    let kanaState: String
    let kanaPostal:String
    let routingNumber : String
    let instituteNumber : String
    let streetHint : String
    let aptHint : String
    let cityHint : String
    let stateHint : String
    let pinHint : String
    let deflang : String
    let riderfeedback : String
    let checkfeedback : String
    let drivingstyle : String
    let seeyourdriving : String
    let tripStar5 : String
    let addpayment : String
    let addpayout : String
    let addpaymentMsg : String
    let timefare : String
    let deliveryfee : String
    let pickupaddress : String
    let dropaddress : String
    let order : String
    let payoutTitle : String
    let payoutLink : String
    let payoutMsg : String
    let enterAmount : String
    let enterAmountEmpty : String
    let deliverto : String
    let paymentOption : String
    let totalnumbers : String
    let totalnumber : String
    let timeonline : String
    let driverActivated : String
    let enteredAmtMsg : String
    let selectCountry : String
    let selectCurrency : String
    let logout : String
    let restaurant : String
    let quantity : String
    let items : String
    let step2Rating : String
    let step1SelectRecipient : String
    let signTerm1 : String
    let signTerm2 : String
    let signTerm3 : String
    let signTerm5 : String
    let penalty : String
    let notes : String
    let totalEarnings : String
    let loading : String
    let addPhoto : String
    let pleaseChooseCurrency : String
    let pleaseEnterIban : String
    let pleaseEnterAccountHolderName : String
    let pleaseEnterAddress1 : String
    let pleaseEnterAddress2 : String
    let pleaseEnterCity : String
    let pleaseEnterState : String
    let pleaseEnterPostalCode : String
    let pleaseUploadLegalDoc : String
    let pleaseEnterAccountNumber : String
    let pleaseEnterBsb : String
    let pleaseEnterRoutingNumber : String
    let pleaseEnterBankCode : String
    let pleaseEnterBranchCode : String
    let pleaseEnterSortCode : String
    let pleaseEnterSsn : String
    let pleaseEnterClearingCode : String
    let pleaseEnterBankName : String
    let pleaseEnterBranchName : String
    let pleaseEnterAccountOwnerName : String
    let pleaseEnterPhoneNumber : String
    let pleaseChooseGender : String
    let pleaseEnterAddress1OfKana : String
    let pleaseEnterAddress2OfKana : String
    let pleaseEnterCityOfKana : String
    let pleaseEnterStateOfKana : String
    let pleaseEnterPostalcodeOfKana : String
    let pleaseEnterAddress1OfKanji : String
    let pleaseEnterAddress2OfKanji : String
    let pleaseEnterCityOfKanji : String
    let pleaseEnterStateOfKanji : String
    let pleaseEnterPostalcodeOfKanji : String
    let pleaseEnterAddressName : String
    let pleaseEnterAccountName : String
    let pleaseChooseCountry : String
    let profileUpdatedSuccessfully : String
    let imageUploadSuccessfully : String
    let pressBack : String
    let mobileValidation : String
    let stripeError1 : String
    let setCanceled : String
    let paymentFailed : String
    let errorAddress : String
    let errorCity : String
    let errorZipCode : String
    let errorCountry : String
    let pleaseEnterTransitNumber : String
    let pleaseEnterInstitutionNumber : String
    let addphoto : String
    let enablePermission : String
    let selectgender : String
    let showpassword : String
    let externalStoragePermissionNecessary : String
    let select : String
    let addStateAbbreviationEGNewYorkNy : String
    let updatedsucessfully : String
    let pleaseUploadAdditionalDocument : String
    let setdob : String
    let pleasePickOrder : String
    let chooseMap : String
    let googleMapNotFoundInDevice : String
    let wazeGoogleMapNotFoundInDevice : String
    let vehicledocMsg : String
    let notrip : String
    let tipsFare : String
    let totaluberearning : String
    let riderfaresearn : String
    let addStripePayout : String
    let addBankPayout : String
    let addPaypalPayout : String
    let selectVehicle : String
    let cameraRoll : String
    let pleaseEnablePermissions : String
    let pleaseEnableLocation : String
    let tripCancelDriver : String
    let orderNotReady : String
    let pickUpFrom : String
    let sender : String
    let recipient : String
    let ordersConfirmed : String
    let confirmdropoff : String
    let completetrip : String
    let dropoffConfirmed : String
    let leaveYourComments : String
    let otherReasons : String
    let cancelOrder : String
    let selectReason : String
    let file : String
    let support : String
    let appName : String
    let placeOrderNearDoor : String
    let deliveryLocation : String
    let seats : Int
    let braintree : String
    let support_txt: String
    
    
    enum CodingKeys : String,CodingKey {
        case support_txt = "support_txt"
        case appName = "app_name"
        case todaysTrips = "todays_trips"
        case pastTrips = "past_trips"
        case completed = "completed"
        case endTrip = "end_trip"
        case beginTrip = "begin_trip"
        case cancelled = "cancelled"
        case request = "request"
        case pending = "pending"
        case scheduled = "scheduled"
        case payment = "payment"
        case login = "login"
        case register = "register"
        case signup = "signup"
        case online = "online"
        case offline = "offline"
        case checkStatus = "check_status"
        case totalTripsAmount = "total_trips_amount"
        case totalPayout = "total_payout"
        case tripsPayments = "trips_payments"
        case payStatement = "pay_statement"
        case sunday = "sunday"
        case monday = "monday"
        case tuesday = "tuesday"
        case wednesday = "wednesday"
        case thursday = "thursday"
        case friday = "friday"
        case saturday = "saturday"
        case thisWeek = "this_week"
        case ok = "ok"
        case m = "m"
        case tu = "tu"
        case w = "w"
        case th = "th"
        case f = "f"
        case sa = "sa"
        case su = "su"
        case youHaveNotDrivenThisWeek = "you_have_not_driven_this_week"
        case lastTrip = "last_trip"
        case mostRecentPayout = "most_recent_payout"
        case lifetimeTrips = "lifetime_trips"
        case ratedTrips = "rated_trips"
        case fiveStars = "five_stars"
        case youHaveNoRatingToDisplay = "you_have_no_rating_to_display"
        case riderFeedback = "rider_feedback"
        case checkOutFeedbackFromRidersAndLearnHowToImprove = "check_out_feedback_from_riders_and_learn_how_to_improve"
        case noVehicleAssigned = "no_vehicle_assigned"
        case referral = "referral"
        case documents = "documents"
        case payout = "payout"
        case bankDetails = "bank_details"
        case payToGofer = "pay_to_gofer"
        case edit = "edit"
        case view = "view"
        case signOut = "sign_out"
        case manualBookingReminder = "manual_booking_reminder"
        case manualBookingCancelled = "manual_booking_cancelled"
        case manuallyBookedForRide = "manually_booked_for_ride"
        case apply = "apply"
        case amount = "amount"
        case selectExtraFeeDescription = "select_extra_fee_description"
        case applyExtraFare = "apply_extra_fare"
        case enterExtraFeeDescription = "enter_extra_fee_description"
        case enterOtpToBeginTrip = "enter_otp_to_begin_trip"
        case done = "done"
        case cancel = "cancel"
        case weeklyStatement = "weekly_statement"
        case tripEarnings = "trip_earnings"
        case baseFare = "base_fare"
        case accessFee = "access_fee"
        case totalGoferDriverEarnings = "total_gofer_driver_earnings"
        case cashCollected = "cash_collected"
        case tips = "tips"
        case riderFaresEarnedAndKept = "rider_fares_earned_and_kept"
        case bankDeposit = "bank_deposit"
        case completedTrips = "completed_trips"
        case dailyEarnings = "daily_earnings"
        case noDailyEarnings = "no_daily_earnings"
        //case bankDeposit = "bank_deposit"
        case noTrips = "no_trips"
        case tripDetail = "trip_detail"
        case tripId = "trip_id"
        case duration = "duration"
        case distance = "distance"
        case km = "km"
        case mins = "mins"
        case tripHistory = "trip_history"
        //case pending = "pending"
        //case completed = "completed"
        case youHaveNoTodayTrips = "you_have_no_today_trips"
        case youHaveNoPastTrips = "you_have_no_past_trips"
        case cancelYourRide = "cancel_your_ride"
        case cancelReason = "cancel_reason"
        case writeYourComment = "write_your_comment"
        case cancelTrip = "cancel_trip"
        case riderNoShow = "rider_no_show"
        case riderRequestedCancel = "rider_requested_cancel"
        case wrongAddressShown = "wrong_address_shown"
        case involvedInAnAccident = "involved_in_an_accident"
        case doNotChargeRider = "do_not_charge_rider"
        case minute = "minute"
        case minutes = "minutes"
        case cancellingRequest = "cancelling_request"
        //case cancelled = "cancelled"
        case pleaseEnablePushNotificationInSettingsForRequest = "please_enable_push_notification_in_settings_for_request"
        case alreadyAccepted = "already_accepted"
        case alreadyAcceptedBySomeone = "already_accepted_by_someone"
        case selectAPhoto = "select_a_photo"
        case takePhoto = "take_photo"
        case chooseFromLibrary = "choose_from_library"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case phoneNumber = "phone_number"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city = "city"
        case postalcode = "postalcode"
        case state = "state"
        case addStateAbbrevationegNewyorkNy = "add_state_abbrevationeg_newyork_ny"
        case personalInformation = "personal_information"
        case address = "address"
        case message = "message"
        case error = "error"
        case deviceHasNoCamera = "device_has_no_camera"
        case warning = "warning"
        case pleaseGivePermissionToAccessPhoto = "please_give_permission_to_access_photo"
        case uploadFailedPleaseTryAgain = "upload_failed_please_try_again"
        case enRoute = "en_route"
        case navigate = "navigate"
        case cancelTripByDriver = "cancel_trip_by_driver"
        //case cancelTrip = "cancel_trip"
        case hereYouCanChangeYourMap = "here_you_can_change_your_map"
        case byClickingBelowActions = "by_clicking_below_actions"
        case googleMap = "google_map"
        case wazeMap = "waze_map"
        case doYouWantToAccessDirection = "do_you_want_to_access_direction"
        case pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem = "please_install_google_maps_app__then_only_you_get_the_direction_for_this_item"
        //case doYouWantToAccessDirection = "do_you_want_to_access_direction"
        case pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem = "please_install_waze_maps_app__then_only_you_get_the_direction_for_this_item"
        case networkDisconnected = "network_disconnected"
        case rateYourRider = "rate_your_rider"
        case submit = "submit"
        case pickUp = "pick_up"
        case contact = "contact"
        case help = "help"
        case about = "about"
        case callsOnly = "calls_only"
        case call = "call"
        //case message = "message"
        case vehicleInformation = "vehicle_information"
        case rider = "rider"
        case typeAMessage = "type_a_message"
        case noMessagesYet = "no_messages_yet"
        case country = "country"
        case currency = "currency"
        case bsb = "bsb"
        case accountNumber = "account_number"
        case accountHolderName = "account_holder_name"
        case address1 = "address1"
        case address2 = "address2"
        case postalCode = "postal_code"
        case pleaseEnterThe = "please_enter_the"
        case ibanNumber = "iban_number"
        case sortCode = "sort_code"
        case branchCode = "branch_code"
        case clearingCode = "clearing_code"
        case transitNumber = "transit_number"
        case institutionNumber = "institution_number"
        case rountingNumber = "rounting_number"
        case bankName = "bank_name"
        case branchName = "branch_name"
        case bankCode = "bank_code"
        case accountOwnerName = "account_owner_name"
        case pleaseUpdateALegalDocument = "please_update_a_legal_document"
        case gender = "gender"
        case male = "male"
        case female = "female"
        case payouts = "payouts"
        case choosePhoto = "choose_photo"
        //case deviceHasNoCamera = "device_has_no_camera"
        case alert = "alert"
        case cameraAccessRequiredForCapturingPhotos = "camera_access_required_for_capturing_photos"
        case allowCamera = "allow_camera"
        case setupYourUberPayoutMethod = "setup_your_uber_payout_method"
        case uber = "uber"
        case add = "add"
        case emailId = "email_id"
        case pleaseEnterValidMailId = "please_enter_valid_mail_id"
        case bicSwiftCode = "bic_swift_code"
        case required = "required"
        case paid = "paid"
        case waitingForPayment = "waiting_for_payment"
        case proceed = "proceed"
        case success = "success"
        case riderSuccessfullyPaid = "rider_successfully_paid"
        case paymentDetails = "payment_details"
        case paypalEmailId = "paypal_email_id"
        case save = "save"
        case toAddANewPayoutCreateAEmailForYour = "to_add_a_new_payout_create_a_email_for_your"
        case account = "account"
        //case payment = "payment"
        case addPayoutMethod = "add_payout_method"
        case trip = "trip"
        case history = "history"
        case payStatements = "pay_statements"
        case changeCreditOrDebitCard = "change_credit_or_debit_card"
        case addCreditOrDebitCard = "add_credit_or_debit_card"
        case pleaseEnterValidCardDetails = "please_enter_valid_card_details"
        case pay = "pay"
        case change = "change"
        case enterTheAmount = "enter_the_amount"
        case referralAmount = "referral_amount"
        case applied = "applied"
        case addCard = "add_card"
        case yourPayToGofer = "your_pay_to_gofer"
        case getUpto = "get_upto"
        case forEveryFriendWhoRidesWith = "for_every_friend_who_rides_with"
        case signupGetPaidForEveryReferralSignupMuchMoreBonusAwaits = "signup_get_paid_for_every_referral_signup_much_more_bonus_awaits"
        case yourReferralCode = "your_referral_code"
        case shareMyCode = "share_my_code"
        case referralCopiedToClipBoard = "referral_copied_to_clip_board_"
        case useMyReferral = "use_my_referral"
        case startYourJourneyOnGoferFromHere = "_start_your_journey_on_gofer_from_here"
        case noReferralsYet = "no_referrals_yet"
        case friendsIncomplete = "friends_incomplete"
        case friendsCompleted = "friends_completed"
        case earned = "earned_"
        case referralExpired = "referral_expired"
        case cash = "cash"
        case paypal = "paypal"
        case pleaseEnterThePromoCode = "please_enter_the_promo_code"
        case promotions = "promotions"
        case wallet = "wallet"
        case stripeDetails = "stripe_details"
        case addressKana = "address_kana"
        case addressKanji = "address_kanji"
        case yes = "yes"
        case no = "no"
        case pleaseEnterExtraFare = "please_enter_extra_fare"
        case pleaseSelectAnOption = "please_select_an_option"
        case pleaseEnterYourComment = "please_enter_your_comment"
        case stripe = "stripe"
        case defaults = "defaults"
        case signIn = "sign_in"
        case lookingForTheRiderApp = "looking_for_the_rider_app"
        case close = "close"
        case password = "password"
        case forgotPassword = "forgot_password"
        case pleaseEnablePushNotificationInSettingsForContinueToLogin = "please_enable_push_notification_in_settings_for_continue_to_login"
        case resetPassword = "reset_password"
        case confirmPassword = "confirm_password"
        case selectYourVehicle = "select_your_vehicle"
        case chooseVehicleType = "choose_vehicle_type"
        case enterYourVehicleName = "enter_your_vehicle_name"
        case enterYourVehicleNumber = "enter_your_vehicle_number"
        case continues = "continues"
        case selectACountry = "select_a_country"
        case search = "search"
        case pleaseUploadYourDocuments = "please_upload_your_documents"
        case verify = "verify"
        case toDriveWith = "to_drive_with"
        case referralCodeOptional = "referral_code_optional"
        case driversLicenseBackReverse = "drivers_license_back_reverse"
        case driversLicenseFront = "drivers_license_front"
        case motorInsuranceCertificate = "motor_insurance_certificate"
        case certificateOfRegistration = "certificate_of_registration"
        case contractCarriagePermit = "contract_carriage_permit"
        case documentSection = "document_section"
        case takeAPhotoOfYour = "take_a_photo_of_your"
        case pleaseMakeSureWeCanEasilyReadAllTheDetails = "please_make_sure_we_can_easily_read_all_the_details"
        case byContinuingIConfirmThatIHaveReadAndAgreeToTheTermsConditionsAndPrivacyPolicy = "by_continuing_i_confirm_that_i_have_read_and_agree_to_the_terms_conditions_and_privacy_policy"
        case termsConditions = "terms_conditions"
        case privacyPolicy = "privacy_policy"
        case networkConnectionLost = "network_connection_lost"
        case pleaseTryAgain = "please_try_again"
        case tapToAdd = "tap_to_add"
        case mobileNumber = "mobile_number"
        //case referralCodeOptional = "referral_code_optional"
        case howWouldYouLikeToResetYourPassword = "how_would_you_like_to_reset_your_password"
        case mobile = "mobile"
        case mobileVerification = "mobile_verification"
        case pleaseEnterYourMobile = "please_enter_your_mobile"
        //case  = ""
        case resendOtp = "resend_otp"
        case enterOtp = "enter_otp"
        case weHaveSentYouAccessCodeViaSmsForMobileNumberVerification = "we_have_sent_you_access_code_via_sms_for_mobile_number_verification"
        case dintReceiveTheOtp = "dint_receive_the_otp"
        case youCanSendOtpAgainIn = "you_can_send_otp_again_in"
        case nameOfBank = "name_of_bank"
        case bankLocation = "bank_location"
        case pleaseGiveRating = "please_give_rating"
        case passwordMismatch = "password_mismatch"
        case thoseCredentialsDontLookRightPleaseTryAgain = "those_credentials_dont_look_right_please_try_again"
        case nameexamplecom = "nameexamplecom"
        case dateOfBirth = "date_of_birth"
        case rateYourRide = "rate_your_ride"
        //case beginTrip = "begin_trip"
        //case endTrip = "end_trip"
        case confirmYouveArrived = "confirm_youve_arrived"
        case newVersionAvailable = "new_version_available"
        case pleaseUpdateOurAppToEnjoyTheLatestFeatures = "please_update_our_app_to_enjoy_the_latest_features"
        case visitAppStore = "visit_app_store"
        case internalServerErrorPleaseTryAgain = "internal_server_error_please_try_again"
        case dropOff = "drop_off"
        case timelyEarnings = "timely_earnings"
        //case  = ""
        case clientNotInitialized = "client_not_initialized"
        case jsonSerializationFailed = "json_serialization_failed"
        case noInternetConnection = "no_internet_connection"
        case driverEarnings = "driver_earnings"
        //case  = ""
        case connecting = "connecting"
        case ringing = "ringing"
        case callEnded = "call_ended"
        //case nameexamplecom = "nameexamplecom"
        case enterValidOtp = "enter_valid_otp"
        case locationService = "location_service"
        case tracking = "tracking"
        case camera = "camera"
        case photoLibrary = "photo_library"
        case service = "service"
        case app = "app"
        case pleaseEnable = "please_enable"
        case requires = "requires"
        case fors = "fors"
        case functionality = "functionality"
        case home = "home"
        case trips = "trips"
        case earnings = "earnings"
        case ratings = "ratings"
        //case account = "account"
        case swipeTo = "swipe_to"
        case acceptingPickup = "accepting_pickup"
        //case request = "request"
        case rating = "rating"
        //case scheduled = "scheduled"
        case microphoneService = "microphone_service"
        case inAppCall = "in_app_call"
        case choose = "choose"
        case choosePaymentMethod = "choose_payment_method"
        case delete = "delete"
        case whatWouldYouLikeToDo = "what_would_you_like_to_do_"
        case update = "update"
        case makeDefault = "make_default"
        case min = "min"
        case hr = "hr"
        case hrs = "hrs"
        case legalDocument = "legal_document"
        case additionalDocument = "additional_document"
        case collectCash = "collect_cash"
        case orderDetails = "order_details"
        case from = "from"
        case orderId = "order_id"
        case startTrip = "start_trip"
        case confirmed = "confirmed"
        case confirmOrder = "confirm_order"
        case orderConfirmed = "order_confirmed"
        case orderDelivered = "order_delivered"
        case howDidTheDeliveryGo = "how_did_the_delivery_go"
        case howDidThePickupGo = "how_did_the_pickup_go"
        case distanceFare = "distance_fare"
        case pickupFare = "pickup_fare"
        case dropFare = "drop_fare"
        case totalTripFare = "total_trip_fare"
        case driverPayout = "driver_payout"
        case oweAmount = "owe_amount"
        case detectedOweAmount = "detected_owe_amount"
        case store = "store"
        case user = "user"
        case next = "next"
        case pickUpOrder = "pick_up_order"
        case step = "step"
        case selectRecipient = "select_recipient"
        case leaveAdditionalDetails = "leave_additional_details"
        case lookingForTheUserApp = "looking_for_the_user_app"
        case complete = "complete"
        case delivered = "delivered"
        case accepted = "accepted"
        case declined = "declined"
        case picked = "picked"
        case enterThe4DigitCodeSentToYouAt = "enter_the_4_digit_code_sent_to_you_at"
        case selectFile = "select_file"
        case deliveryInstructions = "delivery_instructions"
        //case store = "store"
        case language = "language"
        case selectLanguage = "select_language"
        case updateApp = "update_app"
        case networkFailure = "network_failure"
        case internalServerError = "internal_server_error"
        case doc = "doc"
        case personaldoc = "personaldoc"
        case driverlicenseBack = "driverlicense_back"
        case driverlicenseFront = "driverlicense_front"
        case logIn = "log_in"
        case haveAnAccount = "have_an_account"
        case taptochange = "taptochange"
        case getmobilenumber = "getmobilenumber"
        case paypalemail = "paypalemail"
        case orderlist = "orderlist"
        case noOrderFound = "no_order_found"
        case orderInstructions = "order_instructions"
        case pickUpOrderInside = "pick_up_order_inside"
        case droplocation = "droplocation"
        case resetpasswords = "resetpasswords"
        case errorMsgVehiclename = "error_msg_vehiclename"
        case errorMsgVehiclenumber = "error_msg_vehiclenumber"
        case errorMsgFirstname = "error_msg_firstname"
        case errorMsgLastname = "error_msg_lastname"
        case errorMsgEmail = "error_msg_email"
        case errorMsgPhone = "error_msg_phone"
        case errorMsgPassword = "error_msg_password"
        case cameraPermissionDescription = "camera_permission_description"
        case storagePermissionDescription = "storage_permission_description"
        case locationPermissionDescription = "location_permission_description"
        case audioPermissionDescription = "audio_permission_description"
        case settings = "settings"
        case enablePermissionsToProceedFurther = "enable_permissions_to_proceed_further"
        case notNow = "not_now"
        case vehicle = "vehicle"
        case vehicleName = "vehicle_name"
        case vehicleNumber = "vehicle_number"
        case signupwithrider = "signupwithrider"
        case or = "or"
        case resend = "resend"
        case otpMismatch = "otp_mismatch"
        case otpEmty = "otp_emty"
        case InvalidMobileNumber = "InvalidMobileNumber"
        case Enteryourpassword = "Enteryourpassword"
        case Confirmyourpassword = "Confirmyourpassword"
        case profile = "profile"
        case payoutDetails = "payout_details"
        case pickup = "pickup"
        case stateProvince = "state_province"
        case ssn = "ssn"
        case routingNumber = "routing_number"
        case instituteNumber = "institute_number"
        case streetHint = "street_hint"
        case aptHint = "apt_hint"
        case cityHint = "city_hint"
        case stateHint = "state_hint"
        case pinHint = "pin_hint"
        case deflang = "deflang"
        case riderfeedback = "riderfeedback"
        case checkfeedback = "checkfeedback"
        case drivingstyle = "drivingstyle"
        case seeyourdriving = "seeyourdriving"
        case tripStar5 = "trip_star_5"
        case addpayment = "addpayment"
        case addpayout = "addpayout"
        case addpaymentMsg = "addpayment_msg"
        case timefare = "timefare"
        case deliveryfee = "deliveryfee"
        case pickupaddress = "pickupaddress"
        case dropaddress = "dropaddress"
        case order = "order"
        case payoutTitle = "payout_title"
        case payoutLink = "payout_link"
        case payoutMsg = "payout_msg"
        case enterAmount = "enter_amount"
        case enterAmountEmpty = "enter_amount_empty"
        case deliverto = "deliverto"
        case paymentOption = "payment_option"
        case totalnumbers = "totalnumbers"
        case totalnumber = "totalnumber"
        case timeonline = "timeonline"
        case driverActivated = "driver_activated"
        case enteredAmtMsg = "entered_amt_msg"
        case selectCountry = "select_country"
        case selectCurrency = "select_currency"
        case logout = "logout"
        case restaurant = "restaurant"
        case quantity = "quantity"
        case items = "items"
        case step2Rating = "step_2_rating"
        case step1SelectRecipient = "step_1_select_recipient"
        case signTerm1 = "sign_term1"
        case signTerm2 = "sign_term2"
        case signTerm3 = "sign_term3"
        case signTerm5 = "sign_term5"
        case penalty = "penalty"
        case notes = "notes"
        case totalEarnings = "total_earnings"
        case loading = "loading"
        case addPhoto = "add_photo"
        case pleaseChooseCurrency = "please_choose_currency"
        case pleaseEnterIban = "please_enter_iban"
        case pleaseEnterAccountHolderName = "please_enter_account_holder_name"
        case pleaseEnterAddress1 = "please_enter_address1"
        case pleaseEnterAddress2 = "please_enter_address2"
        case pleaseEnterCity = "please_enter_city"
        case pleaseEnterState = "please_enter_state"
        case pleaseEnterPostalCode = "please_enter_postal_code"
        case pleaseUploadLegalDoc = "please_upload_legal_doc"
        case pleaseEnterAccountNumber = "please_enter_account_number"
        case pleaseEnterBsb = "please_enter_bsb"
        case pleaseEnterRoutingNumber = "please_enter_routing_number"
        case pleaseEnterBankCode = "please_enter_bank_code"
        case pleaseEnterBranchCode = "please_enter_branch_code"
        case pleaseEnterSortCode = "please_enter_sort_code"
        case pleaseEnterSsn = "please_enter_ssn"
        case pleaseEnterClearingCode = "please_enter_clearing_code"
        case pleaseEnterBankName = "please_enter_bank_name"
        case pleaseEnterBranchName = "please_enter_branch_name"
        case pleaseEnterAccountOwnerName = "please_enter_account_owner_name"
        case pleaseEnterPhoneNumber = "please_enter_phone_number"
        case pleaseChooseGender = "please_choose_gender"
        case pleaseEnterAddress1OfKana = "please_enter_address1_of_kana"
        case pleaseEnterAddress2OfKana = "please_enter_address2_of_kana"
        case pleaseEnterCityOfKana = "please_enter_city_of_kana"
        case pleaseEnterStateOfKana = "please_enter_state_of_kana"
        case pleaseEnterPostalcodeOfKana = "please_enter_postalcode_of_kana"
        case pleaseEnterAddress1OfKanji = "please_enter_address1_of_kanji"
        case pleaseEnterAddress2OfKanji = "please_enter_address2_of_kanji"
        case pleaseEnterCityOfKanji = "please_enter_city_of_kanji"
        case pleaseEnterStateOfKanji = "please_enter_state_of_kanji"
        case pleaseEnterPostalcodeOfKanji = "please_enter_postalcode_of_kanji"
        case pleaseEnterAddressName = "please_enter_address_name"
        case pleaseEnterAccountName = "please_enter_account_name"
        case pleaseChooseCountry = "please_choose_country"
        case profileUpdatedSuccessfully = "profile_updated_successfully"
        case imageUploadSuccessfully = "image_upload_successfully"
        case pressBack = "press_back"
        case mobileValidation = "mobile_validation"
        case stripeError1 = "stripe_error_1"
        case setCanceled = "set_canceled"
        case paymentFailed = "payment_failed"
        case errorAddress = "error_address"
        case errorCity = "error_city"
        case errorZipCode = "error_zip_code"
        case errorCountry = "error_country"
        case pleaseEnterTransitNumber = "please_enter_transit_number"
        case pleaseEnterInstitutionNumber = "please_enter_institution_number"
        case addphoto = "addphoto"
        case enablePermission = "enable_permission"
        case selectgender = "selectgender"
        case showpassword = "showpassword"
        case externalStoragePermissionNecessary = "external_storage_permission_necessary"
        case select = "select"
        case addStateAbbreviationEGNewYorkNy = "add_state_abbreviation_e_g_new_york_ny"
        case updatedsucessfully = "updatedsucessfully"
        case pleaseUploadAdditionalDocument = "please_upload_additional_document"
        case setdob = "setdob"
        case pleasePickOrder = "please_pick_order"
        case chooseMap = "choose_map"
        case googleMapNotFoundInDevice = "google_map_not_found_in_device"
        case wazeGoogleMapNotFoundInDevice = "waze_google_map_not_found_in_device"
        case vehicledocMsg = "vehicledoc_msg"
        case notrip = "notrip"
        case tipsFare = "tips_fare"
        case totaluberearning = "totaluberearning"
        case riderfaresearn = "riderfaresearn"
        case addStripePayout = "add_stripe_payout"
        case addBankPayout = "add_bank_payout"
        case addPaypalPayout = "add_paypal_payout"
        case selectVehicle = "select_vehicle"
        case cameraRoll = "camera_roll"
        case pleaseEnablePermissions = "please_enable_permissions"
        case pleaseEnableLocation = "please_enable_location"
        case tripCancelDriver = "trip_cancel_driver"
        case orderNotReady = "order_not_ready"
        case pickUpFrom = "pick_up_from"
        case sender = "sender"
        case recipient = "recipient"
        case ordersConfirmed = "orders_confirmed"
        case confirmdropoff = "confirmdropoff"
        case completetrip = "completetrip"
        case dropoffConfirmed = "dropoff_confirmed"
        case leaveYourComments = "leave_your_comments"
        case otherReasons = "other_reasons"
        case cancelOrder = "cancel_order"
        case selectReason = "select_reason"
        case file = "file"
        case support = "support"
        case kanaAddress1 = "kana_address1" //"KanaAddress1"
        case kanaAddress2 = "kana_address2" //"KanaAddress2"
        case kanaCity = "kana_city" // "KanaCity"
        case kanaState = "kana_state" // "KanaState / Province"
        case kanaPostal = "kana_postal_code" // "KanaPostal Code"
        case placeOrderNearDoor = "place_order_near_door"
        case deliveryLocation = "delivery_location"
        case seats = "seats"
        case braintree = "braintree"
    }
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.support_txt = container.safeDecodeValue(forKey: .support_txt)
        self.braintree = container.safeDecodeValue(forKey: .braintree)
        self.todaysTrips = container.safeDecodeValue(forKey: .todaysTrips)
        self.pastTrips = container.safeDecodeValue(forKey: .pastTrips)
        self.completed = container.safeDecodeValue(forKey: .completed)
        self.endTrip = container.safeDecodeValue(forKey: .endTrip)
        self.beginTrip = container.safeDecodeValue(forKey: .beginTrip)
        self.cancelled = container.safeDecodeValue(forKey: .cancelled)
        self.request = container.safeDecodeValue(forKey: .request)
        self.pending = container.safeDecodeValue(forKey: .pending)
        self.scheduled = container.safeDecodeValue(forKey: .scheduled)
        self.payment = container.safeDecodeValue(forKey: .payment)
        self.login = container.safeDecodeValue(forKey: .login)
        self.register = container.safeDecodeValue(forKey: .register)
        self.signup = container.safeDecodeValue(forKey: .signup)
        self.online = container.safeDecodeValue(forKey: .online)
        self.offline = container.safeDecodeValue(forKey: .offline)
        self.checkStatus = container.safeDecodeValue(forKey: .checkStatus)
        self.totalTripsAmount = container.safeDecodeValue(forKey: .totalTripsAmount)
        self.totalPayout = container.safeDecodeValue(forKey: .totalPayout)
        self.tripsPayments = container.safeDecodeValue(forKey: .tripsPayments)
        self.payStatement = container.safeDecodeValue(forKey: .payStatement)
        self.sunday = container.safeDecodeValue(forKey: .sunday)
        self.monday = container.safeDecodeValue(forKey: .monday)
        self.tuesday = container.safeDecodeValue(forKey: .tuesday)
        self.wednesday = container.safeDecodeValue(forKey: .wednesday)
        self.thursday = container.safeDecodeValue(forKey: .thursday)
        self.friday = container.safeDecodeValue(forKey: .friday)
        self.saturday = container.safeDecodeValue(forKey: .saturday)
        self.thisWeek = container.safeDecodeValue(forKey: .thisWeek)
        self.ok = container.safeDecodeValue(forKey: .ok)
        self.m = container.safeDecodeValue(forKey: .m)
        self.tu = container.safeDecodeValue(forKey: .tu)
        self.w = container.safeDecodeValue(forKey: .w)
        self.th = container.safeDecodeValue(forKey: .th)
        self.f = container.safeDecodeValue(forKey: .f)
        self.sa = container.safeDecodeValue(forKey: .sa)
        self.su = container.safeDecodeValue(forKey: .su)
        self.youHaveNotDrivenThisWeek = container.safeDecodeValue(forKey: .youHaveNotDrivenThisWeek)
        self.lastTrip = container.safeDecodeValue(forKey: .lastTrip)
        self.mostRecentPayout = container.safeDecodeValue(forKey: .mostRecentPayout)
        self.lifetimeTrips = container.safeDecodeValue(forKey: .lifetimeTrips)
        self.ratedTrips = container.safeDecodeValue(forKey: .ratedTrips)
        self.fiveStars = container.safeDecodeValue(forKey: .fiveStars)
        self.youHaveNoRatingToDisplay = container.safeDecodeValue(forKey: .youHaveNoRatingToDisplay)
        self.riderFeedback = container.safeDecodeValue(forKey: .riderFeedback)
        self.checkOutFeedbackFromRidersAndLearnHowToImprove = container.safeDecodeValue(forKey: .checkOutFeedbackFromRidersAndLearnHowToImprove)
        self.noVehicleAssigned = container.safeDecodeValue(forKey: .noVehicleAssigned)
        self.referral = container.safeDecodeValue(forKey: .referral)
        self.documents = container.safeDecodeValue(forKey: .documents)
        self.payout = container.safeDecodeValue(forKey: .payout)
        self.bankDetails = container.safeDecodeValue(forKey: .bankDetails)
        self.payToGofer = container.safeDecodeValue(forKey: .payToGofer)
        self.edit = container.safeDecodeValue(forKey: .edit)
        self.view = container.safeDecodeValue(forKey: .view)
        self.signOut = container.safeDecodeValue(forKey: .signOut)
        self.manualBookingReminder = container.safeDecodeValue(forKey: .manualBookingReminder)
        self.manualBookingCancelled = container.safeDecodeValue(forKey: .manualBookingCancelled)
        self.manuallyBookedForRide = container.safeDecodeValue(forKey: .manuallyBookedForRide)
        self.apply = container.safeDecodeValue(forKey: .apply)
        self.amount = container.safeDecodeValue(forKey: .amount)
        self.selectExtraFeeDescription = container.safeDecodeValue(forKey: .selectExtraFeeDescription)
        self.applyExtraFare = container.safeDecodeValue(forKey: .applyExtraFare)
        self.enterExtraFeeDescription = container.safeDecodeValue(forKey: .enterExtraFeeDescription)
        self.enterOtpToBeginTrip = container.safeDecodeValue(forKey: .enterOtpToBeginTrip)
        self.done = container.safeDecodeValue(forKey: .done)
        self.cancel = container.safeDecodeValue(forKey: .cancel)
        self.weeklyStatement = container.safeDecodeValue(forKey: .weeklyStatement)
        self.tripEarnings = container.safeDecodeValue(forKey: .tripEarnings)
        self.baseFare = container.safeDecodeValue(forKey: .baseFare)
        self.accessFee = container.safeDecodeValue(forKey: .accessFee)
        self.totalGoferDriverEarnings = container.safeDecodeValue(forKey: .totalGoferDriverEarnings)
        self.cashCollected = container.safeDecodeValue(forKey: .cashCollected)
        self.tips = container.safeDecodeValue(forKey: .tips)
        self.riderFaresEarnedAndKept = container.safeDecodeValue(forKey: .riderFaresEarnedAndKept)
        self.bankDeposit = container.safeDecodeValue(forKey: .bankDeposit)
        self.completedTrips = container.safeDecodeValue(forKey: .completedTrips)
        self.dailyEarnings = container.safeDecodeValue(forKey: .dailyEarnings)
        self.noDailyEarnings = container.safeDecodeValue(forKey: .noDailyEarnings)
        //self.bankDeposit = container.safeDecodeValue(forKey: .bankDeposit)
        self.noTrips = container.safeDecodeValue(forKey: .noTrips)
        self.tripDetail = container.safeDecodeValue(forKey: .tripDetail)
        self.tripId = container.safeDecodeValue(forKey: .tripId)
        self.duration = container.safeDecodeValue(forKey: .duration)
        self.distance = container.safeDecodeValue(forKey: .distance)
        self.km = container.safeDecodeValue(forKey: .km)
        self.mins = container.safeDecodeValue(forKey: .mins)
        self.tripHistory = container.safeDecodeValue(forKey: .tripHistory)
        //self.pending = container.safeDecodeValue(forKey: .pending)
        //self.completed = container.safeDecodeValue(forKey: .completed)
        self.youHaveNoTodayTrips = container.safeDecodeValue(forKey: .youHaveNoTodayTrips)
        self.youHaveNoPastTrips = container.safeDecodeValue(forKey: .youHaveNoPastTrips)
        self.cancelYourRide = container.safeDecodeValue(forKey: .cancelYourRide)
        self.cancelReason = container.safeDecodeValue(forKey: .cancelReason)
        self.writeYourComment = container.safeDecodeValue(forKey: .writeYourComment)
        self.cancelTrip = container.safeDecodeValue(forKey: .cancelTrip)
        self.riderNoShow = container.safeDecodeValue(forKey: .riderNoShow)
        self.riderRequestedCancel = container.safeDecodeValue(forKey: .riderRequestedCancel)
        self.wrongAddressShown = container.safeDecodeValue(forKey: .wrongAddressShown)
        self.involvedInAnAccident = container.safeDecodeValue(forKey: .involvedInAnAccident)
        self.doNotChargeRider = container.safeDecodeValue(forKey: .doNotChargeRider)
        self.minute = container.safeDecodeValue(forKey: .minute)
        self.minutes = container.safeDecodeValue(forKey: .minutes)
        self.cancellingRequest = container.safeDecodeValue(forKey: .cancellingRequest)
        //self.cancelled = container.safeDecodeValue(forKey: .cancelled)
        self.pleaseEnablePushNotificationInSettingsForRequest = container.safeDecodeValue(forKey: .pleaseEnablePushNotificationInSettingsForRequest)
        self.alreadyAccepted = container.safeDecodeValue(forKey: .alreadyAccepted)
        self.alreadyAcceptedBySomeone = container.safeDecodeValue(forKey: .alreadyAcceptedBySomeone)
        self.selectAPhoto = container.safeDecodeValue(forKey: .selectAPhoto)
        self.takePhoto = container.safeDecodeValue(forKey: .takePhoto)
        self.chooseFromLibrary = container.safeDecodeValue(forKey: .chooseFromLibrary)
        self.firstName = container.safeDecodeValue(forKey: .firstName)
        self.lastName = container.safeDecodeValue(forKey: .lastName)
        self.email = container.safeDecodeValue(forKey: .email)
        self.phoneNumber = container.safeDecodeValue(forKey: .phoneNumber)
        self.addressLine1 = container.safeDecodeValue(forKey: .addressLine1)
        self.addressLine2 = container.safeDecodeValue(forKey: .addressLine2)
        self.city = container.safeDecodeValue(forKey: .city)
        self.postalcode = container.safeDecodeValue(forKey: .postalcode)
        self.state = container.safeDecodeValue(forKey: .state)
        self.addStateAbbrevationegNewyorkNy = container.safeDecodeValue(forKey: .addStateAbbrevationegNewyorkNy)
        self.personalInformation = container.safeDecodeValue(forKey: .personalInformation)
        self.address = container.safeDecodeValue(forKey: .address)
        self.message = container.safeDecodeValue(forKey: .message)
        self.error = container.safeDecodeValue(forKey: .error)
        self.deviceHasNoCamera = container.safeDecodeValue(forKey: .deviceHasNoCamera)
        self.warning = container.safeDecodeValue(forKey: .warning)
        self.pleaseGivePermissionToAccessPhoto = container.safeDecodeValue(forKey: .pleaseGivePermissionToAccessPhoto)
        self.uploadFailedPleaseTryAgain = container.safeDecodeValue(forKey: .uploadFailedPleaseTryAgain)
        self.enRoute = container.safeDecodeValue(forKey: .enRoute)
        self.navigate = container.safeDecodeValue(forKey: .navigate)
        self.cancelTripByDriver = container.safeDecodeValue(forKey: .cancelTripByDriver)
        //self.cancelTrip = container.safeDecodeValue(forKey: .cancelTrip)
        self.hereYouCanChangeYourMap = container.safeDecodeValue(forKey: .hereYouCanChangeYourMap)
        self.byClickingBelowActions = container.safeDecodeValue(forKey: .byClickingBelowActions)
        self.googleMap = container.safeDecodeValue(forKey: .googleMap)
        self.wazeMap = container.safeDecodeValue(forKey: .wazeMap)
        self.doYouWantToAccessDirection = container.safeDecodeValue(forKey: .doYouWantToAccessDirection)
        self.pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem = container.safeDecodeValue(forKey: .pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem)
        //self.doYouWantToAccessDirection = container.safeDecodeValue(forKey: .doYouWantToAccessDirection)
        self.pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem = container.safeDecodeValue(forKey: .pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem)
        self.networkDisconnected = container.safeDecodeValue(forKey: .networkDisconnected)
        self.rateYourRider = container.safeDecodeValue(forKey: .rateYourRider)
        self.submit = container.safeDecodeValue(forKey: .submit)
        self.pickUp = container.safeDecodeValue(forKey: .pickUp)
        self.contact = container.safeDecodeValue(forKey: .contact)
        self.help = container.safeDecodeValue(forKey: .help)
        self.about = container.safeDecodeValue(forKey: .about)
        self.callsOnly = container.safeDecodeValue(forKey: .callsOnly)
        self.call = container.safeDecodeValue(forKey: .call)
        //self.message = container.safeDecodeValue(forKey: .message)
        self.vehicleInformation = container.safeDecodeValue(forKey: .vehicleInformation)
        self.rider = container.safeDecodeValue(forKey: .rider)
        self.typeAMessage = container.safeDecodeValue(forKey: .typeAMessage)
        self.noMessagesYet = container.safeDecodeValue(forKey: .noMessagesYet)
        self.country = container.safeDecodeValue(forKey: .country)
        self.currency = container.safeDecodeValue(forKey: .currency)
        self.bsb = container.safeDecodeValue(forKey: .bsb)
        self.accountNumber = container.safeDecodeValue(forKey: .accountNumber)
        self.accountHolderName = container.safeDecodeValue(forKey: .accountHolderName)
        self.address1 = container.safeDecodeValue(forKey: .address1)
        self.address2 = container.safeDecodeValue(forKey: .address2)
        self.postalCode = container.safeDecodeValue(forKey: .postalCode)
        self.pleaseEnterThe = container.safeDecodeValue(forKey: .pleaseEnterThe)
        self.ibanNumber = container.safeDecodeValue(forKey: .ibanNumber)
        self.sortCode = container.safeDecodeValue(forKey: .sortCode)
        self.branchCode = container.safeDecodeValue(forKey: .branchCode)
        self.clearingCode = container.safeDecodeValue(forKey: .clearingCode)
        self.transitNumber = container.safeDecodeValue(forKey: .transitNumber)
        self.institutionNumber = container.safeDecodeValue(forKey: .institutionNumber)
        self.rountingNumber = container.safeDecodeValue(forKey: .rountingNumber)
        self.bankName = container.safeDecodeValue(forKey: .bankName)
        self.branchName = container.safeDecodeValue(forKey: .branchName)
        self.bankCode = container.safeDecodeValue(forKey: .bankCode)
        self.accountOwnerName = container.safeDecodeValue(forKey: .accountOwnerName)
        self.pleaseUpdateALegalDocument = container.safeDecodeValue(forKey: .pleaseUpdateALegalDocument)
        self.gender = container.safeDecodeValue(forKey: .gender)
        self.male = container.safeDecodeValue(forKey: .male)
        self.female = container.safeDecodeValue(forKey: .female)
        self.payouts = container.safeDecodeValue(forKey: .payouts)
        self.choosePhoto = container.safeDecodeValue(forKey: .choosePhoto)
        //self.deviceHasNoCamera = container.safeDecodeValue(forKey: .deviceHasNoCamera)
        self.alert = container.safeDecodeValue(forKey: .alert)
        self.cameraAccessRequiredForCapturingPhotos = container.safeDecodeValue(forKey: .cameraAccessRequiredForCapturingPhotos)
        self.allowCamera = container.safeDecodeValue(forKey: .allowCamera)
        self.setupYourUberPayoutMethod = container.safeDecodeValue(forKey: .setupYourUberPayoutMethod)
        self.uber = container.safeDecodeValue(forKey: .uber)
        self.add = container.safeDecodeValue(forKey: .add)
        self.emailId = container.safeDecodeValue(forKey: .emailId)
        self.pleaseEnterValidMailId = container.safeDecodeValue(forKey: .pleaseEnterValidMailId)
        self.bicSwiftCode = container.safeDecodeValue(forKey: .bicSwiftCode)
        self.required = container.safeDecodeValue(forKey: .required)
        self.paid = container.safeDecodeValue(forKey: .paid)
        self.waitingForPayment = container.safeDecodeValue(forKey: .waitingForPayment)
        self.proceed = container.safeDecodeValue(forKey: .proceed)
        self.success = container.safeDecodeValue(forKey: .success)
        self.riderSuccessfullyPaid = container.safeDecodeValue(forKey: .riderSuccessfullyPaid)
        self.paymentDetails = container.safeDecodeValue(forKey: .paymentDetails)
        self.paypalEmailId = container.safeDecodeValue(forKey: .paypalEmailId)
        self.save = container.safeDecodeValue(forKey: .save)
        self.toAddANewPayoutCreateAEmailForYour = container.safeDecodeValue(forKey: .toAddANewPayoutCreateAEmailForYour)
        self.account = container.safeDecodeValue(forKey: .account)
        //self.payment = container.safeDecodeValue(forKey: .payment)
        self.addPayoutMethod = container.safeDecodeValue(forKey: .addPayoutMethod)
        self.trip = container.safeDecodeValue(forKey: .trip)
        self.history = container.safeDecodeValue(forKey: .history)
        self.payStatements = container.safeDecodeValue(forKey: .payStatements)
        self.changeCreditOrDebitCard = container.safeDecodeValue(forKey: .changeCreditOrDebitCard)
        self.addCreditOrDebitCard = container.safeDecodeValue(forKey: .addCreditOrDebitCard)
        self.pleaseEnterValidCardDetails = container.safeDecodeValue(forKey: .pleaseEnterValidCardDetails)
        self.pay = container.safeDecodeValue(forKey: .pay)
        self.change = container.safeDecodeValue(forKey: .change)
        self.enterTheAmount = container.safeDecodeValue(forKey: .enterTheAmount)
        self.referralAmount = container.safeDecodeValue(forKey: .referralAmount)
        self.applied = container.safeDecodeValue(forKey: .applied)
        self.addCard = container.safeDecodeValue(forKey: .addCard)
        self.yourPayToGofer = container.safeDecodeValue(forKey: .yourPayToGofer)
        self.getUpto = container.safeDecodeValue(forKey: .getUpto)
        self.forEveryFriendWhoRidesWith = container.safeDecodeValue(forKey: .forEveryFriendWhoRidesWith)
        self.signupGetPaidForEveryReferralSignupMuchMoreBonusAwaits = container.safeDecodeValue(forKey: .signupGetPaidForEveryReferralSignupMuchMoreBonusAwaits)
        self.yourReferralCode = container.safeDecodeValue(forKey: .yourReferralCode)
        self.shareMyCode = container.safeDecodeValue(forKey: .shareMyCode)
        self.referralCopiedToClipBoard = container.safeDecodeValue(forKey: .referralCopiedToClipBoard)
        self.useMyReferral = container.safeDecodeValue(forKey: .useMyReferral)
        self.startYourJourneyOnGoferFromHere = container.safeDecodeValue(forKey: .startYourJourneyOnGoferFromHere)
        self.noReferralsYet = container.safeDecodeValue(forKey: .noReferralsYet)
        self.friendsIncomplete = container.safeDecodeValue(forKey: .friendsIncomplete)
        self.friendsCompleted = container.safeDecodeValue(forKey: .friendsCompleted)
        self.earned = container.safeDecodeValue(forKey: .earned)
        self.referralExpired = container.safeDecodeValue(forKey: .referralExpired)
        self.cash = container.safeDecodeValue(forKey: .cash)
        self.paypal = container.safeDecodeValue(forKey: .paypal)
        self.pleaseEnterThePromoCode = container.safeDecodeValue(forKey: .pleaseEnterThePromoCode)
        self.promotions = container.safeDecodeValue(forKey: .promotions)
        self.wallet = container.safeDecodeValue(forKey: .wallet)
        self.stripeDetails = container.safeDecodeValue(forKey: .stripeDetails)
        self.addressKana = container.safeDecodeValue(forKey: .addressKana)
        self.addressKanji = container.safeDecodeValue(forKey: .addressKanji)
        self.yes = container.safeDecodeValue(forKey: .yes)
        self.no = container.safeDecodeValue(forKey: .no)
        self.pleaseEnterExtraFare = container.safeDecodeValue(forKey: .pleaseEnterExtraFare)
        self.pleaseSelectAnOption = container.safeDecodeValue(forKey: .pleaseSelectAnOption)
        self.pleaseEnterYourComment = container.safeDecodeValue(forKey: .pleaseEnterYourComment)
        self.stripe = container.safeDecodeValue(forKey: .stripe)
        self.defaults = container.safeDecodeValue(forKey: .defaults)
        self.signIn = container.safeDecodeValue(forKey: .signIn)
        self.lookingForTheRiderApp = container.safeDecodeValue(forKey: .lookingForTheRiderApp)
        self.close = container.safeDecodeValue(forKey: .close)
        self.password = container.safeDecodeValue(forKey: .password)
        self.forgotPassword = container.safeDecodeValue(forKey: .forgotPassword)
        self.pleaseEnablePushNotificationInSettingsForContinueToLogin = container.safeDecodeValue(forKey: .pleaseEnablePushNotificationInSettingsForContinueToLogin)
        self.resetPassword = container.safeDecodeValue(forKey: .resetPassword)
        self.confirmPassword = container.safeDecodeValue(forKey: .confirmPassword)
        self.selectYourVehicle = container.safeDecodeValue(forKey: .selectYourVehicle)
        self.chooseVehicleType = container.safeDecodeValue(forKey: .chooseVehicleType)
        self.enterYourVehicleName = container.safeDecodeValue(forKey: .enterYourVehicleName)
        self.enterYourVehicleNumber = container.safeDecodeValue(forKey: .enterYourVehicleNumber)
        self.continues = container.safeDecodeValue(forKey: .continues)
        self.selectACountry = container.safeDecodeValue(forKey: .selectACountry)
        self.search = container.safeDecodeValue(forKey: .search)
        self.pleaseUploadYourDocuments = container.safeDecodeValue(forKey: .pleaseUploadYourDocuments)
        self.verify = container.safeDecodeValue(forKey: .verify)
        self.toDriveWith = container.safeDecodeValue(forKey: .toDriveWith)
        self.referralCodeOptional = container.safeDecodeValue(forKey: .referralCodeOptional)
        self.driversLicenseBackReverse = container.safeDecodeValue(forKey: .driversLicenseBackReverse)
        self.driversLicenseFront = container.safeDecodeValue(forKey: .driversLicenseFront)
        self.motorInsuranceCertificate = container.safeDecodeValue(forKey: .motorInsuranceCertificate)
        self.certificateOfRegistration = container.safeDecodeValue(forKey: .certificateOfRegistration)
        self.contractCarriagePermit = container.safeDecodeValue(forKey: .contractCarriagePermit)
        self.documentSection = container.safeDecodeValue(forKey: .documentSection)
        self.takeAPhotoOfYour = container.safeDecodeValue(forKey: .takeAPhotoOfYour)
        self.pleaseMakeSureWeCanEasilyReadAllTheDetails = container.safeDecodeValue(forKey: .pleaseMakeSureWeCanEasilyReadAllTheDetails)
        self.byContinuingIConfirmThatIHaveReadAndAgreeToTheTermsConditionsAndPrivacyPolicy = container.safeDecodeValue(forKey: .byContinuingIConfirmThatIHaveReadAndAgreeToTheTermsConditionsAndPrivacyPolicy)
        self.termsConditions = container.safeDecodeValue(forKey: .termsConditions)
        self.privacyPolicy = container.safeDecodeValue(forKey: .privacyPolicy)
        self.networkConnectionLost = container.safeDecodeValue(forKey: .networkConnectionLost)
        self.pleaseTryAgain = container.safeDecodeValue(forKey: .pleaseTryAgain)
        self.tapToAdd = container.safeDecodeValue(forKey: .tapToAdd)
        self.mobileNumber = container.safeDecodeValue(forKey: .mobileNumber)
        //self.referralCodeOptional = container.safeDecodeValue(forKey: .referralCodeOptional)
        self.howWouldYouLikeToResetYourPassword = container.safeDecodeValue(forKey: .howWouldYouLikeToResetYourPassword)
        self.mobile = container.safeDecodeValue(forKey: .mobile)
        self.mobileVerification = container.safeDecodeValue(forKey: .mobileVerification)
        self.pleaseEnterYourMobile = container.safeDecodeValue(forKey: .pleaseEnterYourMobile)
        
        self.resendOtp = container.safeDecodeValue(forKey: .resendOtp)
        self.enterOtp = container.safeDecodeValue(forKey: .enterOtp)
        self.weHaveSentYouAccessCodeViaSmsForMobileNumberVerification = container.safeDecodeValue(forKey: .weHaveSentYouAccessCodeViaSmsForMobileNumberVerification)
        self.dintReceiveTheOtp = container.safeDecodeValue(forKey: .dintReceiveTheOtp)
        self.youCanSendOtpAgainIn = container.safeDecodeValue(forKey: .youCanSendOtpAgainIn)
        self.nameOfBank = container.safeDecodeValue(forKey: .nameOfBank)
        self.bankLocation = container.safeDecodeValue(forKey: .bankLocation)
        self.pleaseGiveRating = container.safeDecodeValue(forKey: .pleaseGiveRating)
        self.passwordMismatch = container.safeDecodeValue(forKey: .passwordMismatch)
        self.thoseCredentialsDontLookRightPleaseTryAgain = container.safeDecodeValue(forKey: .thoseCredentialsDontLookRightPleaseTryAgain)
        self.nameexamplecom = container.safeDecodeValue(forKey: .nameexamplecom)
        self.dateOfBirth = container.safeDecodeValue(forKey: .dateOfBirth)
        self.rateYourRide = container.safeDecodeValue(forKey: .rateYourRide)
        //self.beginTrip = container.safeDecodeValue(forKey: .beginTrip)
        //self.endTrip = container.safeDecodeValue(forKey: .endTrip)
        self.confirmYouveArrived = container.safeDecodeValue(forKey: .confirmYouveArrived)
        self.newVersionAvailable = container.safeDecodeValue(forKey: .newVersionAvailable)
        self.pleaseUpdateOurAppToEnjoyTheLatestFeatures = container.safeDecodeValue(forKey: .pleaseUpdateOurAppToEnjoyTheLatestFeatures)
        self.visitAppStore = container.safeDecodeValue(forKey: .visitAppStore)
        self.internalServerErrorPleaseTryAgain = container.safeDecodeValue(forKey: .internalServerErrorPleaseTryAgain)
        self.dropOff = container.safeDecodeValue(forKey: .dropOff)
        self.timelyEarnings = container.safeDecodeValue(forKey: .timelyEarnings)
        
        self.clientNotInitialized = container.safeDecodeValue(forKey: .clientNotInitialized)
        self.jsonSerializationFailed = container.safeDecodeValue(forKey: .jsonSerializationFailed)
        self.noInternetConnection = container.safeDecodeValue(forKey: .noInternetConnection)
        self.driverEarnings = container.safeDecodeValue(forKey: .driverEarnings)

        
        self.connecting = container.safeDecodeValue(forKey: .connecting)
        self.ringing = container.safeDecodeValue(forKey: .ringing)
        self.callEnded = container.safeDecodeValue(forKey: .callEnded)
        //self.nameexamplecom = container.safeDecodeValue(forKey: .nameexamplecom)
        self.enterValidOtp = container.safeDecodeValue(forKey: .enterValidOtp)
        self.locationService = container.safeDecodeValue(forKey: .locationService)
        self.tracking = container.safeDecodeValue(forKey: .tracking)
        self.camera = container.safeDecodeValue(forKey: .camera)
        self.photoLibrary = container.safeDecodeValue(forKey: .photoLibrary)
        self.service = container.safeDecodeValue(forKey: .service)
        self.app = container.safeDecodeValue(forKey: .app)
        self.pleaseEnable = container.safeDecodeValue(forKey: .pleaseEnable)
        self.requires = container.safeDecodeValue(forKey: .requires)
        self.fors = container.safeDecodeValue(forKey: .fors)
        self.functionality = container.safeDecodeValue(forKey: .functionality)
        self.home = container.safeDecodeValue(forKey: .home)
        self.trips = container.safeDecodeValue(forKey: .trips)
        self.earnings = container.safeDecodeValue(forKey: .earnings)
        self.ratings = container.safeDecodeValue(forKey: .ratings)
        //self.account = container.safeDecodeValue(forKey: .account)
        self.swipeTo = container.safeDecodeValue(forKey: .swipeTo)
        self.acceptingPickup = container.safeDecodeValue(forKey: .acceptingPickup)
        //self.request = container.safeDecodeValue(forKey: .request)
        self.rating = container.safeDecodeValue(forKey: .rating)
        //self.scheduled = container.safeDecodeValue(forKey: .scheduled)
        self.microphoneService = container.safeDecodeValue(forKey: .microphoneService)
        self.inAppCall = container.safeDecodeValue(forKey: .inAppCall)
        self.choose = container.safeDecodeValue(forKey: .choose)
        self.choosePaymentMethod = container.safeDecodeValue(forKey: .choosePaymentMethod)
        self.delete = container.safeDecodeValue(forKey: .delete)
        self.whatWouldYouLikeToDo = container.safeDecodeValue(forKey: .whatWouldYouLikeToDo)
        self.update = container.safeDecodeValue(forKey: .update)
        self.makeDefault = container.safeDecodeValue(forKey: .makeDefault)
        self.min = container.safeDecodeValue(forKey: .min)
        self.hr = container.safeDecodeValue(forKey: .hr)
        self.hrs = container.safeDecodeValue(forKey: .hrs)
        self.legalDocument = container.safeDecodeValue(forKey: .legalDocument)
        self.additionalDocument = container.safeDecodeValue(forKey: .additionalDocument)
        self.collectCash = container.safeDecodeValue(forKey: .collectCash)
        self.orderDetails = container.safeDecodeValue(forKey: .orderDetails)
        self.from = container.safeDecodeValue(forKey: .from)
        self.orderId = container.safeDecodeValue(forKey: .orderId)
        self.startTrip = container.safeDecodeValue(forKey: .startTrip)
        self.confirmed = container.safeDecodeValue(forKey: .confirmed)
        self.confirmOrder = container.safeDecodeValue(forKey: .confirmOrder)
        self.orderConfirmed = container.safeDecodeValue(forKey: .orderConfirmed)
        self.orderDelivered = container.safeDecodeValue(forKey: .orderDelivered)
        self.howDidTheDeliveryGo = container.safeDecodeValue(forKey: .howDidTheDeliveryGo)
        self.howDidThePickupGo = container.safeDecodeValue(forKey: .howDidThePickupGo)
        self.distanceFare = container.safeDecodeValue(forKey: .distanceFare)
        self.pickupFare = container.safeDecodeValue(forKey: .pickupFare)
        self.dropFare = container.safeDecodeValue(forKey: .dropFare)
        self.totalTripFare = container.safeDecodeValue(forKey: .totalTripFare)
        self.driverPayout = container.safeDecodeValue(forKey: .driverPayout)
        self.oweAmount = container.safeDecodeValue(forKey: .oweAmount)
        self.detectedOweAmount = container.safeDecodeValue(forKey: .detectedOweAmount)
        self.store = container.safeDecodeValue(forKey: .store)
        self.user = container.safeDecodeValue(forKey: .user)
        self.next = container.safeDecodeValue(forKey: .next)
        self.pickUpOrder = container.safeDecodeValue(forKey: .pickUpOrder)
        self.step = container.safeDecodeValue(forKey: .step)
        self.selectRecipient = container.safeDecodeValue(forKey: .selectRecipient)
        self.leaveAdditionalDetails = container.safeDecodeValue(forKey: .leaveAdditionalDetails)
        self.lookingForTheUserApp = container.safeDecodeValue(forKey: .lookingForTheUserApp)
        self.complete = container.safeDecodeValue(forKey: .complete)
        self.delivered = container.safeDecodeValue(forKey: .delivered)
        self.accepted = container.safeDecodeValue(forKey: .accepted)
        self.declined = container.safeDecodeValue(forKey: .declined)
        self.picked = container.safeDecodeValue(forKey: .picked)
        self.enterThe4DigitCodeSentToYouAt = container.safeDecodeValue(forKey: .enterThe4DigitCodeSentToYouAt)
        self.selectFile = container.safeDecodeValue(forKey: .selectFile)
        self.deliveryInstructions = container.safeDecodeValue(forKey: .deliveryInstructions)
        //self.store = container.safeDecodeValue(forKey: .store)
        self.language = container.safeDecodeValue(forKey: .language)
        self.selectLanguage = container.safeDecodeValue(forKey: .selectLanguage)
        self.updateApp = container.safeDecodeValue(forKey: .updateApp)
        self.networkFailure = container.safeDecodeValue(forKey: .networkFailure)
        self.internalServerError = container.safeDecodeValue(forKey: .internalServerError)
        self.doc = container.safeDecodeValue(forKey: .doc)
        self.personaldoc = container.safeDecodeValue(forKey: .personaldoc)
        self.driverlicenseBack = container.safeDecodeValue(forKey: .driverlicenseBack)
        self.driverlicenseFront = container.safeDecodeValue(forKey: .driverlicenseFront)
        self.logIn = container.safeDecodeValue(forKey: .logIn)
        self.haveAnAccount = container.safeDecodeValue(forKey: .haveAnAccount)
        self.taptochange = container.safeDecodeValue(forKey: .taptochange)
        self.getmobilenumber = container.safeDecodeValue(forKey: .getmobilenumber)
        self.paypalemail = container.safeDecodeValue(forKey: .paypalemail)
        self.orderlist = container.safeDecodeValue(forKey: .orderlist)
        self.noOrderFound = container.safeDecodeValue(forKey: .noOrderFound)
        self.orderInstructions = container.safeDecodeValue(forKey: .orderInstructions)
        self.pickUpOrderInside = container.safeDecodeValue(forKey: .pickUpOrderInside)
        self.droplocation = container.safeDecodeValue(forKey: .droplocation)
        self.resetpasswords = container.safeDecodeValue(forKey: .resetpasswords)
        self.errorMsgVehiclename = container.safeDecodeValue(forKey: .errorMsgVehiclename)
        self.errorMsgVehiclenumber = container.safeDecodeValue(forKey: .errorMsgVehiclenumber)
        self.errorMsgFirstname = container.safeDecodeValue(forKey: .errorMsgFirstname)
        self.errorMsgLastname = container.safeDecodeValue(forKey: .errorMsgLastname)
        self.errorMsgEmail = container.safeDecodeValue(forKey: .errorMsgEmail)
        self.errorMsgPhone = container.safeDecodeValue(forKey: .errorMsgPhone)
        self.errorMsgPassword = container.safeDecodeValue(forKey: .errorMsgPassword)
        self.cameraPermissionDescription = container.safeDecodeValue(forKey: .cameraPermissionDescription)
        self.storagePermissionDescription = container.safeDecodeValue(forKey: .storagePermissionDescription)
        self.locationPermissionDescription = container.safeDecodeValue(forKey: .locationPermissionDescription)
        self.audioPermissionDescription = container.safeDecodeValue(forKey: .audioPermissionDescription)
        self.settings = container.safeDecodeValue(forKey: .settings)
        self.enablePermissionsToProceedFurther = container.safeDecodeValue(forKey: .enablePermissionsToProceedFurther)
        self.notNow = container.safeDecodeValue(forKey: .notNow)
        self.vehicle = container.safeDecodeValue(forKey: .vehicle)
        self.vehicleName = container.safeDecodeValue(forKey: .vehicleName)
        self.vehicleNumber = container.safeDecodeValue(forKey: .vehicleNumber)
        self.signupwithrider = container.safeDecodeValue(forKey: .signupwithrider)
        self.or = container.safeDecodeValue(forKey: .or)
        self.resend = container.safeDecodeValue(forKey: .resend)
        self.otpMismatch = container.safeDecodeValue(forKey: .otpMismatch)
        self.otpEmty = container.safeDecodeValue(forKey: .otpEmty)
        self.InvalidMobileNumber = container.safeDecodeValue(forKey: .InvalidMobileNumber)
        self.Enteryourpassword = container.safeDecodeValue(forKey: .Enteryourpassword)
        self.Confirmyourpassword = container.safeDecodeValue(forKey: .Confirmyourpassword)
        self.profile = container.safeDecodeValue(forKey: .profile)
        self.payoutDetails = container.safeDecodeValue(forKey: .payoutDetails)
        self.pickup = container.safeDecodeValue(forKey: .pickup)
        self.stateProvince = container.safeDecodeValue(forKey: .stateProvince)
        self.ssn = container.safeDecodeValue(forKey: .ssn)
        self.routingNumber = container.safeDecodeValue(forKey: .routingNumber)
        self.instituteNumber = container.safeDecodeValue(forKey: .instituteNumber)
        self.streetHint = container.safeDecodeValue(forKey: .streetHint)
        self.aptHint = container.safeDecodeValue(forKey: .aptHint)
        self.cityHint = container.safeDecodeValue(forKey: .cityHint)
        self.stateHint = container.safeDecodeValue(forKey: .stateHint)
        self.pinHint = container.safeDecodeValue(forKey: .pinHint)
        self.deflang = container.safeDecodeValue(forKey: .deflang)
        self.riderfeedback = container.safeDecodeValue(forKey: .riderfeedback)
        self.checkfeedback = container.safeDecodeValue(forKey: .checkfeedback)
        self.drivingstyle = container.safeDecodeValue(forKey: .drivingstyle)
        self.seeyourdriving = container.safeDecodeValue(forKey: .seeyourdriving)
        self.tripStar5 = container.safeDecodeValue(forKey: .tripStar5)
        self.addpayment = container.safeDecodeValue(forKey: .addpayment)
        self.addpayout = container.safeDecodeValue(forKey: .addpayout)
        self.addpaymentMsg = container.safeDecodeValue(forKey: .addpaymentMsg)
        self.timefare = container.safeDecodeValue(forKey: .timefare)
        self.deliveryfee = container.safeDecodeValue(forKey: .deliveryfee)
        self.pickupaddress = container.safeDecodeValue(forKey: .pickupaddress)
        self.dropaddress = container.safeDecodeValue(forKey: .dropaddress)
        self.order = container.safeDecodeValue(forKey: .order)
        self.payoutTitle = container.safeDecodeValue(forKey: .payoutTitle)
        self.payoutLink = container.safeDecodeValue(forKey: .payoutLink)
        self.payoutMsg = container.safeDecodeValue(forKey: .payoutMsg)
        self.enterAmount = container.safeDecodeValue(forKey: .enterAmount)
        self.enterAmountEmpty = container.safeDecodeValue(forKey: .enterAmountEmpty)
        self.deliverto = container.safeDecodeValue(forKey: .deliverto)
        self.paymentOption = container.safeDecodeValue(forKey: .paymentOption)
        self.totalnumbers = container.safeDecodeValue(forKey: .totalnumbers)
        self.totalnumber = container.safeDecodeValue(forKey: .totalnumber)
        self.timeonline = container.safeDecodeValue(forKey: .timeonline)
        self.driverActivated = container.safeDecodeValue(forKey: .driverActivated)
        self.enteredAmtMsg = container.safeDecodeValue(forKey: .enteredAmtMsg)
        self.selectCountry = container.safeDecodeValue(forKey: .selectCountry)
        self.selectCurrency = container.safeDecodeValue(forKey: .selectCurrency)
        self.logout = container.safeDecodeValue(forKey: .logout)
        self.restaurant = container.safeDecodeValue(forKey: .restaurant)
        self.quantity = container.safeDecodeValue(forKey: .quantity)
        self.items = container.safeDecodeValue(forKey: .items)
        self.step2Rating = container.safeDecodeValue(forKey: .step2Rating)
        self.step1SelectRecipient = container.safeDecodeValue(forKey: .step1SelectRecipient)
        self.signTerm1 = container.safeDecodeValue(forKey: .signTerm1)
        self.signTerm2 = container.safeDecodeValue(forKey: .signTerm2)
        self.signTerm3 = container.safeDecodeValue(forKey: .signTerm3)
        self.signTerm5 = container.safeDecodeValue(forKey: .signTerm5)
        self.penalty = container.safeDecodeValue(forKey: .penalty)
        self.notes = container.safeDecodeValue(forKey: .notes)
        self.totalEarnings = container.safeDecodeValue(forKey: .totalEarnings)
        self.loading = container.safeDecodeValue(forKey: .loading)
        self.addPhoto = container.safeDecodeValue(forKey: .addPhoto)
        self.pleaseChooseCurrency = container.safeDecodeValue(forKey: .pleaseChooseCurrency)
        self.pleaseEnterIban = container.safeDecodeValue(forKey: .pleaseEnterIban)
        self.pleaseEnterAccountHolderName = container.safeDecodeValue(forKey: .pleaseEnterAccountHolderName)
        self.pleaseEnterAddress1 = container.safeDecodeValue(forKey: .pleaseEnterAddress1)
        self.pleaseEnterAddress2 = container.safeDecodeValue(forKey: .pleaseEnterAddress2)
        self.pleaseEnterCity = container.safeDecodeValue(forKey: .pleaseEnterCity)
        self.pleaseEnterState = container.safeDecodeValue(forKey: .pleaseEnterState)
        self.pleaseEnterPostalCode = container.safeDecodeValue(forKey: .pleaseEnterPostalCode)
        self.pleaseUploadLegalDoc = container.safeDecodeValue(forKey: .pleaseUploadLegalDoc)
        self.pleaseEnterAccountNumber = container.safeDecodeValue(forKey: .pleaseEnterAccountNumber)
        self.pleaseEnterBsb = container.safeDecodeValue(forKey: .pleaseEnterBsb)
        self.pleaseEnterRoutingNumber = container.safeDecodeValue(forKey: .pleaseEnterRoutingNumber)
        self.pleaseEnterBankCode = container.safeDecodeValue(forKey: .pleaseEnterBankCode)
        self.pleaseEnterBranchCode = container.safeDecodeValue(forKey: .pleaseEnterBranchCode)
        self.pleaseEnterSortCode = container.safeDecodeValue(forKey: .pleaseEnterSortCode)
        self.pleaseEnterSsn = container.safeDecodeValue(forKey: .pleaseEnterSsn)
        self.pleaseEnterClearingCode = container.safeDecodeValue(forKey: .pleaseEnterClearingCode)
        self.pleaseEnterBankName = container.safeDecodeValue(forKey: .pleaseEnterBankName)
        self.pleaseEnterBranchName = container.safeDecodeValue(forKey: .pleaseEnterBranchName)
        self.pleaseEnterAccountOwnerName = container.safeDecodeValue(forKey: .pleaseEnterAccountOwnerName)
        self.pleaseEnterPhoneNumber = container.safeDecodeValue(forKey: .pleaseEnterPhoneNumber)
        self.pleaseChooseGender = container.safeDecodeValue(forKey: .pleaseChooseGender)
        self.pleaseEnterAddress1OfKana = container.safeDecodeValue(forKey: .pleaseEnterAddress1OfKana)
        self.pleaseEnterAddress2OfKana = container.safeDecodeValue(forKey: .pleaseEnterAddress2OfKana)
        self.pleaseEnterCityOfKana = container.safeDecodeValue(forKey: .pleaseEnterCityOfKana)
        self.pleaseEnterStateOfKana = container.safeDecodeValue(forKey: .pleaseEnterStateOfKana)
        self.pleaseEnterPostalcodeOfKana = container.safeDecodeValue(forKey: .pleaseEnterPostalcodeOfKana)
        self.pleaseEnterAddress1OfKanji = container.safeDecodeValue(forKey: .pleaseEnterAddress1OfKanji)
        self.pleaseEnterAddress2OfKanji = container.safeDecodeValue(forKey: .pleaseEnterAddress2OfKanji)
        self.pleaseEnterCityOfKanji = container.safeDecodeValue(forKey: .pleaseEnterCityOfKanji)
        self.pleaseEnterStateOfKanji = container.safeDecodeValue(forKey: .pleaseEnterStateOfKanji)
        self.pleaseEnterPostalcodeOfKanji = container.safeDecodeValue(forKey: .pleaseEnterPostalcodeOfKanji)
        self.pleaseEnterAddressName = container.safeDecodeValue(forKey: .pleaseEnterAddressName)
        self.pleaseEnterAccountName = container.safeDecodeValue(forKey: .pleaseEnterAccountName)
        self.pleaseChooseCountry = container.safeDecodeValue(forKey: .pleaseChooseCountry)
        self.profileUpdatedSuccessfully = container.safeDecodeValue(forKey: .profileUpdatedSuccessfully)
        self.imageUploadSuccessfully = container.safeDecodeValue(forKey: .imageUploadSuccessfully)
        self.pressBack = container.safeDecodeValue(forKey: .pressBack)
        self.mobileValidation = container.safeDecodeValue(forKey: .mobileValidation)
        self.stripeError1 = container.safeDecodeValue(forKey: .stripeError1)
        self.setCanceled = container.safeDecodeValue(forKey: .setCanceled)
        self.paymentFailed = container.safeDecodeValue(forKey: .paymentFailed)
        self.errorAddress = container.safeDecodeValue(forKey: .errorAddress)
        self.errorCity = container.safeDecodeValue(forKey: .errorCity)
        self.errorZipCode = container.safeDecodeValue(forKey: .errorZipCode)
        self.errorCountry = container.safeDecodeValue(forKey: .errorCountry)
        self.pleaseEnterTransitNumber = container.safeDecodeValue(forKey: .pleaseEnterTransitNumber)
        self.pleaseEnterInstitutionNumber = container.safeDecodeValue(forKey: .pleaseEnterInstitutionNumber)
        self.addphoto = container.safeDecodeValue(forKey: .addphoto)
        self.enablePermission = container.safeDecodeValue(forKey: .enablePermission)
        self.selectgender = container.safeDecodeValue(forKey: .selectgender)
        self.showpassword = container.safeDecodeValue(forKey: .showpassword)
        self.externalStoragePermissionNecessary = container.safeDecodeValue(forKey: .externalStoragePermissionNecessary)
        self.select = container.safeDecodeValue(forKey: .select)
        self.addStateAbbreviationEGNewYorkNy = container.safeDecodeValue(forKey: .addStateAbbreviationEGNewYorkNy)
        self.updatedsucessfully = container.safeDecodeValue(forKey: .updatedsucessfully)
        self.pleaseUploadAdditionalDocument = container.safeDecodeValue(forKey: .pleaseUploadAdditionalDocument)
        self.setdob = container.safeDecodeValue(forKey: .setdob)
        self.pleasePickOrder = container.safeDecodeValue(forKey: .pleasePickOrder)
        self.chooseMap = container.safeDecodeValue(forKey: .chooseMap)
        self.googleMapNotFoundInDevice = container.safeDecodeValue(forKey: .googleMapNotFoundInDevice)
        self.wazeGoogleMapNotFoundInDevice = container.safeDecodeValue(forKey: .wazeGoogleMapNotFoundInDevice)
        self.vehicledocMsg = container.safeDecodeValue(forKey: .vehicledocMsg)
        self.notrip = container.safeDecodeValue(forKey: .notrip)
        self.tipsFare = container.safeDecodeValue(forKey: .tipsFare)
        self.totaluberearning = container.safeDecodeValue(forKey: .totaluberearning)
        self.riderfaresearn = container.safeDecodeValue(forKey: .riderfaresearn)
        self.addStripePayout = container.safeDecodeValue(forKey: .addStripePayout)
        self.addBankPayout = container.safeDecodeValue(forKey: .addBankPayout)
        self.addPaypalPayout = container.safeDecodeValue(forKey: .addPaypalPayout)
        self.selectVehicle = container.safeDecodeValue(forKey: .selectVehicle)
        self.cameraRoll = container.safeDecodeValue(forKey: .cameraRoll)
        self.pleaseEnablePermissions = container.safeDecodeValue(forKey: .pleaseEnablePermissions)
        self.pleaseEnableLocation = container.safeDecodeValue(forKey: .pleaseEnableLocation)
        self.tripCancelDriver = container.safeDecodeValue(forKey: .tripCancelDriver)
        self.orderNotReady = container.safeDecodeValue(forKey: .orderNotReady)
        self.pickUpFrom = container.safeDecodeValue(forKey: .pickUpFrom)
        self.sender = container.safeDecodeValue(forKey: .sender)
        self.recipient = container.safeDecodeValue(forKey: .recipient)
        self.ordersConfirmed = container.safeDecodeValue(forKey: .ordersConfirmed)
        self.confirmdropoff = container.safeDecodeValue(forKey: .confirmdropoff)
        self.completetrip = container.safeDecodeValue(forKey: .completetrip)
        self.dropoffConfirmed = container.safeDecodeValue(forKey: .dropoffConfirmed)
        self.leaveYourComments = container.safeDecodeValue(forKey: .leaveYourComments)
        self.otherReasons = container.safeDecodeValue(forKey: .otherReasons)
        self.cancelOrder = container.safeDecodeValue(forKey: .cancelOrder)
        self.selectReason = container.safeDecodeValue(forKey: .selectReason)
        self.file = container.safeDecodeValue(forKey: .file)
        self.support = container.safeDecodeValue(forKey: .support)
        self.appName = container.safeDecodeValue(forKey: .appName)
        self.kanaAddress1 = container.safeDecodeValue(forKey: .kanaAddress1)
        self.kanaAddress2 = container.safeDecodeValue(forKey: .kanaAddress2)
        self.kanaCity = container.safeDecodeValue(forKey: .kanaCity)
        self.kanaState = container.safeDecodeValue(forKey: .kanaState)
        self.kanaPostal = container.safeDecodeValue(forKey: .kanaPostal)
        self.placeOrderNearDoor = container.safeDecodeValue(forKey: .placeOrderNearDoor)
        self.deliveryLocation = container.safeDecodeValue(forKey: .deliveryLocation)
        self.seats = container.safeDecodeValue(forKey: .seats)
    }
    
    init() {
        self.support_txt = ""
        self.todaysTrips = ""
        self.pastTrips = ""
        self.completed = ""
        self.endTrip = ""
        self.beginTrip = ""
        self.cancelled = ""
        self.request = ""
        self.pending = ""
        self.scheduled = ""
        self.payment = ""
        self.login = ""
        self.register = ""
        self.signup = ""
        self.online = ""
        self.offline = ""
        self.checkStatus = ""
        self.totalTripsAmount = ""
        self.totalPayout = ""
        self.tripsPayments = ""
        self.payStatement = ""
        self.sunday = ""
        self.monday = ""
        self.tuesday = ""
        self.wednesday = ""
        self.thursday = ""
        self.friday = ""//
        self.saturday = ""//container.safeDecodeValue(forKey: .saturday)
        self.thisWeek = ""//container.safeDecodeValue(forKey: .thisWeek)
        self.ok = ""//container.safeDecodeValue(forKey: .ok)
        self.m = ""//container.safeDecodeValue(forKey: .m)
        self.tu = ""//container.safeDecodeValue(forKey: .tu)
        self.w = ""//container.safeDecodeValue(forKey: .w)
        self.th = ""//container.safeDecodeValue(forKey: .th)
        self.f = ""//container.safeDecodeValue(forKey: .f)
        self.sa = ""//container.safeDecodeValue(forKey: .sa)
        self.su = ""//container.safeDecodeValue(forKey: .su)
        self.youHaveNotDrivenThisWeek = ""//container.safeDecodeValue(forKey: .youHaveNotDrivenThisWeek)
        self.lastTrip = ""//container.safeDecodeValue(forKey: .lastTrip)
        self.mostRecentPayout = ""//container.safeDecodeValue(forKey: .mostRecentPayout)
        self.lifetimeTrips = ""//container.safeDecodeValue(forKey: .lifetimeTrips)
        self.ratedTrips = ""//container.safeDecodeValue(forKey: .ratedTrips)
        self.fiveStars = ""//container.safeDecodeValue(forKey: .fiveStars)
        self.youHaveNoRatingToDisplay = ""//container.safeDecodeValue(forKey: .youHaveNoRatingToDisplay)
        self.riderFeedback = ""//container.safeDecodeValue(forKey: .riderFeedback)
        self.checkOutFeedbackFromRidersAndLearnHowToImprove = ""//container.safeDecodeValue(forKey: .checkOutFeedbackFromRidersAndLearnHowToImprove)
        self.noVehicleAssigned = ""//container.safeDecodeValue(forKey: .noVehicleAssigned)
        self.referral = ""//container.safeDecodeValue(forKey: .referral)
        self.documents = ""//container.safeDecodeValue(forKey: .documents)
        self.payout = ""//container.safeDecodeValue(forKey: .payout)
        self.bankDetails = ""//container.safeDecodeValue(forKey: .bankDetails)
        self.payToGofer = ""//container.safeDecodeValue(forKey: .payToGofer)
        self.edit = ""//container.safeDecodeValue(forKey: .edit)
        self.view = ""//container.safeDecodeValue(forKey: .view)
        self.signOut = ""//container.safeDecodeValue(forKey: .signOut)
        self.manualBookingReminder = ""//container.safeDecodeValue(forKey: .manualBookingReminder)
        self.manualBookingCancelled = ""//container.safeDecodeValue(forKey: .manualBookingCancelled)
        self.manuallyBookedForRide = ""//container.safeDecodeValue(forKey: .manuallyBookedForRide)
        self.apply = ""//container.safeDecodeValue(forKey: .apply)
        self.amount = ""//container.safeDecodeValue(forKey: .amount)
        self.selectExtraFeeDescription = ""//container.safeDecodeValue(forKey: .selectExtraFeeDescription)
        self.applyExtraFare = ""//container.safeDecodeValue(forKey: .applyExtraFare)
        self.enterExtraFeeDescription = ""//container.safeDecodeValue(forKey: .enterExtraFeeDescription)
        self.enterOtpToBeginTrip = ""//container.safeDecodeValue(forKey: .enterOtpToBeginTrip)
        self.done = ""//container.safeDecodeValue(forKey: .done)
        self.cancel = ""//container.safeDecodeValue(forKey: .cancel)
        self.weeklyStatement = ""//container.safeDecodeValue(forKey: .weeklyStatement)
        self.tripEarnings = ""//container.safeDecodeValue(forKey: .tripEarnings)
        self.baseFare = ""//container.safeDecodeValue(forKey: .baseFare)
        self.accessFee = ""//container.safeDecodeValue(forKey: .accessFee)
        self.totalGoferDriverEarnings = ""//container.safeDecodeValue(forKey: .totalGoferDriverEarnings)
        self.cashCollected = ""//container.safeDecodeValue(forKey: .cashCollected)
        self.tips = ""//container.safeDecodeValue(forKey: .tips)
        self.riderFaresEarnedAndKept = ""//container.safeDecodeValue(forKey: .riderFaresEarnedAndKept)
        self.bankDeposit = ""//container.safeDecodeValue(forKey: .bankDeposit)
        self.completedTrips = ""//container.safeDecodeValue(forKey: .completedTrips)
        self.dailyEarnings = ""//container.safeDecodeValue(forKey: .dailyEarnings)
        self.noDailyEarnings = ""//container.safeDecodeValue(forKey: .noDailyEarnings)
        //self.bankDeposit = container.safeDecodeValue(forKey: .bankDeposit)
        self.noTrips = ""//container.safeDecodeValue(forKey: .noTrips)
        self.tripDetail = ""//container.safeDecodeValue(forKey: .tripDetail)
        self.tripId = ""//container.safeDecodeValue(forKey: .tripId)
        self.duration = ""//container.safeDecodeValue(forKey: .duration)
        self.distance = ""//container.safeDecodeValue(forKey: .distance)
        self.km = ""//container.safeDecodeValue(forKey: .km)
        self.mins = ""//container.safeDecodeValue(forKey: .mins)
        self.tripHistory = ""//container.safeDecodeValue(forKey: .tripHistory)
        //self.pending = container.safeDecodeValue(forKey: .pending)
        //self.completed = container.safeDecodeValue(forKey: .completed)
        self.youHaveNoTodayTrips = ""//container.safeDecodeValue(forKey: .youHaveNoTodayTrips)
        self.youHaveNoPastTrips = ""//container.safeDecodeValue(forKey: .youHaveNoPastTrips)
        self.cancelYourRide = ""//container.safeDecodeValue(forKey: .cancelYourRide)
        self.cancelReason = ""//ontainer.safeDecodeValue(forKey: .cancelReason)
        self.writeYourComment = ""//container.safeDecodeValue(forKey: .writeYourComment)
        self.cancelTrip = ""//container.safeDecodeValue(forKey: .cancelTrip)
        self.riderNoShow = ""//container.safeDecodeValue(forKey: .riderNoShow)
        self.riderRequestedCancel = ""//ontainer.safeDecodeValue(forKey: .riderRequestedCancel)
        self.wrongAddressShown = ""//container.safeDecodeValue(forKey: .wrongAddressShown)
        self.involvedInAnAccident = ""//container.safeDecodeValue(forKey: .involvedInAnAccident)
        self.doNotChargeRider = ""//container.safeDecodeValue(forKey: .doNotChargeRider)
        self.minute = ""//container.safeDecodeValue(forKey: .minute)
        self.minutes = ""//container.safeDecodeValue(forKey: .minutes)
        self.cancellingRequest = ""//container.safeDecodeValue(forKey: .cancellingRequest)
        //self.cancelled = container.safeDecodeValue(forKey: .cancelled)
        self.pleaseEnablePushNotificationInSettingsForRequest = ""//container.safeDecodeValue(forKey: .pleaseEnablePushNotificationInSettingsForRequest)
        self.alreadyAccepted = ""//container.safeDecodeValue(forKey: .alreadyAccepted)
        self.alreadyAcceptedBySomeone = ""//container.safeDecodeValue(forKey: .alreadyAcceptedBySomeone)
        self.selectAPhoto = ""//container.safeDecodeValue(forKey: .selectAPhoto)
        self.takePhoto = ""//container.safeDecodeValue(forKey: .takePhoto)
        self.chooseFromLibrary = ""//container.safeDecodeValue(forKey: .chooseFromLibrary)
        self.firstName = ""//container.safeDecodeValue(forKey: .firstName)
        self.lastName = ""//container.safeDecodeValue(forKey: .lastName)
        self.email = ""//container.safeDecodeValue(forKey: .email)
        self.phoneNumber = ""//container.safeDecodeValue(forKey: .phoneNumber)
        self.addressLine1 = ""//container.safeDecodeValue(forKey: .addressLine1)
        self.addressLine2 = ""//container.safeDecodeValue(forKey: .addressLine2)
        self.city = ""//container.safeDecodeValue(forKey: .city)
        self.postalcode = ""//container.safeDecodeValue(forKey: .postalcode)
        self.state = ""//container.safeDecodeValue(forKey: .state)
        self.addStateAbbrevationegNewyorkNy = ""//container.safeDecodeValue(forKey: .addStateAbbrevationegNewyorkNy)
        self.personalInformation = ""//container.safeDecodeValue(forKey: .personalInformation)
        self.address = ""//container.safeDecodeValue(forKey: .address)
        self.message = ""//container.safeDecodeValue(forKey: .message)
        self.error = ""//container.safeDecodeValue(forKey: .error)
        self.deviceHasNoCamera = ""//container.safeDecodeValue(forKey: .deviceHasNoCamera)
        self.warning = ""//container.safeDecodeValue(forKey: .warning)
        self.pleaseGivePermissionToAccessPhoto  = ""// container.safeDecodeValue(forKey: .pleaseGivePermissionToAccessPhoto)
        self.uploadFailedPleaseTryAgain = ""//container.safeDecodeValue(forKey: .uploadFailedPleaseTryAgain)
        self.enRoute = "En Route"//container.safeDecodeValue(forKey: .enRoute)
        self.navigate = ""//container.safeDecodeValue(forKey: .navigate)
        self.cancelTripByDriver = ""//container.safeDecodeValue(forKey: .cancelTripByDriver)
        //self.cancelTrip = container.safeDecodeValue(forKey: .cancelTrip)
        self.hereYouCanChangeYourMap = ""//container.safeDecodeValue(forKey: .hereYouCanChangeYourMap)
        self.byClickingBelowActions = ""//container.safeDecodeValue(forKey: .byClickingBelowActions)
        self.googleMap = ""//container.safeDecodeValue(forKey: .googleMap)
        self.wazeMap = ""//container.safeDecodeValue(forKey: .wazeMap)
        self.doYouWantToAccessDirection = ""//container.safeDecodeValue(forKey: .doYouWantToAccessDirection)
        self.pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem = ""//container.safeDecodeValue(forKey: .pleaseInstallGoogleMapsAppThenOnlyYouGetTheDirectionForThisItem)
        //self.doYouWantToAccessDirection = container.safeDecodeValue(forKey: .doYouWantToAccessDirection)
        self.pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem = ""//container.safeDecodeValue(forKey: .pleaseInstallWazeMapsAppThenOnlyYouGetTheDirectionForThisItem)
        self.networkDisconnected = ""//container.safeDecodeValue(forKey: .networkDisconnected)
        self.rateYourRider = ""//container.safeDecodeValue(forKey: .rateYourRider)
        self.submit = ""//container.safeDecodeValue(forKey: .submit)
        self.pickUp = ""//container.safeDecodeValue(forKey: .pickUp)
        self.contact = ""//container.safeDecodeValue(forKey: .contact)
        self.help = ""//container.safeDecodeValue(forKey: .help)
        self.about = ""//container.safeDecodeValue(forKey: .about)
        self.callsOnly = ""//container.safeDecodeValue(forKey: .callsOnly)
        self.call = ""//container.safeDecodeValue(forKey: .call)
        //self.message = container.safeDecodeValue(forKey: .message)
        self.vehicleInformation = ""//container.safeDecodeValue(forKey: .vehicleInformation)
        self.rider = ""//container.safeDecodeValue(forKey: .rider)
        self.typeAMessage = ""//container.safeDecodeValue(forKey: .typeAMessage)
        self.noMessagesYet = ""//container.safeDecodeValue(forKey: .noMessagesYet)
        self.country = ""//container.safeDecodeValue(forKey: .country)
        self.currency = ""//container.safeDecodeValue(forKey: .currency)
        self.bsb = ""//container.safeDecodeValue(forKey: .bsb)
        self.accountNumber = ""//container.safeDecodeValue(forKey: .accountNumber)
        self.accountHolderName = ""//container.safeDecodeValue(forKey: .accountHolderName)
        self.address1 = ""//container.safeDecodeValue(forKey: .address1)
        self.address2 = ""//container.safeDecodeValue(forKey: .address2)
        self.postalCode = ""//container.safeDecodeValue(forKey: .postalCode)
        self.pleaseEnterThe = ""//container.safeDecodeValue(forKey: .pleaseEnterThe)
        self.ibanNumber = ""//container.safeDecodeValue(forKey: .ibanNumber)
        self.sortCode = ""//container.safeDecodeValue(forKey: .sortCode)
        self.branchCode = ""//container.safeDecodeValue(forKey: .branchCode)
        self.clearingCode = ""//container.safeDecodeValue(forKey: .clearingCode)
        self.transitNumber = ""//container.safeDecodeValue(forKey: .transitNumber)
        self.institutionNumber = ""//container.safeDecodeValue(forKey: .institutionNumber)
        self.rountingNumber = ""//container.safeDecodeValue(forKey: .rountingNumber)
        self.bankName = ""//ontainer.safeDecodeValue(forKey: .bankName)
        self.branchName = ""//container.safeDecodeValue(forKey: .branchName)
        self.bankCode = ""//container.safeDecodeValue(forKey: .bankCode)
        self.accountOwnerName = ""//container.safeDecodeValue(forKey: .accountOwnerName)
        self.pleaseUpdateALegalDocument = ""//container.safeDecodeValue(forKey: .pleaseUpdateALegalDocument)
        self.gender = ""//container.safeDecodeValue(forKey: .gender)
        self.male = ""//container.safeDecodeValue(forKey: .male)
        self.female = ""//container.safeDecodeValue(forKey: .female)
        self.payouts = ""//container.safeDecodeValue(forKey: .payouts)
        self.choosePhoto = ""//container.safeDecodeValue(forKey: .choosePhoto)
        //self.deviceHasNoCamera = container.safeDecodeValue(forKey: .deviceHasNoCamera)
        self.alert = ""//container.safeDecodeValue(forKey: .alert)
        self.cameraAccessRequiredForCapturingPhotos = ""//container.safeDecodeValue(forKey: .cameraAccessRequiredForCapturingPhotos)
        self.allowCamera = ""//container.safeDecodeValue(forKey: .allowCamera)
        self.setupYourUberPayoutMethod = ""//container.safeDecodeValue(forKey: .setupYourUberPayoutMethod)
        self.uber = ""//container.safeDecodeValue(forKey: .uber)
        self.add = ""//container.safeDecodeValue(forKey: .add)
        self.emailId = ""//container.safeDecodeValue(forKey: .emailId)
        self.pleaseEnterValidMailId = ""//container.safeDecodeValue(forKey: .pleaseEnterValidMailId)
        self.bicSwiftCode = ""//container.safeDecodeValue(forKey: .bicSwiftCode)
        self.required = ""//container.safeDecodeValue(forKey: .required)
        self.paid = ""//container.safeDecodeValue(forKey: .paid)
        self.waitingForPayment = ""//container.safeDecodeValue(forKey: .waitingForPayment)
        self.proceed = ""//container.safeDecodeValue(forKey: .proceed)
        self.success = ""//container.safeDecodeValue(forKey: .success)
        self.riderSuccessfullyPaid = ""//container.safeDecodeValue(forKey: .riderSuccessfullyPaid)
        self.paymentDetails = ""//container.safeDecodeValue(forKey: .paymentDetails)
        self.paypalEmailId = ""//container.safeDecodeValue(forKey: .paypalEmailId)
        self.save = ""//container.safeDecodeValue(forKey: .save)
        self.toAddANewPayoutCreateAEmailForYour = ""//container.safeDecodeValue(forKey: .toAddANewPayoutCreateAEmailForYour)
        self.account = ""//container.safeDecodeValue(forKey: .account)
        //self.payment = container.safeDecodeValue(forKey: .payment)
        self.addPayoutMethod = ""//container.safeDecodeValue(forKey: .addPayoutMethod)
        self.trip = ""//container.safeDecodeValue(forKey: .trip)
        self.history = ""//container.safeDecodeValue(forKey: .history)
        self.payStatements = ""//container.safeDecodeValue(forKey: .payStatements)
        self.changeCreditOrDebitCard = ""//container.safeDecodeValue(forKey: .changeCreditOrDebitCard)
        self.addCreditOrDebitCard = ""//container.safeDecodeValue(forKey: .addCreditOrDebitCard)
        self.pleaseEnterValidCardDetails = ""//container.safeDecodeValue(forKey: .pleaseEnterValidCardDetails)
        self.pay = ""//container.safeDecodeValue(forKey: .pay)
        self.change = ""//container.safeDecodeValue(forKey: .change)
        self.enterTheAmount = ""//container.safeDecodeValue(forKey: .enterTheAmount)
        self.referralAmount = ""//container.safeDecodeValue(forKey: .referralAmount)
        self.applied = ""//container.safeDecodeValue(forKey: .applied)
        self.addCard = ""//container.safeDecodeValue(forKey: .addCard)
        self.yourPayToGofer = ""//container.safeDecodeValue(forKey: .yourPayToGofer)
        self.getUpto = ""//container.safeDecodeValue(forKey: .getUpto)
        self.forEveryFriendWhoRidesWith = ""//container.safeDecodeValue(forKey: .forEveryFriendWhoRidesWith)
        self.signupGetPaidForEveryReferralSignupMuchMoreBonusAwaits = ""// container.safeDecodeValue(forKey: .signupGetPaidForEveryReferralSignupMuchMoreBonusAwaits)
        self.yourReferralCode = ""//container.safeDecodeValue(forKey: .yourReferralCode)
        self.shareMyCode = ""//container.safeDecodeValue(forKey: .shareMyCode)
        self.referralCopiedToClipBoard = ""//container.safeDecodeValue(forKey: .referralCopiedToClipBoard)
        self.useMyReferral = ""//container.safeDecodeValue(forKey: .useMyReferral)
        self.startYourJourneyOnGoferFromHere = ""//container.safeDecodeValue(forKey: .startYourJourneyOnGoferFromHere)
        self.noReferralsYet = ""//container.safeDecodeValue(forKey: .noReferralsYet)
        self.friendsIncomplete = ""//container.safeDecodeValue(forKey: .friendsIncomplete)
        self.friendsCompleted = ""//container.safeDecodeValue(forKey: .friendsCompleted)
        self.earned = ""//container.safeDecodeValue(forKey: .earned)
        self.referralExpired = ""//container.safeDecodeValue(forKey: .referralExpired)
        self.cash = ""//container.safeDecodeValue(forKey: .cash)
        self.paypal = ""//container.safeDecodeValue(forKey: .paypal)
        self.pleaseEnterThePromoCode = ""//container.safeDecodeValue(forKey: .pleaseEnterThePromoCode)
        self.promotions = ""//container.safeDecodeValue(forKey: .promotions)
        self.wallet = ""//container.safeDecodeValue(forKey: .wallet)
        self.stripeDetails = ""//container.safeDecodeValue(forKey: .stripeDetails)
        self.addressKana = ""// container.safeDecodeValue(forKey: .addressKana)
        self.addressKanji = ""//container.safeDecodeValue(forKey: .addressKanji)
        self.yes = ""//container.safeDecodeValue(forKey: .yes)
        self.no = ""//container.safeDecodeValue(forKey: .no)
        self.pleaseEnterExtraFare = ""//container.safeDecodeValue(forKey: .pleaseEnterExtraFare)
        self.pleaseSelectAnOption = ""//container.safeDecodeValue(forKey: .pleaseSelectAnOption)
        self.pleaseEnterYourComment = ""//container.safeDecodeValue(forKey: .pleaseEnterYourComment)
        self.stripe = ""//container.safeDecodeValue(forKey: .stripe)
        self.defaults = ""//ontainer.safeDecodeValue(forKey: .defaults)
        self.signIn = ""//container.safeDecodeValue(forKey: .signIn)
        self.lookingForTheRiderApp = ""//container.safeDecodeValue(forKey: .lookingForTheRiderApp)
        self.close = ""//container.safeDecodeValue(forKey: .close)
        self.password = ""//container.safeDecodeValue(forKey: .password)
        self.forgotPassword = ""//container.safeDecodeValue(forKey: .forgotPassword)
        self.pleaseEnablePushNotificationInSettingsForContinueToLogin = ""//container.safeDecodeValue(forKey: .pleaseEnablePushNotificationInSettingsForContinueToLogin)
        self.resetPassword = ""//container.safeDecodeValue(forKey: .resetPassword)
        self.confirmPassword = ""//container.safeDecodeValue(forKey: .confirmPassword)
        self.selectYourVehicle = ""//container.safeDecodeValue(forKey: .selectYourVehicle)
        self.chooseVehicleType = ""//container.safeDecodeValue(forKey: .chooseVehicleType)
        self.enterYourVehicleName = ""//container.safeDecodeValue(forKey: .enterYourVehicleName)
        self.enterYourVehicleNumber = ""//ontainer.safeDecodeValue(forKey: .enterYourVehicleNumber)
        self.continues = ""//container.safeDecodeValue(forKey: .continues)
        self.selectACountry = ""//container.safeDecodeValue(forKey: .selectACountry)
        self.search = ""//container.safeDecodeValue(forKey: .search)
        self.pleaseUploadYourDocuments = ""//container.safeDecodeValue(forKey: .pleaseUploadYourDocuments)
        self.verify = ""//container.safeDecodeValue(forKey: .verify)
        self.toDriveWith = ""//container.safeDecodeValue(forKey: .toDriveWith)
        self.referralCodeOptional = ""//container.safeDecodeValue(forKey: .referralCodeOptional)
        self.driversLicenseBackReverse = ""//container.safeDecodeValue(forKey: .driversLicenseBackReverse)
        self.driversLicenseFront = ""//container.safeDecodeValue(forKey: .driversLicenseFront)
        self.motorInsuranceCertificate = ""//container.safeDecodeValue(forKey: .motorInsuranceCertificate)
        self.certificateOfRegistration = ""//container.safeDecodeValue(forKey: .certificateOfRegistration)
        self.contractCarriagePermit = ""//container.safeDecodeValue(forKey: .contractCarriagePermit)
        self.documentSection = ""//container.safeDecodeValue(forKey: .documentSection)
        self.takeAPhotoOfYour = ""//container.safeDecodeValue(forKey: .takeAPhotoOfYour)
        self.pleaseMakeSureWeCanEasilyReadAllTheDetails = ""//container.safeDecodeValue(forKey: .pleaseMakeSureWeCanEasilyReadAllTheDetails)
        self.byContinuingIConfirmThatIHaveReadAndAgreeToTheTermsConditionsAndPrivacyPolicy = ""//.safeDecodeValue(forKey: .byContinuingIConfirmThatIHaveReadAndAgreeToTheTermsConditionsAndPrivacyPolicy)
        self.termsConditions = ""//container.safeDecodeValue(forKey: .termsConditions)
        self.privacyPolicy = ""//container.safeDecodeValue(forKey: .privacyPolicy)
        self.networkConnectionLost = ""//ontainer.safeDecodeValue(forKey: .networkConnectionLost)
        self.pleaseTryAgain = ""//container.safeDecodeValue(forKey: .pleaseTryAgain)
        self.tapToAdd = ""//container.safeDecodeValue(forKey: .tapToAdd)
        self.mobileNumber = ""//container.safeDecodeValue(forKey: .mobileNumber)
        //self.referralCodeOptional = container.safeDecodeValue(forKey: .referralCodeOptional)
        self.howWouldYouLikeToResetYourPassword = ""//container.safeDecodeValue(forKey: .howWouldYouLikeToResetYourPassword)
        self.mobile = ""//container.safeDecodeValue(forKey: .mobile)
        self.mobileVerification = ""//container.safeDecodeValue(forKey: .mobileVerification)
        self.pleaseEnterYourMobile = ""//container.safeDecodeValue(forKey: .pleaseEnterYourMobile)
        
        self.resendOtp = ""//container.safeDecodeValue(forKey: .resendOtp)
        self.enterOtp = ""//container.safeDecodeValue(forKey: .enterOtp)
        self.weHaveSentYouAccessCodeViaSmsForMobileNumberVerification = ""//container.safeDecodeValue(forKey: .weHaveSentYouAccessCodeViaSmsForMobileNumberVerification)
        self.dintReceiveTheOtp = ""// container.safeDecodeValue(forKey: .dintReceiveTheOtp)
        self.youCanSendOtpAgainIn = ""//container.safeDecodeValue(forKey: .youCanSendOtpAgainIn)
        self.nameOfBank = ""//container.safeDecodeValue(forKey: .nameOfBank)
        self.bankLocation = ""//container.safeDecodeValue(forKey: .bankLocation)
        self.pleaseGiveRating = ""//container.safeDecodeValue(forKey: .pleaseGiveRating)
        self.passwordMismatch = ""//container.safeDecodeValue(forKey: .passwordMismatch)
        self.thoseCredentialsDontLookRightPleaseTryAgain = ""//container.safeDecodeValue(forKey: .thoseCredentialsDontLookRightPleaseTryAgain)
        self.nameexamplecom = ""//container.safeDecodeValue(forKey: .nameexamplecom)
        self.dateOfBirth = ""//container.safeDecodeValue(forKey: .dateOfBirth)
        self.rateYourRide = ""// container.safeDecodeValue(forKey: .rateYourRide)
        //self.beginTrip = container.safeDecodeValue(forKey: .beginTrip)
        //self.endTrip = container.safeDecodeValue(forKey: .endTrip)
        self.confirmYouveArrived = ""//container.safeDecodeValue(forKey: .confirmYouveArrived)
        self.newVersionAvailable = ""//container.safeDecodeValue(forKey: .newVersionAvailable)
        self.pleaseUpdateOurAppToEnjoyTheLatestFeatures = ""//container.safeDecodeValue(forKey: .pleaseUpdateOurAppToEnjoyTheLatestFeatures)
        self.visitAppStore = ""//container.safeDecodeValue(forKey: .visitAppStore)
        self.internalServerErrorPleaseTryAgain = ""//container.safeDecodeValue(forKey: .internalServerErrorPleaseTryAgain)
        self.dropOff = ""// container.safeDecodeValue(forKey: .dropOff)
        self.timelyEarnings = ""//container.safeDecodeValue(forKey: .timelyEarnings)
        
        self.clientNotInitialized = ""//container.safeDecodeValue(forKey: .clientNotInitialized)
        self.jsonSerializationFailed = ""//container.safeDecodeValue(forKey: .jsonSerializationFailed)
        self.noInternetConnection = ""//container.safeDecodeValue(forKey: .noInternetConnection)
        self.driverEarnings = ""//container.safeDecodeValue(forKey: .driverEarnings)

        
        self.connecting = ""//container.safeDecodeValue(forKey: .connecting)
        self.ringing = ""//container.safeDecodeValue(forKey: .ringing)
        self.callEnded = ""//container.safeDecodeValue(forKey: .callEnded)
        //self.nameexamplecom = container.safeDecodeValue(forKey: .nameexamplecom)
        self.enterValidOtp = ""//container.safeDecodeValue(forKey: .enterValidOtp)
        self.locationService = ""//container.safeDecodeValue(forKey: .locationService)
        self.tracking = ""//container.safeDecodeValue(forKey: .tracking)
        self.camera = ""//container.safeDecodeValue(forKey: .camera)
        self.photoLibrary = ""//container.safeDecodeValue(forKey: .photoLibrary)
        self.service = ""//container.safeDecodeValue(forKey: .service)
        self.app = ""//container.safeDecodeValue(forKey: .app)
        self.pleaseEnable = ""//container.safeDecodeValue(forKey: .pleaseEnable)
        self.requires = ""//container.safeDecodeValue(forKey: .requires)
        self.fors = ""//container.safeDecodeValue(forKey: .fors)
        self.functionality = ""//container.safeDecodeValue(forKey: .functionality)
        self.home = ""//container.safeDecodeValue(forKey: .home)
        self.trips = ""//container.safeDecodeValue(forKey: .trips)
        self.earnings = ""//container.safeDecodeValue(forKey: .earnings)
        self.ratings = ""//container.safeDecodeValue(forKey: .ratings)
        //self.account = container.safeDecodeValue(forKey: .account)
        self.swipeTo = ""//container.safeDecodeValue(forKey: .swipeTo)
        self.acceptingPickup = ""//container.safeDecodeValue(forKey: .acceptingPickup)
        //self.request = container.safeDecodeValue(forKey: .request)
        self.rating = ""// container.safeDecodeValue(forKey: .rating)
        //self.scheduled = container.safeDecodeValue(forKey: .scheduled)
        self.microphoneService = ""// container.safeDecodeValue(forKey: .microphoneService)
        self.inAppCall = ""//container.safeDecodeValue(forKey: .inAppCall)
        self.choose = ""//container.safeDecodeValue(forKey: .choose)
        self.choosePaymentMethod = ""// container.safeDecodeValue(forKey: .choosePaymentMethod)
        self.delete = ""//container.safeDecodeValue(forKey: .delete)
        self.whatWouldYouLikeToDo = ""//container.safeDecodeValue(forKey: .whatWouldYouLikeToDo)
        self.update = ""//container.safeDecodeValue(forKey: .update)
        self.makeDefault = ""//container.safeDecodeValue(forKey: .makeDefault)
        self.min = ""//container.safeDecodeValue(forKey: .min)
        self.hr = ""//container.safeDecodeValue(forKey: .hr)
        self.hrs = ""//container.safeDecodeValue(forKey: .hrs)
        self.legalDocument = ""//container.safeDecodeValue(forKey: .legalDocument)
        self.additionalDocument = ""//container.safeDecodeValue(forKey: .additionalDocument)
        self.collectCash = ""//container.safeDecodeValue(forKey: .collectCash)
        self.orderDetails = ""//c""//ontainer.safeDecodeValue(forKey: .orderDetails)
        self.from = ""//container.safeDecodeValue(forKey: .from)
        self.orderId = ""//container.safeDecodeValue(forKey: .orderId)
        self.startTrip = ""//container.safeDecodeValue(forKey: .startTrip)
        self.confirmed = ""//container.safeDecodeValue(forKey: .confirmed)
        self.confirmOrder = ""//container.safeDecodeValue(forKey: .confirmOrder)
        self.orderConfirmed = " "// container.safeDecodeValue(forKey: .orderConfirmed)
        self.orderDelivered = ""//container.safeDecodeValue(forKey: .orderDelivered)
        self.howDidTheDeliveryGo = ""//container.safeDecodeValue(forKey: .howDidTheDeliveryGo)
        self.howDidThePickupGo = ""//container.safeDecodeValue(forKey: .howDidThePickupGo)
        self.distanceFare = ""//container.safeDecodeValue(forKey: .distanceFare)
        self.pickupFare = ""//ontainer.safeDecodeValue(forKey: .pickupFare)
        self.dropFare = ""//container.safeDecodeValue(forKey: .dropFare)
        self.totalTripFare = ""//container.safeDecodeValue(forKey: .totalTripFare)
        self.driverPayout = ""//container.safeDecodeValue(forKey: .driverPayout)
        self.oweAmount = ""//container.safeDecodeValue(forKey: .oweAmount)
        self.detectedOweAmount = ""//container.safeDecodeValue(forKey: .detectedOweAmount)
        self.store = ""//container.safeDecodeValue(forKey: .store)
        self.user = ""//container.safeDecodeValue(forKey: .user)
        self.next = ""// container.safeDecodeValue(forKey: .next)
        self.pickUpOrder = ""//container.safeDecodeValue(forKey: .pickUpOrder)
        self.step = ""//container.safeDecodeValue(forKey: .step)
        self.selectRecipient = ""//container.safeDecodeValue(forKey: .selectRecipient)
        self.leaveAdditionalDetails = ""//container.safeDecodeValue(forKey: .leaveAdditionalDetails)
        self.lookingForTheUserApp = ""//container.safeDecodeValue(forKey: .lookingForTheUserApp)
        self.complete = ""//container.safeDecodeValue(forKey: .complete)
        self.delivered = ""//container.safeDecodeValue(forKey: .delivered)
        self.accepted = ""//container.safeDecodeValue(forKey: .accepted)
        self.declined = ""//container.safeDecodeValue(forKey: .declined)
        self.picked = ""//container.safeDecodeValue(forKey: .picked)
        self.enterThe4DigitCodeSentToYouAt = ""//container.safeDecodeValue(forKey: .enterThe4DigitCodeSentToYouAt)
        self.selectFile = ""//container.safeDecodeValue(forKey: .selectFile)
        self.deliveryInstructions = ""//container.safeDecodeValue(forKey: .deliveryInstructions)
        //self.store = container.safeDecodeValue(forKey: .store)
        self.language = ""//ontainer.safeDecodeValue(forKey: .language)
        self.selectLanguage = ""//container.safeDecodeValue(forKey: .selectLanguage)
        self.updateApp = ""//container.safeDecodeValue(forKey: .updateApp)
        self.networkFailure = ""//container.safeDecodeValue(forKey: .networkFailure)
        self.internalServerError = ""//container.safeDecodeValue(forKey: .internalServerError)
        self.doc = ""// container.safeDecodeValue(forKey: .doc)
        self.personaldoc = ""// container.safeDecodeValue(forKey: .personaldoc)
        self.driverlicenseBack = ""//container.safeDecodeValue(forKey: .driverlicenseBack)
        self.driverlicenseFront = ""//container.safeDecodeValue(forKey: .driverlicenseFront)
        self.logIn = ""//container.safeDecodeValue(forKey: .logIn)
        self.haveAnAccount = ""//container.safeDecodeValue(forKey: .haveAnAccount)
        self.taptochange = ""//container.safeDecodeValue(forKey: .taptochange)
        self.getmobilenumber = ""//container.safeDecodeValue(forKey: .getmobilenumber)
        self.paypalemail = ""//container.safeDecodeValue(forKey: .paypalemail)
        self.orderlist = ""//container.safeDecodeValue(forKey: .orderlist)
        self.noOrderFound = ""//container.safeDecodeValue(forKey: .noOrderFound)
        self.orderInstructions = ""//container.safeDecodeValue(forKey: .orderInstructions)
        self.pickUpOrderInside = ""//container.safeDecodeValue(forKey: .pickUpOrderInside)
        self.droplocation = ""//container.safeDecodeValue(forKey: .droplocation)
        self.resetpasswords = ""//container.safeDecodeValue(forKey: .resetpasswords)
        self.errorMsgVehiclename = ""//container.safeDecodeValue(forKey: .errorMsgVehiclename)
        self.errorMsgVehiclenumber = ""//container.safeDecodeValue(forKey: .errorMsgVehiclenumber)
        self.errorMsgFirstname = ""//container.safeDecodeValue(forKey: .errorMsgFirstname)
        self.errorMsgLastname = ""//container.safeDecodeValue(forKey: .errorMsgLastname)
        self.errorMsgEmail = ""//container.safeDecodeValue(forKey: .errorMsgEmail)
        self.errorMsgPhone = ""//container.safeDecodeValue(forKey: .errorMsgPhone)
        self.errorMsgPassword = ""//container.safeDecodeValue(forKey: .errorMsgPassword)
        self.cameraPermissionDescription = ""//container.safeDecodeValue(forKey: .cameraPermissionDescription)
        self.storagePermissionDescription = ""//container.safeDecodeValue(forKey: .storagePermissionDescription)
        self.locationPermissionDescription = ""//container.safeDecodeValue(forKey: .locationPermissionDescription)
        self.audioPermissionDescription = ""//container.safeDecodeValue(forKey: .audioPermissionDescription)
        self.settings = ""//container.safeDecodeValue(forKey: .settings)
        self.enablePermissionsToProceedFurther = ""//container.safeDecodeValue(forKey: .enablePermissionsToProceedFurther)
        self.notNow = ""//container.safeDecodeValue(forKey: .notNow)
        self.vehicle = ""//container.safeDecodeValue(forKey: .vehicle)
        self.vehicleName = ""//container.safeDecodeValue(forKey: .vehicleName)
        self.vehicleNumber = ""//container.safeDecodeValue(forKey: .vehicleNumber)
        self.signupwithrider = ""//container.safeDecodeValue(forKey: .signupwithrider)
        self.or = ""//container.safeDecodeValue(forKey: .or)
        self.resend = ""//container.safeDecodeValue(forKey: .resend)
        self.otpMismatch = ""//container.safeDecodeValue(forKey: .otpMismatch)
        self.otpEmty = ""//container.safeDecodeValue(forKey: .otpEmty)
        self.InvalidMobileNumber = ""//container.safeDecodeValue(forKey: .InvalidMobileNumber)
        self.Enteryourpassword = ""//container.safeDecodeValue(forKey: .Enteryourpassword)
        self.Confirmyourpassword = ""//container.safeDecodeValue(forKey: .Confirmyourpassword)
        self.profile = ""////ontainer.safeDecodeValue(forKey: .profile)
        self.payoutDetails = ""//container.safeDecodeValue(forKey: .payoutDetails)
        self.pickup = ""//container.safeDecodeValue(forKey: .pickup)
        self.stateProvince = ""//container.safeDecodeValue(forKey: .stateProvince)
        self.ssn = ""//container.safeDecodeValue(forKey: .ssn)
        self.routingNumber = ""//container.safeDecodeValue(forKey: .routingNumber)
        self.instituteNumber = ""//container.safeDecodeValue(forKey: .instituteNumber)
        self.streetHint = ""//container.safeDecodeValue(forKey: .streetHint)
        self.aptHint = ""//.safeDecodeValue(forKey: .aptHint)
        self.cityHint = ""//container.safeDecodeValue(forKey: .cityHint)
        self.stateHint = ""//container.safeDecodeValue(forKey: .stateHint)
        self.pinHint = ""//.safeDecodeValue(forKey: .pinHint)
        self.deflang = ""//.safeDecodeValue(forKey: .deflang)
        self.riderfeedback = ""//""////ntainer.safeDecodeValue(forKey: .riderfeedback)
        self.checkfeedback = ""//.safeDecodeValue(forKey: .checkfeedback)
        self.drivingstyle = ""//.safeDecodeValue(forKey: .drivingstyle)
        self.seeyourdriving = ""//.safeDecodeValue(forKey: .seeyourdriving)
        self.tripStar5 = ""//.safeDecodeValue(forKey: .tripStar5)
        self.addpayment = ""//.safeDecodeValue(forKey: .addpayment)
        self.addpayout = ""//.safeDecodeValue(forKey: .addpayout)
        self.addpaymentMsg = ""//.safeDecodeValue(forKey: .addpaymentMsg)
        self.timefare = ""//.safeDecodeValue(forKey: .timefare)
        self.deliveryfee = ""//.safeDecodeValue(forKey: .deliveryfee)
        self.pickupaddress = ""//.safeDecodeValue""//
        self.dropaddress = ""//.safeDecodeValue(forKey: .dropaddress)
        self.order = ""//.safeDecodeValue(forKey: .order)
        self.payoutTitle = ""//.safeDecodeValue(forKey: .payoutTitle)
        self.payoutLink = ""//.safeDecodeValue(forKey: .payoutLink)
        self.payoutMsg = ""//""//iner.safeDecodeValue(forKey: .payoutMsg)
        self.enterAmount = ""//.safeDecodeValue(forKey: .enterAmount)
        self.enterAmountEmpty = ""//.safeDecodeValue(forKey: .enterAmountEmpty)
        self.deliverto = ""//.safeDecodeValue(forKey: .deliverto)
        self.paymentOption = ""//.safeDecodeValue(forKey: .paymentOption)
        self.totalnumbers = ""//.safeDecodeValue(forKey: .totalnumbers)
        self.totalnumber = ""//.safeDecodeValue(forKey: .totalnumber)
        self.timeonline = ""//.safeDecodeValue(forKey: .timeonline)
        self.driverActivated = ""//.safeDecodeValue(forKey: .driverActivated)
        self.enteredAmtMsg = ""//.safeDecodeValue(forKey: .enteredAmtMsg)
        self.selectCountry = ""//.safeDecodeValue(forKey: .selectCountry)
        self.selectCurrency = ""//.safeDecodeValue(forKey: .selectCurrency)
        self.logout = ""//.""//(forKey: .logout)
        self.restaurant = ""//.safeDecodeValue(forKey: .restaurant)
        self.quantity = ""//""//er.safeDecodeValue(forKey: .quantity)
        self.items = ""//.safeDecodeValue(forKey: .items)
        self.step2Rating = ""//.safeDecodeValue(forKey: .step2Rating)
        self.step1SelectRecipient = ""//.safeDecodeValue(forKey: .step1SelectRecipient)
        self.signTerm1 = ""//
        self.signTerm2 = ""///ner.safeDecodeValue(forKey: .signTerm2)
        self.signTerm3 = ""//.safeDecodeValue(forKey: .signTerm3)
        self.signTerm5 = ""//.safeDecodeValue(forKey: .signTerm5)
        self.penalty = ""//.safeDecodeValue(forKey: .penalty)
        self.notes = ""//.safeDecodeValue(forKey: .notes)
        self.totalEarnings = ""//""//ntainer.safeDecodeValue(forKey: .totalEarnings)
        self.loading = ""//.safeDecodeValue(forKey: .loading)
        self.addPhoto = ""//.safeDecodeValue(forKey: .addPhoto)
        self.pleaseChooseCurrency = ""//.safeDecodeValue(forKey: .pleaseChooseCurrency)
        self.pleaseEnterIban = ""//.safeDecodeValue(forKey: .pleaseEnterIban)
        self.pleaseEnterAccountHolderName = ""//.safeDecodeValue(forKey: .pleaseEnterAccountHolderName)
        self.pleaseEnterAddress1 = ""//.safeDecodeValue(forKey: .pleaseEnterAddress1)
        self.pleaseEnterAddress2 = ""//.safeDecodeValue(forKey: .pleaseEnterAddress2)
        self.pleaseEnterCity = ""//.safeDecodeValue(forKey: .pleaseEnterCity)
        self.pleaseEnterState = ""//.safeDecodeValue(forKey: .pleaseEnterState)
        self.pleaseEnterPostalCode = ""//.safeDecodeValue(forKey: .pleaseEnterPostalCode)
        self.pleaseUploadLegalDoc = ""//.safeDecodeValue(forKey: .pleaseUploadLegalDoc)
        self.pleaseEnterAccountNumber = ""//.safeDecodeValue(forKey: .pleaseEnterAccountNumber)
        self.pleaseEnterBsb = ""//.""//(forKey: .pleaseEnterBsb)
        self.pleaseEnterRoutingNumber = ""//.safeDecodeValue(forKey: .pleaseEnterRoutingNumber)
        self.pleaseEnterBankCode = ""//.safeDecodeValue(forKey: .pleaseEnterBankCode)
        self.pleaseEnterBranchCode = ""//.safeDecodeValue(forKey: .pleaseEnterBranchCode)
        self.pleaseEnterSortCode = ""//.safeDecodeValue(forKey: .pleaseEnterSortCode)
        self.pleaseEnterSsn = ""//.safeDecodeValue(forKey: .pleaseEnterSsn)
        self.pleaseEnterClearingCode = ""//.safeDecodeValue(forKey: .pleaseEnterClearingCode)
        self.pleaseEnterBankName = ""//.safeDecodeValue(forKey: .pleaseEnterBankName)
        self.pleaseEnterBranchName = ""//.safeDecodeValue(forKey: .pleaseEnterBranchName)
        self.pleaseEnterAccountOwnerName = ""//.safeDecodeValue(forKey: .pleaseEnterAccountOwnerName)
        self.pleaseEnterPhoneNumber = ""//.safeDecodeValue(forKey: .pleaseEnterPhoneNumber)
        self.pleaseChooseGender = ""//.""//(forKey: .pleaseChooseGender)
        self.pleaseEnterAddress1OfKana = ""//.safeDecodeValue(forKey: .pleaseEnterAddress1OfKana)
        self.pleaseEnterAddress2OfKana = ""//.safeDecodeValue(forKey: .pleaseEnterAddress2OfKana)
        self.pleaseEnterCityOfKana = ""//.safeDecodeValue(forKey: .pleaseEnterCityOfKana)
        self.pleaseEnterStateOfKana = ""//""//i""//ner.safeDecodeValue(forKey: .pleaseEnterStateOfKana)
        self.pleaseEnterPostalcodeOfKana = ""////ontainer.safeDecodeValue(forKey: .pleaseEnterPostalcodeOfKana)
        self.pleaseEnterAddress1OfKanji = ""//.safeDecodeValue(forKey: .pleaseEnterAddress1OfKanji)
        self.pleaseEnterAddress2OfKanji = ""//.safeDecodeValue(forKey: .pleaseEnterAddress2OfKanji)
        self.pleaseEnterCityOfKanji = ""//.safeDecodeValue(forKey: .pleaseEnterCityOfKanji)
        self.pleaseEnterStateOfKanji = ""//.safeDecodeValue(forKey: .pleaseEnterStateOfKanji)
        self.pleaseEnterPostalcodeOfKanji = ""//.safeDecodeValue(forKey: .pleaseEnterPostalcodeOfKanji)
        self.pleaseEnterAddressName = ""//""//er.safeDecodeValue(forKey: .pleaseEnterAddressName)
        self.pleaseEnterAccountName = ""//.safeDecodeValue(forKey: .pleaseEnterAccountName)
        self.pleaseChooseCountry = ""//.safeDecodeValue(forKey: .pleaseChooseCountry)
        self.profileUpdatedSuccessfully = ""//""//iner.safeDecodeValue(forKey: .profileUpdatedSuccessfully)
        self.imageUploadSuccessfully = ""//.safeDecodeValue(forKey: .imageUploadSuccessfully)
        self.pressBack = ""//.""//(forKey: .pressBack)
        self.mobileValidation = ""//.safeDecodeValue(forKey: .mobileValidation)
        self.stripeError1 = ""//.safeDecodeValue(forKey: .stripeError1)
        self.setCanceled = ""//.safeDecodeValue(forKey: .setCanceled)
        self.paymentFailed = ""//.safeDecodeValue(forKey: .paymentFailed)
        self.errorAddress = ""//.safeDecodeValue(forKey: .errorAddress)
        self.errorCity = ""//.safeDecodeValue(forKey: .errorCity)
        self.errorZipCode = ""//.safeDecodeValue(forKey: .errorZipCode)
        self.errorCountry = ""//.safeDecodeValue(forKey: .errorCountry)
        self.pleaseEnterTransitNumber = ""//.safeDecodeValue(forKey: .pleaseEnterTransitNumber)
        self.pleaseEnterInstitutionNumber = ""//.safeDecodeValue(forKey: .pleaseEnterInstitutionNumber)
        self.addphoto = ""//.safeDecodeValue(forKey: .addphoto)
        self.enablePermission = ""//.safeDecodeValue(forKey: .enablePermission)
        self.selectgender = ""//.safeDecodeValue(forKey: .selectgender)
        self.showpassword = ""//""//ner.safeDecodeValue(forKey: .showpassword)
        self.externalStoragePermissionNecessary = ""//""////ntainer.safeDecodeValue(forKey: .externalStoragePermissionNecessary)
        self.select = ""//.safeDecodeValue(forKey: .select)
        self.addStateAbbreviationEGNewYorkNy = ""//.safeDecodeValue(forKey: .addStateAbbreviationEGNewYorkNy)
        self.updatedsucessfully = ""//.safeDecodeValue(forKey: .updatedsucessfully)
        self.pleaseUploadAdditionalDocument = ""//.safeDecodeValue(forKey: .pleaseUploadAdditionalDocument)
        self.setdob = ""//.safeDecodeValue(forKey: .setdob)
        self.pleasePickOrder = ""//.safeDecodeValue(forKey: .pleasePickOrder)
        self.chooseMap = ""//.safeDecodeValue(forKey: .chooseMap)
        self.googleMapNotFoundInDevice = ""//.safeDecodeValue(forKey: .googleMapNotFoundInDevice)
        self.wazeGoogleMapNotFoundInDevice = ""//
        self.vehicledocMsg = ""//.safeDecodeValue(forKey: .vehicledocMsg)
        self.notrip = ""//.safeDecodeValue(forKey: .notrip)
        self.tipsFare = ""//.safeDecodeValue(forKey: .tipsFare)
        self.totaluberearning = ""//.safeDecodeValue(forKey: .totaluberearning)
        self.riderfaresearn = ""//""//ner.safeDecodeValue(forKey: .riderfaresearn)
        self.addStripePayout = ""//.safeDecodeValue(forKey: .addStripePayout)
        self.addBankPayout = ""//.safeDecodeValue(forKey: .addBankPayout)
        self.addPaypalPayout = ""//""//.safeDecodeValue(forKey: .addPaypalPayout)
        self.selectVehicle = ""//.safeDecodeValue(forKey: .selectVehicle)
        self.cameraRoll = ""//""//.safeDecodeValue(forKey: .cameraRoll)
        self.pleaseEnablePermissions = ""//.safeDecodeValue(forKey: .pleaseEnablePermissions)
        self.pleaseEnableLocation = ""//.safeDecodeValue(forKey: .pleaseEnableLocation)
        self.tripCancelDriver = ""//""//er.safeDecodeValue(forKey: .tripCancelDriver)
        self.orderNotReady = ""//.safeDecodeValue(forKey: .orderNotReady)
        self.pickUpFrom = ""//.safeDecodeValue(forKey: .pickUpFrom)
        self.sender = ""//.safeDecodeValue(forKey: .sender)
        self.recipient = ""//.safeDecodeValue(forKey: .recipient)
        self.ordersConfirmed = ""//.safeDecodeValue(forKey: .ordersConfirmed)
        self.confirmdropoff = ""//.safeDecodeValue(forKey: .confirmdropoff)
        self.completetrip = ""//.safeDecodeValue(forKey: .completetrip)
        self.dropoffConfirmed = ""//.safeDecodeValue(forKey: .dropoffConfirmed)
        self.leaveYourComments = ""//.safeDecodeValue(forKey: .leaveYourComments)
        self.otherReasons = ""//.safeDecodeValue(forKey: .otherReasons)
        self.cancelOrder = ""//""//iner.safeDecodeValue(forKey: .cancelOrder)
        self.selectReason = ""//.safeDecodeValue(forKey: .selectReason)
        self.file = ""//.safeDecodeValue(forKey: .file)
        self.support = ""//""//ntainer.safeDecodeValue(forKey: .support)
        self.appName = ""//.safeDecodeValue(forKey: .appName)
        self.kanaAddress1 = ""//.safeDecodeValue(forKey: .kanaAddress1)
        self.kanaAddress2 = ""//
        self.kanaCity = ""//.safeDecodeValue(forKey: .kanaCity)
        self.kanaState = ""//.safeDecodeValue(forKey: .kanaState)
        self.kanaPostal = ""//.safeDecodeValue(forKey: .kanaPostal)
        self.placeOrderNearDoor = ""
        self.deliveryLocation = ""
        self.seats = 0
        self.braintree = ""
    }
    
    
}


// MARK: - Delivery
class Laundry: Codable {
    let vieworderImage : String
    let yourorderImage : String
    
    init() {
        self.vieworderImage  = ""
        self.yourorderImage  = ""
    }
    
    enum CodingKeys : String,CodingKey {
        case vieworderImage = "view_order_image"
        case yourorderImage = "your_orderimage"
    }
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vieworderImage = container.safeDecodeValue(forKey: .vieworderImage)
        self.yourorderImage = container.safeDecodeValue(forKey: .yourorderImage)
    }
}


// MARK: - Language
class Language: Codable {
    let key ,lang : String
    let isRTL: Bool

    enum CodingKeys : String,CodingKey {
        case key,lang = "Lang",isRTL = "is_rtl"
    }
    
    init() {
        self.key = "en"
        self.lang = "English"
        self.isRTL = false
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = container.safeDecodeValue(forKey: .key)
        self.lang = container.safeDecodeValue(forKey: .lang)
        self.isRTL = container.safeDecodeValue(forKey: .isRTL)
    }
    //MARK:-UDF
      func saveLanguage(){
          UserDefaults.set(self.key,for: .default_language_option)
          UserDefaults.standard.set(self.key, forKey:  "lang")
          UserDefaults.standard.set([self.key], forKey: "AppleLanguages")
          Bundle.setLanguage(self.key)
      }
}
// MARK: - Equatable
extension Language : Equatable{
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.key == rhs.key
    }
    
    
}

