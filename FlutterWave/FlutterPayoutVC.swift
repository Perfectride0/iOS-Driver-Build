//
//  FlutterPayoutVC.swift
//  FlutterWave
//
//  Created by trioangle on 31/08/22.
//

import UIKit

class FlutterPayoutVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topCuredView: UIView!
    @IBOutlet weak var benifiNameTxtFld: UITextField!
    @IBOutlet weak var accNumTxtFld: UITextField!
    @IBOutlet weak var accountBank: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var subMitBtn: UIButton!
    
    
    var pickerV: UIPickerView = UIPickerView()
    let dataArray = ["English", "Maths", "History", "German", "Science"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subMitBtn.backgroundColor = .PrimaryColor
//        self.topCuredView.setTopCorners(radius: 20.0)
//        self.topCuredView.setTopCorners(radius: 20.0)
        getUserDefaultData()
    }
    
    func getUserDefaultData(){
         loadImage()
        print(UserDefaults.standard.string(forKey: "FlutterToken"))
        
    }
    
    func loadImage() {
         guard let data = UserDefaults.standard.data(forKey: "BAckIcon") else { return }
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         let backimage = UIImage(data: decoded)
        self.backBtn.setImage(backimage, for: .normal)
        
    }
    func setPickerView(){
        self.pickerV.delegate = self
        self.pickerV.dataSource = self
        self.pickerV.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.addSubview(pickerV)
        self.pickerV.backgroundColor = .white
        self.pickerV.isHidden = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//
//        self.backBtn?.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
//        self.backBtn?.titleLabel?.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
//        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
//        self.backBtn?.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        
        if self.traitCollection.userInterfaceStyle == .dark{
            self.titleLbl.textColor = .lightGray
            self.backBtn?.backgroundColor = .black
            self.backBtn?.titleLabel?.textColor = .white
        }else{
            self.titleLbl.textColor = .black
            self.backBtn?.backgroundColor = .white
        }
        
    }
    
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        print("Flutter payment \(request)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, error)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func onSubmitTapped(_ sender: Any) {
        if self.benifiNameTxtFld.text == "" || self.accNumTxtFld.text == "" || self.accountBank.text == ""{
            self.showSimpleAlert(strMsg: "Enter Your Bank Details")
        }else{
           // callAPi()
            let url = UserDefaults.standard.string(forKey: "ApiUrl")!
            print("Flutter wave Url :: \(url)")
            let apiurl = "\(url)flutterwave/add_payout"
            var paramDict = [String:String]()
            paramDict["token"] = UserDefaults.standard.string(forKey: "FlutterToken")
            paramDict["beneficiary_name"] = self.benifiNameTxtFld.text
            paramDict["account_number"] = self.accNumTxtFld.text
            paramDict["account_bank"] = self.accountBank.text
            UberSupport.shared.showProgressInWindow(showAnimation: true)
            self.sendRequest(apiurl, parameters: paramDict) { responseObject, error in
                guard let responseObject = responseObject, error == nil else {
                        print(error ?? "Unknown error")
                    UberSupport.shared.showProgressInWindow(showAnimation: false)
                        return
                    }
                UberSupport.shared.showProgressInWindow(showAnimation: false)
                if responseObject.status_code == 1{
                    print("Success")
                    DispatchQueue.main.async{
                    self.navigationController?.popViewController(animated: true)
                    }
                    
                }else{
                    DispatchQueue.main.async{
                        let msg = responseObject.status_message
                        self.showSimpleAlert(strMsg: msg)
                        print(msg)
                    }
                }
            }
        }
    }
    
    func showSimpleAlert(strMsg:String) {
        let alert = UIAlertController(title: "Alert!", message: strMsg ,preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: LangCommon.ok,
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                
            }))
        self.present(alert, animated: true, completion: nil)
        }
    
}



extension FlutterPayoutVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          let row = dataArray[row]
          return row
    }
    
}



