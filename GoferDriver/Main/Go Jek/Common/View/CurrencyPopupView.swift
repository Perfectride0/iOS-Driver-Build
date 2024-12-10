//
//  CurrencyPopupView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 26/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class CurrencyPopupView: BaseView {
    
    //MARK:- Outlets
    var viewControler : CurrencyPopupVC!
    @IBOutlet weak var currencyTable: CommonTableView!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var hoverView: TopCurvedView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var hoverViewHeightCons: NSLayoutConstraint!
    
    var tabBar : UITabBar?
    var currentState : SwipeState = .middle
    var currentSwipe : TypeOfSwipe = .none
    var delegate: currencyListDelegate?
    var strCurrentCurrency = ""
    //MARK:- view life cycle
    override func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = .clear
        self.titleLbl.customColorsUpdate()
        self.hoverView.customColorsUpdate()
        self.currencyTable.customColorsUpdate()
        self.currencyTable.reloadData()
    }
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewControler = baseVC as? CurrencyPopupVC
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        strCurrentCurrency = String(format: "%@ | %@",userCurrencyCode,userCurrencySym)
        self.viewControler.navigationController?.isNavigationBarHidden = true
        self.viewControler.callCurrencyAPI()
        self.initView()
        self.initLanguage()
        self.setupGesture()
        self.darkModeChange()
        self.dismissView.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.initLayer()
        }
    }
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.tabBar?.isHidden = true
        self.backgroundColor = .clear
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        strCurrentCurrency = String(format: "%@ | %@",userCurrencyCode,userCurrencySym)
        
    }
    override func didAppear(baseVC: BaseVC) {
      super.didAppear(baseVC: baseVC)
      self.dismissView.backgroundColor =  UIColor.IndicatorColor.withAlphaComponent(0.5)
    }
    override func willDisappear(baseVC: BaseVC) {
      super.willDisappear(baseVC: baseVC)
        self.tabBar?.isHidden = false
        self.dismissView.backgroundColor = .clear
    }
    
    //MARK:- initializers
    func initLanguage(){
        self.titleLbl.text = LangCommon.currency
    }
    func initView(){
        self.currencyTable.dataSource = self
        self.currencyTable.delegate = self
        self.currentState = .middle
        self.stateBasedAnimation(state: self.currentState)
        self.dismissView.addAction(for: .tap) { [weak self] in
            self?.viewControler.dismiss(animated: true, completion: nil)
        }
    }
    func setupGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.hoverView.addGestureRecognizer(swipeDown)
    }
    
    func swipe(state: SwipeState,
               swipe: TypeOfSwipe) {
        switch state {
        case .full:
            switch swipe {
            case .down:
                self.currentState = .middle
            default:
                print("\(swipe) not Handled")
            }
        case .middle:
            switch swipe {
            case .down:
                self.currentState = .dismiss
            case .up:
                self.currentState = .full
            default:
                print("\(swipe) not Handled")
            }
        default:
            print("\(state) not Handled")
        }
        self.stateBasedAnimation(state: self.currentState)
    }
    
    func stateBasedAnimation(state: SwipeState) {
        UIView.animate(withDuration: 0.7) {
            switch state {
            case .full:
                self.hoverView.transform = .identity
                self.hoverView.frame.size.height = self.frame.height + 30
                self.hoverView.removeSpecificCorner()
            case .middle:
                self.hoverView.transform = CGAffineTransform(translationX: 0, y: self.frame.midY)
                self.hoverView.frame.size.height = (self.frame.height/2) + 30
                self.hoverView.customColorsUpdate()
            case .dismiss:
                self.hoverView.transform = CGAffineTransform(translationX: 0, y: self.frame.maxY)
                self.hoverView.frame.size.height = 30
                self.hoverView.customColorsUpdate()
            }
        } completion: { (isCompleted) in
            if isCompleted && state == .dismiss {
                self.viewControler.dismiss(animated: true) {
                    print("Select Lanaguage is Completely Dismissed")
                }
            }
        }
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                self.currentSwipe = .right
            case .down:
                print("Swiped down")
                self.currentSwipe = .down
            case .left:
                print("Swiped left")
                self.currentSwipe = .left
            case .up:
                print("Swiped up")
                self.currentSwipe = .up
            default:
                break
            }
            self.swipe(state: self.currentState,
                       swipe: self.currentSwipe)
        }
        
    }
    func initLayer(){
        
    }
    func makeCurrencySymbols(encodedString : String) -> String {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    func makeScroll() {
        for i in 0...self.viewControler.arrCurrencyData.count-1 {
            let currencyModel = self.viewControler.arrCurrencyData[i] as CurrencyList
            let str = strCurrentCurrency.components(separatedBy: "  |  ")
            if currencyModel.currency_code as String? == str[0]
            {
                let indexPath = IndexPath(row: i, section: 0)
                currencyTable.scrollToRow(at: indexPath, at: .top, animated: true)
                break
            }
        }
        
    }
    
}
extension CurrencyPopupView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewControler.arrCurrencyData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //            return self.frame.height * 0.115
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : CellCurrency = tableView.dequeueReusableCell(for: indexPath)
        let currencyModel = self.viewControler.arrCurrencyData[indexPath.row] as CurrencyList
        let strSymbol = self.makeCurrencySymbols(encodedString: (currencyModel.currency_symbol as String?)!)
        let checkdata = String(format: "%@ | %@",(currencyModel.currency_code as NSString?)!,strSymbol)
        cell.lblCurrency?.text = String(format: "%@ | %@",(currencyModel.currency_code as NSString?)!,strSymbol)
        cell.imgTickMark?.isHidden = (strCurrentCurrency == checkdata) ? false : true
        cell.imgTickMark?.image = UIImage(named: "tick")
        cell.ThemeUpdate()
        return cell
    }
    
}
extension CurrencyPopupView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = currencyTable.cellForRow(at: indexPath) as! CellCurrency
        appDelegate.nSelectedIndex = indexPath.row
        strCurrentCurrency = (selectedCell.lblCurrency?.text)!
        let str = strCurrentCurrency.components(separatedBy: " | ")
        Constants().STOREVALUE(value: str[1], keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        Constants().STOREVALUE(value: str[0], keyname: USER_CURRENCY_ORG_splash)
        self.viewControler.delegate?.onCurrencyChanged(currencyCode: str[0], symbol: str[1])
        currencyTable.reloadData()
        self.viewControler.dismiss(animated: true) {
            self.viewControler.callback?(str[0])
        }
        
    }
    
}

class CellCurrency: UITableViewCell
{
    @IBOutlet var lblCurrency: SecondarySubHeaderLabel?
    @IBOutlet var imgTickMark: PrimaryBorderedImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
    }
    
    func ThemeUpdate() {
        self.lblCurrency?.customColorsUpdate()
        self.imgTickMark?.customColorsUpdate()
    }
    
}
