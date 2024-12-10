////
////  LangProtocal.swift
////  Luggaru
////
////  Created by Trioangle on 29/07/19.
////  Copyright © 2019 Trioangle Technologies. All rights reserved.
////
//
import Foundation

protocol LanguageProtocol
{
    var completedStatus : String {get set}
    var endTripStatus : String {get set}
    var beginTripStatus : String {get set}
    var cancelledStatus : String {get set}
    var reqStatus : String {get set}
    var pendingStatus : String {get set}
    var sheduledStatus : String {get set}
    var paymentStatus : String {get set}
    var login : String {get set}
    var register : String {get set}
    var signUp : String {get set}
    var online : String {get set}
    var offline : String {get set}
    var checkStatus : String {get set}
    var totalTripAmount : String {get set}
    var totalPayout : String {get set}
    var tripsPayment : String {get set}
    var payStatement : String {get set}
    var sunday : String {get set}
    var monday : String {get set}
    var tuesday : String {get set}
    var wednesday : String {get set}
    var thursday : String {get set}
    var friday : String {get set}
    var saturday : String {get set}
    var week : String {get set}
    var ok : String {get set}
    var m : String {get set}
    var tu : String {get set}
    var w : String {get set}
    var th : String {get set}
    var f : String {get set}
    var sa : String {get set}
    var su : String {get set}
    var noData : String {get set}
    var lastTrip : String {get set}
    var mostRecentPayout : String {get set}
    var lifetimeTrips : String {get set}
    var ratedTrips : String {get set}
    var fiveStarTrips : String {get set}
    var yourCurrentRating : String {get set}
    var riderFeedBack : String {get set}
    var checkOut : String {get set}
    var noVehicleAssigned : String {get set}
    var referral : String {get set}
    var documents : String {get set}
    var payout : String {get set}
    var bankDetails : String {get set}
    var payToGofer : String {get set}
    var edit : String {get set}
    var view : String {get set}
    var signOut : String {get set}
    var manualBookingReminder : String {get set}
    var manualBookingCancelled : String {get set}
    var manualBookedForRide : String {get set}
    var apply : String {get set}
    var amount : String {get set}
    var selectExtraFee : String {get set}
    var applyExtraFee : String {get set}
    var enterExtraFee : String {get set}
    var enterOTP : String {get set}
    var done : String {get set}
    var cancel : String {get set}
    var weeklyStatement : String {get set}
    var tripEarnings : String {get set}
    var baseFare : String {get set}
    var accessFee : String {get set}
    var totalGoferDriverEarnings : String {get set}
    var cashCollected : String {get set}
    var riderFaresEarned : String {get set}
    var bankDeposit : String {get set}
    var completedTrips : String {get set}
    var dailyEarnings : String {get set}
    var noDailyEarnings : String {get set}
    var bankDepositLbl : String {get set}
    var noTrips : String {get set}
    var tripDetail : String {get set}
    var tripID : String {get set}
    var duration : String {get set}
    var distance : String {get set}
    var km : String {get set}
    var mins : String {get set}
    var tripHistory : String {get set}
    var pending : String {get set}
    var completed : String {get set}
    var youHaveNoTrips : String {get set}
    var youHaveNoPastTrips : String {get set}
    var cancelRideVC : String {get set}
    var cancelReason : String {get set}
    var writeYourComment : String {get set}
    var cancelTrip : String {get set}
    var riderNoShow : String {get set}
    var riderRequestedCancel : String {get set}
    var wrongAddressShown : String {get set}
    var involvedInAnAccident : String {get set}
    var doNotChargeRider : String {get set}
    var minute : String {get set}
    var minutes : String {get set}
    var cancellingRequest : String {get set}
    var cancelled : String {get set}
    var pleaseEnablePushNotification : String {get set}
    var alreadyAccepted : String {get set}
    var alreadyAcceptedBySomeone : String {get set}
    var selectAPhoto : String {get set}
    var takePhoto : String {get set}
    var chooseFromLibrary : String {get set}
    var firstName : String {get set}
    var lastName : String {get set}
    var email : String {get set}
    var specialInstruction : String {get set}
    var phoneNumber : String {get set}
    var addressLineFirst : String {get set}
    var addressLineSecond : String {get set}
    var city : String {get set}
    var postalCode : String {get set}
    var state : String {get set}
    var personalInformation : String {get set}
    var address : String {get set}
    var message : String {get set}
    var error : String {get set}
    var deviceHasNoCamera : String {get set}
    var warning : String {get set}
    var pleaseGivePermission : String {get set}
    var uploadFailed : String {get set}
    //MARK:- RouteVC
    var enRoute : String {get set}
    var navigate : String {get set}
    var cancelTripByDriver : String {get set}
    var cancelTrips : String {get set}
    var hereYouCanChangeYourMap : String {get set}
    var byClicking : String {get set}
    var googleMap : String {get set}
    var wazeMap : String {get set}
    var doYouWant : String {get set}
    var pleaseInstallGoogleMapsApp : String {get set}
    var doYouWantToAccessdirection : String {get set}
    var pleaseInstallWazeMapsApp : String {get set}
    var networkDisconnected : String {get set}
    var rateYourRider : String {get set}
    var submit : String {get set}
    var pickUp : String {get set}
    var contact : String {get set}
    var help : String {get set}
    var about : String {get set}
    var callsOnly : String {get set}
    var call : String {get set}
    var messages : String {get set}
    var vehicleInformation : String {get set}
    var rider : String {get set}
    var typeAMessage : String {get set}
    var noMessagesYet : String {get set}
    var country : String {get set}
    var currency : String {get set}
    var bsb : String {get set}
    var accountNumber : String {get set}
    var accountHolderName : String {get set}
    var addressOne : String {get set}
    var addressTwo : String {get set}
    var address1 : String {get set}
    var address2 : String {get set}
    var postal : String {get set}
    var pleaseEnter : String {get set}
    var ibanNumber : String {get set}
    var sortCode : String {get set}
    var branchCode : String {get set}
    var clearingCode : String {get set}
    var transitNumber : String {get set}
    var institutionNumber : String {get set}
    var rountingNumber : String {get set}
    var bankName : String {get set}
    var branchName : String {get set}
    var bankCode : String {get set}
    var accountOwnerName : String {get set}
    var pleaseUpdateDocument : String {get set}
    var gender : String {get set}
    var male : String {get set}
    var female : String {get set}
    var payouts : String {get set}
    var choosePhoto : String {get set}
    var noCamera : String {get set}
    var alert : String {get set}
    var cameraAccess : String {get set}
    var allowCamera : String {get set}
    var setupPayout : String {get set}
    var uber : String {get set}
    var add : String {get set}
    var emailID : String {get set}
    var pleaseEnterValidEmail : String {get set}
    var swiftCode : String {get set}
    var required : String {get set}
    var paid : String {get set}
    var waitingForPayment : String {get set}
    var proceed : String {get set}
    var success : String {get set}
    var riderPaid : String {get set}
    var paymentDetails : String {get set}
    var paypalEmail : String {get set}
    var save : String {get set}
    var addNewPayout : String {get set}
    var account : String {get set}
    var payment : String {get set}
    var addPayoutMethod : String {get set}
    var trip : String {get set}
    var history : String {get set}
    var payStatements : String {get set}
    var changeCreditCard : String {get set}
    var addCreditCard : String {get set}
    var quantity : String {get set}
    var onlinePay : String {get set}
    var pleaseEnterValidCard : String {get set}
    var pay : String {get set}
    var change : String {get set}
    var enterTheAmount : String {get set}
    var referralAmount : String {get set}
    var applied : String {get set}
    var addCard : String {get set}
    var yourPayToGofer : String {get set}
    var getUpto : String {get set}
    var forEveryFriend : String {get set}
    var signUpGet : String {get set}
    var yourReferralCode : String {get set}
    var yourInviteCode : String {get set}
    var forEveryFriendJobs : String {get set}
    var shareMyCode : String {get set}
    var ReferralCopied : String {get set}
    var referralCodeCopied : String {get set}
    var useMyReferral : String {get set}
    var startYourJourney : String {get set}
    var DeclineServiceRequest : String {get set}
    var noReferralsYet : String {get set}
    var friendsIncomplete : String {get set}
    var friendsCompleted : String {get set}
    var earned : String {get set}
    var referralExpired : String {get set}
    var cash : String {get set}
    var paypal : String {get set}
    var promoCode : String {get set}
    var promotions : String {get set}
    var wallet : String {get set}
    var stripeDetails : String {get set}
    var addressKana : String {get set}
    var addressKanji : String {get set}
    var yes : String {get set}
    var no : String {get set}
    var pleaseEnterExtraFare : String {get set}
    var pleaseSelectAnOption : String {get set}
    var pleaseEnterYourComment : String {get set}
    var stripe : String {get set}
    var defaults : String {get set}
    var signIn : String {get set}
    var lookRiderApp : String {get set}
    var close : String {get set}
    var password : String {get set}
    var forgotPassword : String {get set}
    var resetPassword : String {get set}
    var confirmPassword : String {get set}
    var confirm : String {get set}
    var selectVehicle : String {get set}
    var chooseVehicle : String {get set}
    var vehicleName : String {get set}
    var vehicleNumber : String {get set}
    var continues : String {get set}
    var selectCountry : String {get set}
    var search : String {get set}
    var uploadDoc : String {get set}
    var verify : String {get set}
    var toDriveWith : String {get set}
    var vehicleMust : String {get set}
    var licenseBack : String {get set}
    var licenseFront : String {get set}
    var licenseInsurance : String {get set}
    var licenseRc : String {get set}
    var licensePermit : String {get set}
    var docSection : String {get set}
    var takeYourPhoto : String {get set}
    var readAllDetails : String {get set}
    var agreeTerms : String {get set}
    var termsConditions : String {get set}
    var privacyPolicy : String {get set}
    var connectionLost : String {get set}
    var tryAgain : String {get set}
    var tapToAdd : String {get set}
    var mobileno : String {get set}
    var refCode : String {get set}
    var likeResetPassword : String {get set}
    var mobile : String {get set}
    var mobileVerify : String {get set}
    var enterMobileno : String {get set}
    var resendOtp : String {get set}
    var enterOtp : String {get set}
    var smsMobileVerify : String {get set}
    var didntReceiveOtp : String {get set}
    var otpAgain : String {get set}
    var nameOfBank : String {get set}
    var bankLocation : String {get set}
    var pleaseGiveRating : String {get set}
    var passwordMismatch : String {get set}
    var credentialsDontLook : String {get set}
    var nameEmail : String {get set}
    var rateYourRide : String {get set}
    var beginTrip : String {get set}
    var endTrip : String {get set}
    var confirmArrived : String {get set}
    var newVersionAvail : String {get set}
    var updateApp : String {get set}
    var visitAppStore : String {get set}
    var internalServerError : String {get set}
    var driverEarnings : String {get set}
    var dropOff : String {get set}
    var cashTrip : String {get set}
    var timelyEarnings : String {get set}
    var noDataFound : String {get set}
    var passwordValidationMsg : String {get set}
    //MARK:- ErrorLocalizedDesc
       var clientNotInitialized : String {get set}
       var jsonSerialaizationFailed : String {get set}
       var noInternetConnection : String {get set}
    //MARK:- Call
    var connecting : String {get set}
    var ringing : String {get set}
    var callEnded : String {get set}
    
    //MARK:- Langugage reopens
    var placehodlerMail : String {get set}
    var enterValidOTP : String {get set}
    var locationService : String {get set}
    var tracking : String {get set}
    var camera : String {get set}
    var photoLibrary : String {get set}
    var service : String {get set}
    var app : String {get set}
    var pleaseEnable : String {get set}
    var requires : String {get set}
    var _for : String {get set}
    var functionality : String {get set}
    var swipeTo : String {get set}
    var acceptingRequest : String {get set}
    
    var home : String {get set}
    var trips : String {get set}
    var earnings : String {get set}
    var ratings : String {get set}
    var acount : String {get set}
    
    var requestStatus : String {get set}
    var ratingStatus : String {get set}
    var scheduledStatus : String {get set}
    var microphoneSerivce : String {get set}
    var inAppCall : String {get set}
    
    var choose : String {get set}
    var choosePaymentMethod: String {get set}
    var delete : String {get set}
    var whatLike2Do : String {get set}
    var update : String {get set}
    var makeDefault : String {get set}
    
    var legalDocuments : String {get set}
    var min : String {get set}
    var hr : String {get set}
    var hrs : String {get set}
    
    var language : String {get set}
    var selectLanguage : String {get set}
    var active : String {get set}
    var gettingLocationTryAgain : String {get set}
    var settings : String {get set}
    
    var goOnline : String {get set}
    var goOffline : String {get set}
    var manageVehicle : String {get set}
    var yourTrips : String {get set}
    var manageDocuments : String {get set}
    var addEarnings : String {get set}
    var addPayouts : String {get set}
    
    var editVehicle : String {get set}
    var addVehicle : String {get set}
    var allProgressDiscard : String {get set}
    var make : String {get set}
    var model : String {get set}
    var year : String {get set}
    var license : String {get set}
    var color : String {get set}
    var selectMake : String {get set}
    var selectModel : String {get set}
    var selectYear : String {get set}
    var pleaseSelectMake : String {get set}
    var seat : String {get set}
    var seats : String {get set}
    var expiryDate : String {get set}
    var pleaseSelectOption : String {get set}
    var sureToDeleteVehicle : String {get set}
    var approved : String {get set}
    var rejected : String {get set}
    var addDocument : String {get set}
    var riderBusy : String {get set}
    var inTripComplete : String {get set}
    var yourOnlineGoOffline : String {get set}
    var vehicleIsNotActive : String {get set}
    var addNew : String {get set}
    var poolRequest : String {get set}
    var person : String {get set}
    var persons : String {get set}
    var pleaseCompleteTrips : String {get set}
    var inTrip : String {get set}
    func isRTLLanguage() -> Bool
    
    //yamini
    var manageServices: String {get set}
    var manageHome: String {get set}
    var loginText : String {get set}
     var appName : String {get set }
     var welcomeText : String {get set }
     var welcomeLoginText : String {get set }
    var yourJob : String {get set}
    var tapToChange : String {get set}
    var dontHaveAcc : String {get set}
    var alreadyHaveAcc : String {get set}
    var tocText : String {get set}
    var logout : String {get set}
    var pleaseSetLocation : String {get set}
    var of : String {get set}
    var liveTrack : String {get set}
    var jobProgress : String {get set}
    var requestedService : String {get set}
    var cancelBooking : String {get set}
    var liveTracking : String {get set}
    var arrive : String {get set}
    var beginJob : String {get set}
    var endJob : String {get set}
    var slideTo : String {get set}    //ismayil
    var rUSureToLogOut: String {get set}
    var areYouSureToDelete: String {get set}
    var deleteAnyWay : String {get set}
    var managePayouts : String {get set}
    var searchLocation : String {get set}
    var successFullyUpdated : String {get set}
    var enterYourOldPassword : String {get set}
    var enterYourNewPassword : String {get set}
    var enterYourConformPassword : String {get set}

    var areYouSure : String {get set}
    var areYouSureYouWantToExit : String {get set}
    var sec : String {get set}

}
extension LanguageProtocol{
    func getBackBtnText() -> String{
        return self.isRTLLanguage() ? "I" : "e"
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
