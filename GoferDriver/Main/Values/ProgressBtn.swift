import CoreGraphics
import UIKit

enum ProgressState{
    case normal
    case loading
}
protocol ProgressButtonDelegates {
    func didActivateProgress()
}
class ProgressButton : UIButton{
    
    var tState = TripStatus.request
    var dragImg = UIImageView()
    var loaderPadding : CGFloat = 3
   
    private var pState : ProgressState = .normal
    private var maxFrame : CGRect!
    private var minFrame : CGRect!
    private var spinnerView = JTMaterialSpinner()
    private var delegate : ProgressButtonDelegates?
    
    private let dragImgMaxAlpha : CGFloat = 0.35
    private let minAlapha : CGFloat = 0.0
    // Handy Splitup Start
    var businessId : BusinessType?
    // Handy Splitup End
    fileprivate var title = String()
    var btnState : ProgressState {
        get{return pState}
        set{self.pState = newValue}
    }
    var tripState : TripStatus {
        get{return tState}
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func initialize(_ delegate : ProgressButtonDelegates,
                    // Handy Splitup Start
                    businessId: BusinessType? = .Services)
                    // Handy Splitup End
    {
        self.delegate = delegate
        self.dragImg.image = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
        self.dragImg.tintColor = .white
        self.dragImg.alpha = dragImgMaxAlpha
        self.btnState = .normal
        self.maxFrame = self.frame
        // Handy Splitup Start
        self.businessId = businessId
        // Handy Splitup End
        self.minFrame = CGRect(x: maxFrame.midX - maxFrame.height / 2,
                               y: maxFrame.minY,
                               width: maxFrame.height,
                               height: maxFrame.height)
        let upPadding = maxFrame.height * 0.1
        self.dragImg.frame = CGRect(x: 0,
                                    y: -upPadding,
                                    width: maxFrame.height * 1.2,
                                    height: maxFrame.height * 1.2)
        if isRTLLanguage {
            self.dragImg.frame = CGRect(x: maxFrame.maxX - maxFrame.height * 1.2,
                                        y: -upPadding,
                                        width: maxFrame.height * 1.2,
                                        height: maxFrame.height * 1.2)
            self.dragImg.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        
        self.spinnerView.frame =  CGRect(x: (maxFrame.midX - maxFrame.height / 2) + self.loaderPadding,
                                         y: maxFrame.minY + self.loaderPadding,
                                         width: maxFrame.height - self.loaderPadding * 2,
                                         height: maxFrame.height - self.loaderPadding * 2)
     
        self.addSubview(self.dragImg)
        self.bringSubviewToFront(self.dragImg)
        self.spinnerView.circleLayer.lineWidth = 3
        self.spinnerView.circleLayer.strokeColor = UIColor.SecondaryColor.cgColor
        
        self.superview?.addSubview(self.spinnerView)
        self.superview?.bringSubviewToFront(self.spinnerView)
        self.spinnerView.isUserInteractionEnabled = false
        self.spinnerView.alpha = 0
        self.spinnerView.beginRefreshing()
        //self.oncli
        let slideGesture = UIPanGestureRecognizer(target: self, action: #selector(self.slidePanHanlder(_:)))
        self.dragImg.addGestureRecognizer(slideGesture)
        self.dragImg.isUserInteractionEnabled = true
    }
    func setTitle(_ title: String) {
        self.title = title
        if self.btnState != .loading{
            // Handy Splitup Start
            switch self.businessId {
            case .Delivery:
                self.setTitle(title, for: .normal)
            default:
                // Handy Splitup End
                self.setTitle(LangCommon.slideTo + " " + title, for: .normal)
                // Handy Splitup Start
            }
            // Handy Splitup End
        }
        
    }
    
    
    
    func setCustomTitle(_ title: String) {
           self.title = title
           if self.btnState != .loading{
               if title.contains("Reached"){
                   self.setTitle(title, for: .normal)
                   self.backgroundColor = UIColor.PrimaryColor
               }else if title.contains("BEGIN TRIP"){
                   self.setTitle(LangCommon.slideTo + " " + title, for: .normal)
                   self.backgroundColor = UIColor.PrimaryColor
               }else if title.contains("END TRIP"){
                   self.setTitle(LangCommon.slideTo + " " + title, for: .normal)
                   self.backgroundColor = UIColor.PrimaryColor
               }else{
                   self.setTitle(LangCommon.slideTo + " " + title, for: .normal)
                   self.backgroundColor = UIColor.PrimaryColor
               }
           }
       }
    

    
    

    
    func set2Trip(state : TripStatus){
        self.tState = state
        self.setState(.normal)
        // Handy Splitup Start
        switch self.businessId {
        case .Delivery:
            self.setTitle(state.getDeliveryDisplayText)
        default:
            // Handy Splitup End
            self.setTitle(state.getDisplayText)
            // Handy Splitup Start
        }
        // Handy Splitup End
    }
    @objc func slidePanHanlder(_ gesture : UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.dragImg)
        let xMovement = translation.x
        self.titleLabel?.text = ""
        switch gesture.state {
        case .began,.changed:
            if isRTLLanguage {
                self.dragImg.transform = CGAffineTransform(translationX: xMovement, y: 0).concatenating(CGAffineTransform(scaleX: -1, y: 1))
                self.titleLabel?.alpha = 1 - (-xMovement / self.frame.width)
            } else {
                self.dragImg.transform = CGAffineTransform(translationX: xMovement, y: 0)
                self.titleLabel?.alpha = 1 - (xMovement / self.frame.width)
            }
        default:
            if xMovement > self.frame.midX {
                guard xMovement > 0 && xMovement < self.frame.width else {return}
                self.setState(.loading)
                self.dragImg.alpha = minAlapha
                self.titleLabel?.alpha = 0
            }else{
                self.titleLabel?.alpha = 1
                self.setState(.normal)
            }
            if isRTLLanguage {
                self.dragImg.transform =  CGAffineTransform.identity.concatenating(CGAffineTransform(scaleX: -1, y: 1))
            } else {
                self.dragImg.transform = .identity
            }
        }
    }
    func setState(_ state : ProgressState){
        DispatchQueue.main.async {
            self.btnState = state
            self.setTitle("", for: .normal)
            self.isUserInteractionEnabled = state != .loading
            UIView.animate(withDuration: 0.6,
                           animations: {
                            switch self.btnState{
                            case .loading:
                                self.spinnerView.frame = self.frame
                                self.clipsToBounds = true
                                //self.frame = self.minFrame
                                self.layer.frame = self.minFrame
                                self.layer.cornerRadius = self.minFrame.height * 0.5
                                self.spinnerView.alpha = 1
                                self.dragImg.alpha = self.minAlapha
                                self.setTitle( "" , for: .normal)
                            default:
                                self.clipsToBounds = true
                                // self.frame = self.maxFrame
                                self.layer.frame = self.maxFrame ?? self.frame
//                                self.layer.cornerRadius = (self.minFrame?.height ??  45) * 0.05
                                self.layer.cornerRadius = (self.minFrame?.height ??  45) * 0.15
                                self.spinnerView.alpha = 0
                                self.dragImg.alpha = self.dragImgMaxAlpha
//                                self.setTitle(self.title, for: .normal)
                                
                            }
                            self.translatesAutoresizingMaskIntoConstraints = true
                           }) { (_) in
                //  self.setTitle(state == .loading ? "" : self.title, for: .normal)
                if state == ProgressState.loading{
                    self.delegate?.didActivateProgress()
                    self.titleLabel?.alpha = 0
                }else{
                    self.setTitle(self.title)
                    self.titleLabel?.alpha = 1
                }
            }
            
        }
    }
}
