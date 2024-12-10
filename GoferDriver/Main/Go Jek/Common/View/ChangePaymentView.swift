//
//  ChangePaymentView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Foundation

class ChangePaymentView: BaseView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBOutlet var addPromoView: UIView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var paymentTableView: CommonTableView!
    @IBOutlet weak var promoTxtField: UITextField!
    @IBOutlet weak var promoTitle: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var headerView: HeaderView!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.contentHolderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.paymentTableView.customColorsUpdate()
        self.paymentTableView.reloadData()
    }
    
    var selectedPayment = ""
    let strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
    var wallectamount = ""
    var arrpayment = [String]()
    var arrpaymentImages = [String]()
    var paymentDataSource = [PaymentTableSection]()
    
    var paymentList : PaymentList?
    var viewController: ChangePaymentVC!
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ChangePaymentVC
        self.paymentTableView.dataSource = self
        self.paymentTableView.delegate = self
        self.initLanguage()
        if #available(iOS 10.0, *) {
            promoTxtField.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            promoTxtField.keyboardType = .default
        }
               // self.updateApi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide1), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.darkModeChange()
    }
    
    //MARK: - initLanguage
    func initLanguage(){
        self.pageTitle.text = LangCommon.paymentStatus.capitalized
    }
    
    //MARK: Generating TableData Source
    func generateTableDataSource(with paymentList : PaymentList){
        /*
         * if from wallet screen : hide cash,prmotions,wallet
         * if from car list screen : Hide promotions
         */
         self.paymentList = paymentList
        self.paymentDataSource = [PaymentTableSection]()
        
        
        
      
            var paymentMethodDatas = [PaymentTableData]()
              for option in paymentList.options{
                  let data = PaymentTableData(withName: option.value)
                  data.isSelected = option.isDefault
                  data.imageURL =  URL(string: option.icon)
                  paymentMethodDatas.append(data)
              }
      //  LangCommon.payment
              self.paymentDataSource
                .append(PaymentTableSection(withTitle: LangCommon.paymentMethods,
                                            datas: paymentMethodDatas))
        
        
        self.paymentTableView.reloadData()
    }

    
    // KEY BOARD DISSMISS METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: self.addPromoView)
    }
    
    @objc func keyboardWillHide1(notification: NSNotification)
    {
        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: self.addPromoView)
        
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
            promoTxtField.resignFirstResponder()
            
            let oldColor = addPromoView.backgroundColor
            UIView.animateKeyframes(withDuration: 0.8, delay: 0.15, options: [.layoutSubviews], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.5/3, animations: {
                    self.addPromoView.backgroundColor = .clear
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    self.addPromoView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
                })
            }, completion: { (_) in
                self.addPromoView.transform = .identity
                self.addPromoView.backgroundColor = oldColor
                self.addButton.isUserInteractionEnabled = true
                self.addPromoView.removeFromSuperview()
            })
            
        }
        @IBAction func addButtonAction(_ sender: Any) {
            if promoTxtField.text != "" {
                promoTxtField.resignFirstResponder()
                
                let oldColor = addPromoView.backgroundColor
                UIView.animateKeyframes(withDuration: 0.8, delay: 0.15, options: [.layoutSubviews], animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.5/3, animations: {
                        self.addPromoView.backgroundColor = .clear
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                        self.addPromoView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
                    })
                }, completion: { (_) in
                    self.addPromoView.backgroundColor = oldColor
                    self.addButton.isUserInteractionEnabled = true
                    self.addPromoView.removeFromSuperview()
                    //self.onPromoCode()
                })
                
            }
            else{
                appDelegate.createToastMessage(LangCommon.promoCode, bgColor: UIColor.black, textColor: UIColor.white)

            }
        }
    
        func onAddNewPromoTapped(){
            addPromoView.frame = CGRect(x: 0, y:0, width: self.frame.size.width, height: self.frame.size.height)
            addSubview(addPromoView)
            addPromoView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
            let oldColor = addPromoView.backgroundColor
            addPromoView.backgroundColor = .clear
            
            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.layoutSubviews], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    self.addPromoView.transform = .identity
                })
                UIView.addKeyframe(withRelativeStartTime: 2.5/3, relativeDuration: 1, animations: {
                    self.addPromoView.backgroundColor = oldColor
                })
            }, completion: nil)
        }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.viewController.dismiss(animated: true, completion: nil)
       // self.viewController.navigationController?.popViewController(animated: true)
    }
    
}

extension ChangePaymentView :UITextFieldDelegate {
    // MARK: TEXTFIELD DELIGATE METHODS
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        self.addButton.isUserInteractionEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addButton.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = string.components(separatedBy: cs).joined(separator: "")
        
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == " ") {
            return false
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return (string == filtered) && true
    }
    
    @objc
    func navigateToStripe(_ sender: Any) {
        let vc = AddStripeCardVC.initWithStory(self.viewController)
        self.viewController.presentInFullScreen(vc,
                                                animated: true,
                                                completion: {
            self.viewController.wsToGetOptionList()
        })
    }

}
extension ChangePaymentView : UITableViewDataSource, UITableViewDelegate {
    // MARK: TABE VIEW DELEGATE AND TABLE VIEW TADASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.paymentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let header = self.paymentDataSource[section]
        label.font = .BoldFont(size: 16)
        label.text = header.title
        label.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        label.textColor = .ThemeTextColor
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentDataSource[section].datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let header = self.paymentDataSource[indexPath.section]
        let data = header.datas[indexPath.row]
        switch header.title {
        case LangCommon.paymentMethods :
            let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellPaymentMethodTVC") as! CellPaymentMethodTVC
            cell.titlePaymentTxt.text = data.name
            cell.paymentImg.sd_setImage(with: data.imageURL, completed: nil)//image = data.image
            cell.selectionIV.image = data.isSelected ? UIImage(named: "tick11")?.withRenderingMode(.alwaysTemplate) : nil
            let selectedItem = self.paymentList?.didSelect(optionNamed: data.name)
            cell.selectionImgHolderView.isHidden = selectedItem?.key == "stripe_card"
            cell.changeBtn.isHidden = !(selectedItem?.key == "stripe")
            cell.changeBtn.addTarget(self,
                                     action: #selector(navigateToStripe(_:)),
                                     for: .touchUpInside)
            cell.selectionIV.tintColor = .PrimaryColor
            cell.paymentImg.image = cell.paymentImg.image?.withRenderingMode(.alwaysTemplate)
            cell.selectionStyle = .none
            cell.ThemeUpdate()
            return cell
        case LangCommon.wallet.capitalized:
            let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellPaymentMethodTVC") as! CellPaymentMethodTVC
            cell.titlePaymentTxt.text = data.name
            cell.paymentImg.image = data.image
            cell.selectionIV.image = data.isSelected ? UIImage(named: "tick11")?.withRenderingMode(.alwaysTemplate) : nil
            cell.selectionIV.tintColor = .PrimaryColor
            let selectedItem = self.paymentList?.didSelect(optionNamed: data.name)
            cell.changeBtn.isHidden = !(selectedItem?.key == "stripe")
            cell.selectionStyle = .none
            cell.ThemeUpdate()
            return cell
        case LangCommon.promotions:
            if indexPath.row == 0 && header.datas.count > 1{
                
                let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellPromoAppliedTVC") as! CellPromoAppliedTVC
                cell.titleLabel.text = data.name
                //                cell.imageView.image = data.image
              //  cell.promoCountLabel.text = Constants().GETVALUE(keyname: USER_PROMO_CODE)
                cell.selectionStyle = .none
                cell.ThemeChange()
                return cell
                
            }else{
                fallthrough
            }
        default://ADD PromoCode
            let cell = paymentTableView.dequeueReusableCell(withIdentifier: "CellAddNewPromoTVC") as! CellAddNewPromoTVC
            cell.titleLabel.text = " "+data.name
            cell.selectionStyle = .none
            cell.ThemeChange()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let header = self.paymentDataSource[indexPath.section]
        let data = header.datas[indexPath.row]
        
        
        switch header.title {
        case LangCommon.paymentMethods :
            let selectedItem = self.paymentList?.didSelect(optionNamed: data.name)
            if selectedItem?.key == "stripe_card"{
                let vc = AddStripeCardVC.initWithStory(viewController)
                self.viewController.presentInFullScreen(vc, animated: true, completion: {
                    self.viewController.wsToGetOptionList()
                })
            }else{
                selectedItem?.option.setAsDefault()
                Constants().STOREVALUE(value: "\((selectedItem?.icon)!)", keyname: IS_Payment_image)
                switch selectedItem?.option{
                case .cash:
                    PaymentOptions.cash.setAsDefault()
//                    Constants().STOREVALUE(value: selectedItem!.icon, keyname: IS_Payment_image)
                    self.viewController.paymentSelectionDelegate?.cash_isSelected()
                case .paypal:
                    PaymentOptions.paypal.setAsDefault()
                    
                    
                    self.viewController.paymentSelectionDelegate?.paypal_isSelected()
                case .onlinepayment:
                    PaymentOptions.onlinepayment.setAsDefault()
                    
                    
                    self.viewController.paymentSelectionDelegate?.onlinepayment_isSelected()
            
                case .brainTree:
                    
                    PaymentOptions.brainTree.setAsDefault()
                    
                    self.viewController.paymentSelectionDelegate?.brainTree_isSelected()
                default:
                    
                    PaymentOptions.stripe.setAsDefault()
                   
                    self.viewController.paymentSelectionDelegate?.stripe_isSelected()//selectedPayment(method: .stripe)//stripe_isSelected()
                }
                self.viewController.dismiss(animated: true, completion: nil)
            }
          
        case LangCommon.wallet.capitalized:
            if Constants().GETVALUE(keyname: USER_SELECT_WALLET) == "Yes"{
                Constants().STOREVALUE(value: "No" , keyname: USER_SELECT_WALLET)
            }
            else{
                Constants().STOREVALUE(value: "Yes" , keyname: USER_SELECT_WALLET)
            }
            if let list = self.paymentList{
                self.generateTableDataSource(with: list)
            }else{
                self.viewController.wsToGetOptionList()
            }
        case LangCommon.promotions.capitalized:
            fallthrough
        default://Add Promo code
            print()
            self.onAddNewPromoTapped()
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
