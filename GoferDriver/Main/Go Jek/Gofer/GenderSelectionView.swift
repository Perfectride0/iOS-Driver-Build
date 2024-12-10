//
//  GenderSelectionView.swift
//  Goferjek Driver
//
//  Created by trioangle on 20/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
enum Gender : String {
    case none
    case male
    case female
}

class GenderSelectionView: BaseView {

    //MARK: - Outlets
    @IBOutlet weak var holderView: SecondaryView!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var genderView: SecondaryView!
    @IBOutlet weak var updateBtnView: SecondaryView!
    @IBOutlet weak var imgMale: PrimaryImageView!
    @IBOutlet weak var imgFemale: PrimaryImageView!
    @IBOutlet weak var maleLbl: SecondaryRegularLabel!
    @IBOutlet weak var femaleLbl: SecondaryRegularLabel!
    @IBOutlet weak var updateBtn: PrimaryButton!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleView: UIView!
    
    @IBOutlet weak var mainStack: UIStackView!
    //MARK: - Local Variables
   
    var selectedGender : Gender = .none
    var genderSelectionVC : GenderSelectionViewController!

    //MARK: 
    override func didLoad(baseVC: BaseVC) {
        self.genderSelectionVC = baseVC as? GenderSelectionViewController
        self.darkModeChange()
        self.initDesign()
    }
   override func darkModeChange() {
        self.holderView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.genderView.customColorsUpdate()
        self.updateBtnView.customColorsUpdate()
        self.maleLbl.customColorsUpdate()
        self.femaleLbl.customColorsUpdate()
    }
    func initDesign(){
        self.holderView.cornerRadius = 5
        self.titleLbl.setTextAlignment(aligned: .center)
        self.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        self.titleLbl.text = LangGofer.selectGender
//        self.titleLbl.text = "Select Your Gender"
        self.updateBtn.setTitle(LangCommon.update, for: .normal)
        self.maleLbl.text = LangCommon.male
        self.femaleLbl.text = LangCommon.female
        self.setGender()
        self.mainStack.addTap {
            print("its working")
        }
        self.maleView.addTap {
            self.selectedGender = .male
            self.setGender()
        }
        self.femaleView.addTap {
            self.selectedGender = .female
            self.setGender()
        }
        self.checkGender()
        self.updateBtn.cornerRadius = 15
    }

    @objc func setGender(){
        self.imgMale.image = UIImage(named: self.selectedGender == .male ? "Radio_btn_selected" : "Radio_btn_unselected")
        self.imgFemale.image = UIImage(named: self.selectedGender == .female ? "Radio_btn_selected" : "Radio_btn_unselected")
        self.checkGender()
    }
    func checkGender(){
        if self.selectedGender == .none {
            self.updateBtn.isUserInteractionEnabled = false
        } else {
            self.updateBtn.isUserInteractionEnabled = true
        }
    }

    //MARK: - Button Actions
    @IBAction func updateGender(_ sender: Any) {
        var parms = JSON()
        parms["gender"] = self.selectedGender.rawValue
        parms["page"] = "home"
        self.genderSelectionVC.onUpdateGender(params: parms)
    }
    
    
    
}
