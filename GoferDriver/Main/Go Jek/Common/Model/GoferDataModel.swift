// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class GoferDataModel: Codable {
    let statusCode, statusMessage: String
    var currentPage, totalPages: Int
    var data: [DataModel]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case data
    }

    init(statusCode: String,
         statusMessage: String,
         currentPage: Int,
         totalPages: Int,
         data: [DataModel]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.data = data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        let result = try container.decodeIfPresent([DataModel].self,
                                                   forKey: .data)
        if let result = result {
            self.data = result
        } else {
            self.data = []
        }
    }
    
    func updateWithNewData(_ newData : GoferDataModel){
        self.currentPage = newData.currentPage
        self.data.append(contentsOf: newData.data)
    }
}

// MARK: - Datum
class DataModel: Codable {
    let isPool: Bool
    let seats: Int
    var status: TripStatus = .pending
    let jobID: Int
    let deliveryId: Int
    let pickup, drop, mapImage : String
    let mapImageDark : String
    var bookingType: BookingEnum = .auto
    let vehicleType, vehicleNumber, currencySymbol, totalFare: String
    let providerEarnings: String
    let providerImage: String
    let scheduleDisplayDate, currencyCode: String
    // Handy Splitup Start
    var businessID : BusinessType = .Services
    // Handy Splitup End
    var priceType : PriceType = .Fixed
    let scheduleDate : String
    let scheduleTime : String
    let id : Int
    let requestID : Int
    let jobRating : String

    enum CodingKeys: String, CodingKey {
        case isPool = "is_pool"
        case seats, status
        case jobID = "job_id"
        case deliveryId = "delivery_id"
        case pickup, drop
        case mapImage = "map_image"
        case bookingType = "booking_type"
        case vehicleType = "vehicle_type"
        case vehicleNumber = "vehicle_number"
        case currencySymbol = "currency_symbol"
        case totalFare = "total_fare"
        case providerEarnings = "provider_earnings"
        case providerImage = "provider_image"
        case scheduleDisplayDate = "schedule_display_date"
        case currencyCode = "currency_code"
        // Handy Splitup Start
        case businessID = "business_id"
        // Handy Splitup End
        case priceType = "price_type"
        case scheduleDate = "schedule_date"
        case scheduleTime = "schedule_time"
        case id = "id"
        case requestID = "request_id"
        case jobRating = "job_rating"
        case mapImageDark = "dark_map_image"
    }

    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isPool = container.safeDecodeValue(forKey: .isPool)
        self.seats = container.safeDecodeValue(forKey: .seats)
        do {
            self.status = try container.decodeIfPresent(TripStatus.self, forKey: .status) ?? .pending}
        catch {
            print(error.localizedDescription)
        }
        self.jobID = container.safeDecodeValue(forKey: .jobID)
        self.deliveryId = container.safeDecodeValue(forKey: .deliveryId)
        self.pickup = container.safeDecodeValue(forKey: .pickup)
        self.drop = container.safeDecodeValue(forKey: .drop)
        self.mapImage = container.safeDecodeValue(forKey: .mapImage)
        do {
            self.bookingType = try container.decodeIfPresent(BookingEnum.self, forKey: .bookingType) ?? .auto}
        catch {
            print(error.localizedDescription)
        }
        self.vehicleType = container.safeDecodeValue(forKey: .vehicleType)
        self.vehicleNumber = container.safeDecodeValue(forKey: .vehicleNumber)
        self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.providerEarnings = container.safeDecodeValue(forKey: .providerEarnings)
        self.providerImage = container.safeDecodeValue(forKey: .providerImage)
        self.scheduleDisplayDate = container.safeDecodeValue(forKey: .scheduleDisplayDate)
        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
        // Handy Splitup Start
        do {
            self.businessID = try container.decodeIfPresent(BusinessType.self, forKey: .businessID) ?? .Services}
        catch {
            print(error.localizedDescription)
        }
        // Handy Splitup End
        do {
            self.priceType = try container.decodeIfPresent(PriceType.self, forKey: .priceType) ?? .Fixed}
        catch {
            print(error.localizedDescription)
        }
        self.scheduleDate = container.safeDecodeValue(forKey: .scheduleDate)
        self.scheduleTime = container.safeDecodeValue(forKey: .scheduleTime)
        self.id = container.safeDecodeValue(forKey: .id)
        self.requestID = container.safeDecodeValue(forKey: .requestID)
        self.jobRating = container.safeDecodeValue(forKey: .jobRating)
        self.mapImageDark = container.safeDecodeValue(forKey: .mapImageDark)
    }
}
