//
//  GoogleAutoComplete.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
protocol GoogleAutoCompleteDelegate {
    func googleAutoComplete(failedWithError error:String)
    func googleAutoComplete(predictionsFetched predictions: [Prediction])
    func searchBtnClicked(searchBar: UISearchBar)
}

class GoogleAutoCompleteHandler : NSObject {
    private var searchBar : UISearchBar?
    private var searchTextField : UITextField?
    fileprivate var requestQueue : OperationQueue?
    fileprivate var searchDelegate : GoogleAutoCompleteDelegate?
    fileprivate var hitCount = 0
    fileprivate var currentLat :Double?
    fileprivate var currentLong :Double?
    fileprivate var isStrictBoundNeeded : Bool = false
    let dispatchQueue : DispatchQueue
    init(searchBar : UISearchBar? = nil,
         searchTextField : UITextField? = nil,
         delegate : GoogleAutoCompleteDelegate,
         userCurrentLatLng:(lat:Double, long:Double)? = nil){
        self.dispatchQueue = DispatchQueue.main
        super.init()
        if let searchBar = searchBar {
            self.searchBar = searchBar
            self.searchBar?.delegate = self
        }
        
        if let searchTextField = searchTextField {
            self.searchTextField = searchTextField
            self.searchTextField?.delegate = self
            self.searchTextField?.addTarget(self,
                                            action: #selector(textDidChange(_:)),
                                            for: .editingChanged)
        }
        self.searchDelegate = delegate
        self.currentLat = userCurrentLatLng?.lat
        self.currentLong = userCurrentLatLng?.long
    }
//    func getAutoComplete(for searchText : String){
//        let valueInKilometer = Measurement(value: 50, unit: UnitLength.kilometers)
//        let valueInMeter = valueInKilometer.converted(to: .meters).value.description
//        let locationSurroundingPreference = self.currentLat != nil ? "&types=establishment&location=\(currentLat!),\(currentLong!)&radius=\(valueInMeter)\(isStrictBoundNeeded ? "&strictbounds=1" : "")" : ""
//        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(GooglePlacesApiKey)&input=\(searchText)\(locationSurroundingPreference)") else{return}
//
//
//        self.requestQueue?.cancelAllOperations()
//        self.requestQueue = OperationQueue()
//        print("start fetching \(url.absoluteString)")
//        let session = URLSession.init(configuration: .default,
//                                      delegate: nil,
//                                      delegateQueue: self.requestQueue)
//        session.dataTask(with: url) {  [weak self] data, response, error in
//            print(response as Any)
//
//            DispatchQueue.main.async {
//                self?.hitCount += 1
//                print("∂HitCount : \(String(describing: self?.hitCount))")
//                if let _error = error {
//                    print(_error)
//                    self?.searchDelegate?.googleAutoComplete(failedWithError: "Error during JSON serialization: \(_error.localizedDescription)")
//                    return
//                }
//
//                do {
//                    let json = try JSONDecoder().decode(GoogleAutoCompletePredictions.self, from: data! )
//
//
//                    DispatchQueue.main.async {
//                        self?.searchDelegate?.googleAutoComplete(predictionsFetched: json.predictions)
//
//                    }
//                    print(json)
//                } catch {
//                    self?.searchDelegate?.googleAutoComplete(failedWithError: "Error during JSON serialization: \(error.localizedDescription)")
//                    print("Error during JSON serialization: \(error.localizedDescription)")
//                }
//            }
//
//        }.resume()
//
//
//    }
//}
    func getAutoComplete(for searchText : String){
            let valueInKilometer = Measurement(value: 50, unit: UnitLength.kilometers)
            let valueInMeter = valueInKilometer.converted(to: .meters).value.description
            let locationSurroundingPreference = self.currentLat != nil ? "&location=\(currentLat!),\(currentLong!)&radius=\(valueInMeter)\(isStrictBoundNeeded ? "&strictbounds=1" : "")" : ""
    //        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(GooglePlacesApiKey)&input=\(searchText)\(locationSurroundingPreference)") else{return}
    //
    //
    //        self.requestQueue?.cancelAllOperations()
    //        self.requestQueue = OperationQueue()
    //        print("start fetching \(url.absoluteString)")
    //        let session = URLSession.init(configuration: .default,
    //                                      delegate: nil,
    //                                      delegateQueue: self.requestQueue)
    //        session.dataTask(with: url) {  [weak self] data, response, error in
    //            print(response as Any)
    //
    //            DispatchQueue.main.async {
    //                self?.hitCount += 1
    //                print("∂HitCount : \(String(describing: self?.hitCount))")
    //                if let _error = error {
    //                    print(_error)
    //                    self?.searchDelegate?.googleAutoComplete(failedWithError: "Error during JSON serialization: \(_error.localizedDescription)")
    //                    return
    //                }
    //
    //                do {
    //                    let json = try JSONDecoder().decode(GoogleAutoCompletePredictions.self, from: data! )
    //
    //
    //                    DispatchQueue.main.async {
    //                        self?.searchDelegate?.googleAutoComplete(predictionsFetched: json.predictions)
    //
    //                    }
    //                    print(json)
    //                } catch {
    //                    self?.searchDelegate?.googleAutoComplete(failedWithError: "Error during JSON serialization: \(error.localizedDescription)")
    //                    print("Error during JSON serialization: \(error.localizedDescription)")
    //                }
    //            }
    //
    //        }.resume()
            var params = JSON()
            params = [
                "input" : "\(searchText)",
                "key" : GooglePlacesApiKey,
                "location" : "\(currentLat?.description ?? ""),\(currentLong?.description ?? "")",
                "radius" : valueInMeter
            ]
            if isStrictBoundNeeded{
                params["strictbounds"] = 1
            }
            ConnectionHandler.shared.getRequest(forAPI: "https://maps.googleapis.com/maps/api/place/autocomplete/json",
                            params: params, showLoader: false, cacheAttribute: .none)

                .responseDecode(to: GoogleAutoCompletePredictions.self, { json in
                    DispatchQueue.main.async {
                        self.searchDelegate?.googleAutoComplete(predictionsFetched: json.predictions)
                        
                    }
                })
                
                .responseFailure({ (error) in
    //                debug(print: error)
                    self.searchDelegate?.googleAutoComplete(failedWithError: error)

                })
        }
    }
//MARK:- SearchBarDelegate
extension GoogleAutoCompleteHandler : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0{
            self.startCountdownTimer(forSearch: searchText)
        } else{
            self.searchDelegate?.googleAutoComplete(predictionsFetched: [])
        }
    }
    //MARK: UDF counter
    func startCountdownTimer(forSearch searchString: String) {
        //stop the current countdown
        let timeInterval : DispatchTime = .now() + 0.35
        
        self.requestQueue?.cancelAllOperations()
        self.dispatchQueue.asyncAfter(deadline: timeInterval) {
            guard !searchString.isEmpty else {
                self.searchDelegate?.googleAutoComplete(predictionsFetched: [])
                return
            }
            self.getAutoComplete(for: searchString)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchDelegate?.searchBtnClicked(searchBar: searchBar)
    }
}


extension GoogleAutoCompleteHandler : UITextFieldDelegate {
    
    @objc
    func textDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 0{
            self.startCountdownTimer(forSearch: text)
        } else{
            self.searchDelegate?.googleAutoComplete(predictionsFetched: [])
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        textField.resignFirstResponder()
        return false
    }
}
