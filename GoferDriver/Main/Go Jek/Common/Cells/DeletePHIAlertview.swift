//
//  DeletePHIAlertview.swift
//  Intuitive
//
//  Created by mac004 on 02/12/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class DeletePHIAlertview: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
     */
    @IBOutlet weak var messageDescriptionLbl: SecondaryRegularLabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var message_titleLb: SecondarySubHeaderLabel!
    @IBOutlet weak var PHI_DeleteYesBtn: PrimaryButton!
    @IBOutlet weak var PHI_DeleteNoBtn: SecondaryButton!
    @IBOutlet weak var deletePHI_popupTwoOption: SecondaryView!
    @IBOutlet weak var deletePHI_popupOneOption: SecondaryView!
    @IBOutlet weak var PHI_FinalMessage_OK: PrimaryButton!
    @IBOutlet weak var imageWidhtConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: PrimaryImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.PHI_DeleteNoBtn.cornerRadius = 10
        self.PHI_DeleteNoBtn.elevate(2)
        self.PHI_DeleteYesBtn.customColorsUpdate()
        self.PHI_DeleteYesBtn.cornerRadius = 10
        self.PHI_FinalMessage_OK.customColorsUpdate()
        self.PHI_FinalMessage_OK.cornerRadius = 10
    }
    
}



class CommonAlert:NSObject {
   
    
   
    override init() {
        super.init()
    }
    
    fileprivate func addAlert()->DeletePHIAlertview {
        let commonAlertView: DeletePHIAlertview = Bundle.main.loadNibNamed("DeletePHIAlertview", owner: nil, options: nil)?.first as! DeletePHIAlertview
       
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
       
        commonAlertView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if(window?.subviews.count ?? 0) < 3{
           window?.addSubview(commonAlertView)
           window?.bringSubviewToFront(commonAlertView)
           return commonAlertView
        }
        return commonAlertView
     }


    public func removeAlert() {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let commonAlertView = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            window?.subviews[commonAlertView].removeFromSuperview()
        }
    }
    
    
    

    
    func setupAlert(alert title:String,alertDescription message:String? = nil,okAction:String,cancelAction:String? = nil, userImage:String? = nil)
    {
    
        let alertView = self.addAlert()
       
        alertView.message_titleLb.text = title
        if let description = message {
            alertView.messageDescriptionLbl.text = description
        }else {
            alertView.messageDescriptionLbl.text = ""
        }
        alertView.PHI_DeleteNoBtn.customColorsUpdate()
        // MARK: cancelAction title will be change to alert box UI

        if cancelAction != nil {
            //        MARK: set for single Button UI
            alertView.deletePHI_popupOneOption.isHidden = true
            alertView.deletePHI_popupTwoOption.isHidden = false
            alertView.PHI_DeleteYesBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            alertView.PHI_DeleteNoBtn.setTitle(cancelAction, for: .normal)
            alertView.PHI_DeleteYesBtn.customColorsUpdate()
            alertView.PHI_DeleteYesBtn.cornerRadius = 10
            alertView.PHI_DeleteNoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            alertView.PHI_DeleteYesBtn.setTitle(okAction, for: .normal)
            alertView.PHI_DeleteNoBtn.addTap {
                self.removeAlert()
            }
            alertView.PHI_DeleteYesBtn.addTap {
                self.removeAlert()
            }
        }
        else {
            //        MARK: set for dual Button UI
            alertView.deletePHI_popupOneOption.isHidden = false
            alertView.deletePHI_popupTwoOption.isHidden = true
            alertView.PHI_FinalMessage_OK.titleLabel?.adjustsFontSizeToFitWidth = true
            alertView.PHI_FinalMessage_OK.setTitle(okAction, for: .normal)
            alertView.PHI_FinalMessage_OK.customColorsUpdate()
            alertView.PHI_FinalMessage_OK.cornerRadius = 10
            alertView.PHI_FinalMessage_OK.addTap {
                self.removeAlert()
            }
            
        }
       
        
        
        
        //        MARK: userimage is optional for alert
        if let url = userImage  {
            alertView.userImageView.image = UIImage(named: url)
            alertView.imageWidhtConstraint.constant = 60
        }else {
            alertView.imageWidhtConstraint.constant = 0
        }
        if #available(iOS 12.0, *) {
            let isdarkStyle = alertView.traitCollection.userInterfaceStyle == .dark
            alertView.centerView.backgroundColor = isdarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        alertView.centerView = self.getViewExactHeight(view: alertView.centerView)
       
    }
    
    // MARK: actions for ok buttons first setupAlert
     
    func addAdditionalOkAction(isForSingleOption:Bool, customAction:@escaping()->Void) {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let index = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            
            if let commonAlertView = window?.subviews[index] as? DeletePHIAlertview {
                        if isForSingleOption {
                            commonAlertView.PHI_FinalMessage_OK.addTap {
                                self.removeAlert()
                                customAction()
                            }
                        }else {
                            commonAlertView.PHI_DeleteYesBtn.addTap {
                                self.removeAlert()
                                customAction()
                            }
                        }
                    }
        }
        
    }
    
    func addAdditionalCancelAction( customAction:@escaping()->Void) {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let index = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            
            if let commonAlertView = window?.subviews[index] as? DeletePHIAlertview {
                commonAlertView.PHI_DeleteNoBtn.addTap {
                                   self.removeAlert()
                                   customAction()
                               }
                    }
        }
        
    }
    
    
    fileprivate func getViewExactHeight(view:UIView)->UIView {
       
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
    
    
    
}






