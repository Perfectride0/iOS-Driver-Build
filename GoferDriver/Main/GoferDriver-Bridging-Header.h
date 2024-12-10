//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#include <ifaddrs.h>
#import "DSBarChart.h"
#import "BIZProgressViewHandler.h"
#import "BIZCircularProgressView.h"
#import "ARCarMovement.h"
#import "UITextSwitch.h"
#import "GMUHeatmapTileLayer.h"




#pragma mark LIST OF CONSTANTS
//****************************
#define           USER_FIREBASE_TOKEN       @"firebase_token"
#define           USER_FIREBASE_AUTH        @"firebase_auth"
#define           USER_ACCESS_TOKEN         @"access_token"
#define           CEO_FacebookAccessToken   @"FBAcessToken"
#define           USER_FULL_NAME            @"full_name"
#define           USER_FIRST_NAME           @"first_name"
#define           USER_LAST_NAME            @"last_name"
#define           USER_IMAGE_THUMB          @"user_image"
#define           USER_FB_ID                @"user_fbid"
#define           USER_ID                   @"user_id"
#define           USER_EMAIL_ID             @"user_email_id"
#define           USER_CAR_ID               @"user_car_id"
#define           USER_DIAL_CODE            @"dial_code"
#define           USER_COUNTRY_CODE         @"user_country_code"
#define           USER_DEVICE_TOKEN         @"device_token"
#define           USER_STATUS               @"user_status"
#define           TRIP_STATUS               @"trip_status"
#define           CASH_PAYMENT              @"cash"
#define           USER_CAR_DETAILS          @"car_details"
#define           STRIPE_WALLET_PAYMENT     @"stripe_wallet_payment"
#define           USER_CARD_BRAND           @"user_card_brand"
#define           USER_CARD_LAST4           @"user_card_last4"
#define           USER_PAYMENT_METHOD       @"user_payment_method"
#define           USER_WALLET_AMOUNT        @"user_wallet_amount"
#define           USER_SELECT_WALLET        @"user_select_wallet"
#define           API_ADD_STRIPE_CARD       @"add_card_details"
#define           USER_STRIPE_KEY           @"user_stripe_key"
#define           USER_CAR_TYPE             @"car_type"
#define           USER_CAR_IDS              @"car_ids"
#define           USER_ONLINE_STATUS        @"user_online_status"
#define           USER_PAYPAL_EMAIL_ID      @"paypal_email_id"
#define           LICENSE_BACK              @"licence_back"
#define           LICENSE_FRONT             @"licence_front"
#define           LICENSE_INSURANCE         @"licence_insurance"
#define           LICENSE_RC                @"licence_rc"
#define           LICENSE_PERMIT            @"licence_permit"
#define           USER_CURRENT_TRIP_ID      @"user_current_trip_id"
#define           USER_PHONE_NUMBER         @"phonenumber"
#define           USER_START_DATE           @"user_start_date"
#define           USER_END_DATE             @"user_end_date"
#define           USER_LONGITUDE            @"user_longitude"
#define           USER_LATITUDE             @"user_latitude"
#define           USER_LOCATION             @"user_location"
#define           NEXT_ICON_NAME             @"I"
#define           PICKUP_COORDINATES        @"rider_pickup_coordinates"
#define           CURRENT_TRIP_ID           @"user_current_trip_id"
#define           DEVICE_LANGUAGE           @"device_default_language"
#define           TRIP_RIDER_THUMB_URL      @"trip_rider_thumb_url"
#define           TRIP_RIDER_NAME           @"trip_rider_name"
#define           TRIP_RIDER_RATING         @"trip_rider_rating"
#define           IS_COMPANY_DRIVER         @"is_company_driver"
#define            IS_Payment_image         @"payment_selected_image"
//#define           USER_CURRENCY_ORG         @"user_currency_org"
//#define           USER_CURRENCY_SYMBOL_ORG  @"user_currency_symbol_org"

#define           USER_CURRENCY_ORG_splash         @"user_currency_org_splash"
#define           USER_CURRENCY_SYMBOL_ORG_splash  @"user_currency_symbol_org_splash"

// handy man location related constants
static NSString * const GOOGLE_MAP_API_URL              = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
static NSString * const GOOGLE_MAP_DETAILS_URL          = @"https://maps.googleapis.com/maps/api/place/details/json";
static NSInteger const kGoogleAPINSErrorCode            = 42;
//static NSString * const GOOGLE_PLACES_API_KEY           = @"AIzaSyAVop-_ZxT0Vc0yakoTIMWkgNnRg8K44Hg";
static NSString * const PARAMETRE_RADIUS                = @"10000";
static NSString * const RESPONSE_KEY_STATUS             = @"status";
static NSString * const RESPONSE_STATUS_OK              = @"OK";
static NSString * const RESPONSE_KEY_PREDICTIONS        = @"predictions";
static NSString * const RESPONSE_KEY_DESCRIPTION        = @"description";
static NSString * const RESPONSE_KEY_REFERENCE          = @"reference";
static NSString * const RESPONSE_KEY_RESULT             = @"result";
static NSString * const RESPONSE_KEY_ATTRIBUTIONS       = @"html_attributions";
static NSString * const RESPONSE_KEY_NAME               = @"name";
static NSString * const RESPONSE_KEY_LOCATION           = @"location";
static NSString * const RESPONSE_KEY_GEOMETRY           = @"geometry";
static NSString * const RESPONSE_KEY_LATITUDE           = @"lat";
static NSString * const RESPONSE_KEY_LONGITUDE          = @"lng";
static NSString * const RESPONSE_KEY_VICINITY           = @"vicinity";
static NSString * const RESPONSE_KEY_FORMATTED_ADDRESS  = @"formatted_address";
static NSString * const GOOGLE_PLACES_ERROR_DOMAIN      = @"ADGooglePlacesErrorDomain";
static NSString * const ADDRESS_COMPONENTS              = @"address_components";
static NSString * const ADDRESS_TYPES                   = @"types";
