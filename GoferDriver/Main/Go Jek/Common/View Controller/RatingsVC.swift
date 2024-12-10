/**
* RatingsVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import Foundation
import MapKit

class RatingsVC : BaseVC {
   
    //--------------------------------
    // MARK: - Outlets
    //--------------------------------
    
    @IBOutlet var ratingsView: RatingsView!
    
    //--------------------------------
    // MARK: - Local Variables
    //--------------------------------
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var status = ""
    
    //--------------------------------
    // MARK: - ViewController Methods
    //--------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.status = Constants().GETVALUE(keyname: TRIP_STATUS)
        self.appDelegate.pushManager.registerForRemoteNotification()
        self.dateCalculationFUnc()
   }
    
    override
    func viewWillAppear(_ animated: Bool) {
        self.callRatingAPI()
    }
    
    //--------------------------------
    //MARK:- initWithStory
    //--------------------------------
    
    class func initWithStory() -> RatingsVC{
        let view : RatingsVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
    
    
    func dateCalculationFUnc(){
        
        // Get the current date and time
        let currentDate = Date()

        // Create a date formatter
        let dateFormatterr = DateFormatter()

        // Set the date format
        dateFormatterr.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert the date to a string using the formatter
        let dateString = dateFormatterr.string(from: currentDate)
        print(dateString)
        
        print(dateFormatterr.date(from: dateString))
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let startDateString = "2024-05-07 18:00:00"
        let endDateString = dateString //"2024-05-07 16:00:00"

        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            fatalError("Invalid date strings")
        }

        // Get the calendar
        let calendar = Calendar.current

        // Calculate the difference between the two dates
        let difference = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: endDate)

        // Access the components of the difference
        if let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second {
            print("Difference: \(hours) hours, \(minutes) minutes, \(seconds) seconds")
        } else {
            print("Failed to calculate difference")
        }

        
        
    }
    
    //----------------------------------------------------------------
    //MARK: - API CALL -> UPDATE DRIVER CURRENT LOCATION TO SERVER
    //----------------------------------------------------------------
    
    func updateCurrentLocationToServer(status: String,
                                       function : String = #function) {
        var dicts = JSON()
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["latitude"] = Constants().GETVALUE(keyname: USER_LATITUDE)
        dicts["longitude"] = Constants().GETVALUE(keyname: USER_LATITUDE)
        dicts["car_id"] = Constants().GETVALUE(keyname: USER_CAR_ID)
        dicts["status"] = status
        guard let lat = dicts["latitude"] as? String,!lat.isEmpty else {return}
        guard let lang = dicts["longitude"] as? String,!lang.isEmpty else {return}
        ConnectionHandler.shared.getRequest(
                for: .updateDriverLocation,
            params: dicts, showLoader: true).responseJSON({ (json) in
            guard !json.isSuccess else{return}
            if json.status_message.lowercased() == "please complete your current trip" && self.status != "Trip" && function != "viewWillAppear(_:)" {
                self.commonAlert.setupAlert(alert: LangCommon.message.capitalized,
                                            alertDescription: json.status_message,
                                            okAction: LangCommon.ok.capitalized)
            } else if self.status != "Trip" {
                self.appDelegate.createToastMessage(json.status_message, bgColor: UIColor.black, textColor: UIColor.white)
            }
        }).responseFailure({ (error) in
           // self.appDelegate.createToastMessage(error)
        })
    }

    //----------------------------------------------------------------
    //MARK: - API CALL -> GETTING OVARALL RATING INFO
    //----------------------------------------------------------------
    
    func callRatingAPI() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var dicts = JSON()
        // Handy Splitup Start
        dicts["business_id"] = AppWebConstants.currentBusinessType.rawValue
        // Handy Splitup End
        ConnectionHandler.shared
            .getRequest(for: .getDriverRatings,params: dicts,showLoader: true)
        
            .responseDecode(to: RatingModel.self) { (json) in
            if json.status_code == "1" {
                Shared.instance.removeLoaderInWindow()
                self.ratingsView.setRatingHeaderInfo(json)
            } else {
                AppDelegate.shared.createToastMessage(json.status_message)
            }
          }
        
        
//            .responseJSON({ (json) in
//                UberSupport.shared.removeProgressInWindow()
//                if json.isSuccess{
//                    let rateModel = RatingModel(json)
//                    self.ratingsView.setRatingHeaderInfo(rateModel)
//                } else {
//                    AppDelegate.shared.createToastMessage(json.status_message)
//                }
//            })
            
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                //AppDelegate.shared.createToastMessage(error)
            })
    }
}
