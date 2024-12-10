
/**
 * ChangePaymentVC.swift
 *
 * @package UberClone
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */
import UIKit


protocol paymentMethodSelection{
    func paypal_isSelected()
    func stripe_isSelected()
    func cash_isSelected()
    func brainTree_isSelected()
    func onlinepayment_isSelected()
}


class ChangePaymentVC: BaseVC {
    
    var paymentSelectionDelegate : paymentMethodSelection?
    let viewModel = PayoutVM()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let preference = UserDefaults.standard
    var isFromWallect:Bool = false
    
    var canShowPaymentMethods = true
    var canShowWallet = true
    var canShowPromotion = true
    
    @IBOutlet var changePaymentView: ChangePaymentView!
    
  
    //MARK: view life cycle
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    

    
    func wsToGetOptionList(){
        _ = UberSupport()
        //          uberLoader.showProgressInWindow(showAnimation: true)
        viewModel.getPaymentOptions(["is_wallet":"1"]) { (result) in
            switch result {
            case .success(let json):
                let model = json.setModel(type: PaymentList.self)
                
                
                self.changePaymentView.generateTableDataSource(with: model)
            case .failure(let error):
                
                //self.appDelegate.createToastMessage(error.localizedDescription)
                debug(print: error.localizedDescription)
                break
                
            }
        }
        
    }
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.wsToGetOptionList()
        self.changePaymentView.wallectamount = Constants().GETVALUE(keyname: USER_WALLET_AMOUNT)
        self.changePaymentView.addButton.isUserInteractionEnabled = true
        if UserDefaults.isNull(for: .payment_method) {
            PaymentOptions.paypal.setAsDefault()
        }
        changePaymentView.arrpayment = [LangCommon.cash.uppercased(),LangCommon.paypal.uppercased()]

        changePaymentView.arrpaymentImages = ["cash","paypalnew"]
    }
    

    
    
    //MARK: initWith Story
    class func initWithStory(showingPaymentMethods : Bool = true,
                             wallet : Bool = true,
                             promotions : Bool = true) -> ChangePaymentVC {
        let view : ChangePaymentVC = UIStoryboard.gojekCommon.instantiateIDViewController()
        return view
    }
}
extension ChangePaymentVC : UpdateContentProtocol{
    func updateContent() {
        self.wsToGetOptionList()
    }
}
class CellPaymentMethodTVC : UITableViewCell {
    
    @IBOutlet weak var titlePaymentTxt: SecondarySmallBoldLabel!
    @IBOutlet weak var paymentImg: UIImageView!
    @IBOutlet weak var selectionIV: UIImageView!
    @IBOutlet weak var selectionImgHolderView: UIView!
    @IBOutlet weak var changeBtn: TransparentPrimaryButton!
    @IBOutlet weak var lineLbl: UILabel!
    
    func ThemeUpdate() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.changeBtn.setTextAlignment()
        self.changeBtn.setTitle(LangCommon.change.capitalized,
                                for: .normal)
        self.titlePaymentTxt.customColorsUpdate()
        self.paymentImg.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
}
class CellPromoAppliedTVC : UITableViewCell{
    
    @IBOutlet weak var promoCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promoButoon: UIButton!
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
    }
    
}
class CellAddNewPromoTVC : UITableViewCell {
    
    @IBOutlet weak var addNewPromoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
    }
}

