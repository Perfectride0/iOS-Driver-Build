//
//  WelcomeView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class WelcomeView: BaseView {
    
    //-----------------------------
    // MARK: - Outlets
    //-----------------------------
    
    @IBOutlet weak var viewHolder: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var appLogoIV : UIImageView!
    @IBOutlet weak var welcomeBackLbl: SecondaryLargeLabel!
    @IBOutlet weak var loginToGoLbl: SecondaryRegularLargeLabel!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var btnSignIn: PrimaryButton!
    @IBOutlet weak var btnSignUp: SecondaryBorderedButton!
    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var langValueLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencyLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var languageDropArrowIV: CommonColorImageView!
    @IBOutlet weak var lookingForUserBtn: TransparentPrimaryButton!
    @IBOutlet weak var currencyDropArrowIV: CommonColorImageView!
    
    //-----------------------------
    // MARK: - Class Variables
    //-----------------------------
    
    var pushManager : PushNotificationManager!
    var viewController:WelcomeVC!
    
    //-----------------------------
    //MARK:- Life Cycle
    //-----------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? WelcomeVC
        AppUtilities().cornerRadiusWithShadow(view: self.bottomView)
        self.initView()
        self.makeMenuAnimation()
        self.startAnimation()
        self.setCountryInfo()
        self.initLanguage()
        self.initGestures()
        self.darkModeChange()
    }
    
    override
    func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.btnSignIn.isExclusiveTouch = true
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.viewController.navigationController?.isNavigationBarHidden = true
        self.viewController.getCountryList()
    }
    
    override
    func didAppear(baseVC: BaseVC) {
        super.didAppear(baseVC: baseVC)
        UIView.animateKeyframes(withDuration: 1.2, delay: 0.15, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.layoutIfNeeded()
            })
        }, completion: { (_) in
        })
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.bottomView.customColorsUpdate()
        self.btnSignIn.customColorsUpdate()
        self.btnSignUp.customColorsUpdate()
        self.currencyLbl.customColorsUpdate()
        self.langValueLbl.customColorsUpdate()
        self.welcomeBackLbl.customColorsUpdate()
        self.loginToGoLbl.customColorsUpdate()
        self.languageDropArrowIV.customColorsUpdate()
        self.currencyDropArrowIV.customColorsUpdate()
        self.lookingForUserBtn.customColorsUpdate()
        self.lookingForUserBtn.titleLabel?.font = .BoldFont(size: 16)
    }
    
    //---------------------------------------
    // MARK: - Initializers
    //---------------------------------------
    
    func initView() {
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.btnSignIn.isExclusiveTouch = true
        self.btnSignIn.setTitleColor(.ThemeTextColor, for: .normal)
        
    }
    
    func initLayers(){
        self.btnSignIn.border(1, .PrimaryColor)
        self.btnSignUp.backgroundColor = .PrimaryColor
    }
    
    func initGestures() {
        self.langView.addAction(for: .tap) { [weak self] in
            let view = SelectLanguageVC.initWithStory()
            view.modalPresentationStyle = .overCurrentContext
            self?.viewController.present(view, animated: true, completion: nil)
            self?.langValueLbl.text = currentLanguage.lang
        }
        self.currencyView.addAction(for: .tap) { [weak self] in
            let view = CurrencyPopupVC.initWithStory()
            view.modalPresentationStyle = .overCurrentContext
            self?.viewController.present(view, animated: true, completion: nil)
            view.callback = {(str) in
                self?.currencyLbl.text = str
            }
        }
    }
    
    //---------------------------------------------------------
    //MARK: - init Language
    //---------------------------------------------------------
    
    func initLanguage() {
        self.btnSignIn.setTitle(LangCommon.continueWithPhone, for: .normal)
        self.btnSignUp.setTitle(LangCommon.register.lowercased().capitalized, for: .normal)
        self.langValueLbl.text = currentLanguage.lang
        self.appLogoIV.image = #imageLiteral(resourceName: "goferjek-Driver")
        self.appLogoIV.cornerRadius = 30
        self.welcomeBackLbl.text = LangCommon.welcomeBack
        self.loginToGoLbl.text = LangCommon.loginToContinue
        let text = LangDeliveryAll.lookingForTheUserApp == "" ? "Looking for User App?" :  LangDeliveryAll.lookingForTheUserApp     /*LangCommon.looking_for_user*/
        self.lookingForUserBtn.setTitle(text, for: .normal)
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        self.currencyLbl.text = userCurrencyCode.description
    }
    
    //---------------------------------------------------------
    // MARK:- Getting Country Dial Code and Flag from plist file
    //---------------------------------------------------------
    
    func setCountryInfo() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let flag = CountryModel(withCountry: Shared.instance.defaultCountryCode)
            flag.store()
        }
    }
    
    //---------------------------------------------------------
    // MARK: - Button Actions
    //---------------------------------------------------------
    
    @IBAction
    func registerBtnAction(_ sender: Any) {
        self.viewController.navigateToRegisterVC()
    }
    
    @IBAction
    func loginBtnAction(_ sender: UIButton?) {
        self.viewController.navigateToLoginVC()
    }
    
    @IBAction
    func lookingForUserBtnPressed(_ sender: Any) {
        self.callRiderApp()
    }
    
    func callRiderApp() {
        let instagramUrl = URL(string: "\(redirectionLink.capitalized)://")
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(instagramUrl!)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(instagramUrl!)
            }
        } else {
            if let url = URL(string: "https://itunes.apple.com/us/app/\(RideriTunes().appStoreDisplayName)/\(RideriTunes().appID)?mt=8") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    //---------------------------------------------------------
    // MARK: - Parrallax effect for Image
    //---------------------------------------------------------
    
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(
            keyPath: "center.x",
            type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(
            keyPath: "center.y",
            type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal,
                               vertical]
        vw.addMotionEffect(group)
    }
    
    //---------------------------------------------------------
    // MARK: Show aimation
    //---------------------------------------------------------
    
    func setupShareAppViewAnimationWithView(_ view:UIView,
                                            deleyTime:Double){
        view.transform = CGAffineTransform(
            translationX: 0,
            y: self.viewHolder.frame.size.height)
        UIView.animate(
            withDuration: 1.0,
            delay: deleyTime,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: UIView.AnimationOptions.allowUserInteraction,
            animations: {
                    view.transform = CGAffineTransform.identity
                    view.alpha = 1.0;
                }, completion: nil)
    }
    
    func startAnimation() {
        let animation = CircularRevealAnimation(
            from: CGPoint(x: self.bounds.width / 2,
                          y: self.bounds.height / 2),
            to: self.viewController.view.bounds)
        self.layer.mask = animation.shape()
        self.alpha = 1
        animation.commit(duration: 0.5, expand: true, completionBlock: {
            self.layer.mask = nil
        })
    }
    
    //---------------------------------------------------------
    //MARK:- Making spring damn animation
    //---------------------------------------------------------
    
    func makeMenuAnimation() {
        let initialDelay = 0.5;
        var i = 0.0;
        for view in viewHolder.subviews {
            setupShareAppViewAnimationWithView(
                view,
                deleyTime: initialDelay + i)
            i=i + 0.1;
        }
    }
    
}

//---------------------------------------------------------
//MARK: - Mobile Number Validation Protocol
//---------------------------------------------------------

extension WelcomeView : MobileNumberValiadationProtocol{
    func verified(number: MobileNumber) {
        let registerView = RegisterVC
            .initWithStory(withNumber: number.number,
                           number.flag,
                           navigaiton: self.viewController)
        self.viewController.navigationController?
            .pushViewController(registerView,
                                animated: true)
    }
}
