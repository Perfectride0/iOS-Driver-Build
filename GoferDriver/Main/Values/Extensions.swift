//
//  Extensions.swift
//  Handyman
//
//  Created by trioangle1 on 05/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import ImageIO
extension UIView{
    @IBInspectable
    var isRounded: Bool{
        get{
            return layer.cornerRadius == frame.width * 0.5
        }
        set{
            if newValue{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
                    self.layer.cornerRadius = self.frame.width * 0.5
                }
            }else{
    //                layer.cornerRadius = 0.0
            }
        }
    }
}

extension UITableView {
    func refreshFooter(inSection section: Int) {
           UIView.setAnimationsEnabled(false)
           beginUpdates()

           let footerView = self.footerView(forSection: section)
           footerView?.sizeToFit()
           
           endUpdates()
           UIView.setAnimationsEnabled(true)
       }
}

@IBDesignable
class DesiganableTextFiled: UITextField {
    
    @IBInspectable var leftImage : UIImage?
        {
        didSet{
            updateViewDesign()
        }
    }
    
    @IBInspectable var rightImage : UIImage?
        {
        didSet{
            updateViewDesign()
        }
    }
    
    
func updateViewDesign()
{
    if let image = leftImage{
        leftViewMode = .always
        let imageView = UIImageView(frame:CGRect(x: 20, y: 10, width: 14, height: 13))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        view.addSubview(imageView)
        
        leftView = view
    }
    else if let image = rightImage{
            rightViewMode = .always
            let imageView = UIImageView(frame:CGRect(x: 20, y: 10, width: 14, height: 13))
            imageView.image = image
        imageView.contentMode = .scaleAspectFit
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            view.addSubview(imageView)
            
            rightView = view
        }
    else
    {
        leftViewMode = .never
        rightViewMode = .never
    }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
//
//MARK: - UILabel
//
@IBDesignable class CustomUILabel: UILabel {
    
    //Se the corner radius
    override func draw(_ rect: CGRect) {
        labelSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        labelSetup()         //to show the corner radius in interface builder
    }
    
    //Label setup
    func labelSetup() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
        
    }
}
//
//MARK: - UIButton
//
@IBDesignable class CustomUIButton: UIButton {
    
    //Se the corner radius
    override func draw(_ rect: CGRect) {
        buttonSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        buttonSetup()         //to show the corner radius in interface builder
    }
    
    //Button setup
    func buttonSetup() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}
extension UIButton {
    func toBarButtonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(customView: self)
    }
    func secodaryThemeCorner() {
        self.isRoundCorner = true
    }
}

enum JobStatusTheme {
    case completed
    case Pending
    case cancelled

    var color : UIColor {
        switch self {
        case .completed:
            return .CompletedStatusColor
        case .cancelled:
            return .CancelledStatusColor
        default:
            return .PendingStatusColor
        }
    }
}
//
//MARK: - UIView Corner Radius
//
@IBDesignable class CustomUIView: UIView {
    
    override func draw(_ rect: CGRect) {
        viewSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        viewSetup()         //to show the corner radius in interface builder
    }
    
    //Button setup
    func viewSetup() {
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}

@IBDesignable class CustomDashedView: UIView {

  
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
@IBDesignable class ShadowView: UIView {
    @IBInspectable var shadow : Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadiusWithShadow : CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: -1.0, height: 1.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 2.0) {
        layer.masksToBounds = false
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

@IBDesignable class ShadowButton: UIButton {
	@IBInspectable var shadow : Bool {
		get {
			return layer.shadowOpacity > 0.0
		}
		set {
			if newValue == true {
				self.addShadow()
			}
		}
	}
	
	@IBInspectable var cornerRadiusWithShadow : CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
			
			// Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
			if shadow == false {
				self.layer.masksToBounds = true
			}
		}
	}
	func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
				   shadowOffset: CGSize = CGSize(width: -1.0, height: 1.0),
				   shadowOpacity: Float = 0.3,
				   shadowRadius: CGFloat = 2.0) {
		layer.masksToBounds = false
		layer.shadowOffset = shadowOffset
		layer.shadowColor = shadowColor
		layer.shadowRadius = shadowRadius
		layer.shadowOpacity = shadowOpacity
		
		let backgroundCGColor = backgroundColor?.cgColor
		backgroundColor = nil
		layer.backgroundColor =  backgroundCGColor
	}
}


//
//MARK: - Sparkl background view
//
@IBDesignable class CustomBackgroundUIView : UIView {
    
    //Se the corner radius
    override func awakeFromNib() {
        super.awakeFromNib()            //Initialize the NIB
        backgroundViewSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundViewSetup()         //to show the corner radius in interface builder
    }
    
    //Button setup
    func backgroundViewSetup() {
        let shapeLayer = CAShapeLayer(layer:layer)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:layer.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:layer.bounds.size.width, y:layer.bounds.size.height - (layer.bounds.size.height*0.15)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:layer.bounds.size.height - (layer.bounds.size.height*0.15)), controlPoint: CGPoint(x:layer.bounds.size.width/2, y:layer.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        shapeLayer.path = arrowPath.cgPath
        shapeLayer.frame = layer.bounds
        shapeLayer.masksToBounds = true
        layer.mask = shapeLayer
    }
}


//
//MARK: - UIView
//
extension UIView {
    
    var isDarkStyle : Bool {
        get {
          //  self.traitCollection.userInterfaceStyle == .dark
            if #available(iOS 17.0, *) {
                Shared.instance.isdarkmode
            }
            else{
                self.traitCollection.userInterfaceStyle == .dark
            }
        }
    }
    
    //Corner Radius
    @IBInspectable
    var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    //Border Width
    @IBInspectable
    var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    //Border Color
    @IBInspectable
    var borderColor : UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    //The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowOpacity = newValue
        }
    }
    
    //The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowOffset = newValue
        }
    }
    
    //The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable
    var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            layer.masksToBounds = false
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    func anchor(toView : UIView,
                   leading : CGFloat? = nil,
                   trailing : CGFloat? = nil,
                   top : CGFloat? = nil,
                   bottom : CGFloat? = nil){
           
           self.translatesAutoresizingMaskIntoConstraints = false
           if let _leading = leading{
               self.leadingAnchor
                   .constraint(equalTo: toView.leadingAnchor, constant: _leading)
                   .isActive = true
           }
           if let _trailing = trailing{
               self.trailingAnchor
                   .constraint(equalTo: toView.trailingAnchor, constant: _trailing)
                   .isActive = true
           }
           if let _top = top{
               self.topAnchor
                   .constraint(equalTo: toView.topAnchor, constant: _top)
                   .isActive = true
           }
           if let _bottom = bottom{
               self.bottomAnchor
                   .constraint(equalTo: toView.bottomAnchor, constant: _bottom)
                   .isActive = true
           }
           
       }
    
    func setEqualHightWidthAnchor(toView : UIView,
                                  height: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: toView.heightAnchor).isActive = true
        if let _height = height {
            self.heightAnchor.constraint(equalToConstant: _height).isActive = true
        }
    }
    
    func setCenterXYAncher(toView : UIView,
                           centerX: Bool = false,
                           centerY: Bool = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if centerX {
            self.centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
        }
        if centerY {
            self.centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
        }
    }
    
    func getViewExactHeight(view:UIView)->UIView {
           
            let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = view.frame
            if height != frame.size.height {
                frame.size.height = height
                view.frame = frame
            }
            return view
        }
    func bottomShadow(shadowSize : CGFloat = 5,shadowDistance: CGFloat = 5,shadowRadius:CGFloat = 5,shadowOpacity:Float = 0.4) {
        let shadowSize: CGFloat = shadowSize
        let shadowDistance: CGFloat = shadowDistance
        let contactRect = CGRect(x: -shadowSize, y: self.frame.height - (shadowSize * 0.4) + shadowDistance, width: self.frame.width + shadowSize * 2, height: shadowSize)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
}

extension Int {
    var boolValue: Bool { return self != 0 }

}

//
//MARK: - UIViewController
//
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension String {
    
    func evaluate(with condition: String) -> Bool {
        guard let range = range(of: condition,
                                options: .regularExpression,
                                range: nil,
                                locale: nil) else {
                                    return false
        }
        
        return range.lowerBound == startIndex
            && range.upperBound == endIndex
    }
    
    var isBlank: Bool {             //check Blank textfield
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var toSpaceString:String {          //to space string
        return "   " + self + "   "
    }
    
    func toPhoneNumberFormat() -> String {          //Phone number format
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    func toGetFirstCharacter() -> String {          // get first characters of string
        var stringCharacters = ""
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex, options: .byWords) { (substring, _, _, _) in
            if let substring = substring { stringCharacters += substring.prefix(1) }
        }
        return stringCharacters
    }
    
    func toDateFormatted(with string: String)-> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = string
        return formatter.date(from: self)
    }
    
     //swap the characters
    func swapAt(_ index1: Int, _ index2: Int) -> String {
        var characters = Array(self)
        characters.swapAt(index1, index2)
        return String(characters)
    }
}



func isPhoneNumberValid(text: String) -> Bool {
    let regexp = "^[0-9]{10}$"
    return text.evaluate(with: regexp)
}

func isZipCodeValid(text: String) -> Bool {
    let regexp = "^[0-9]{5}$"
    return text.evaluate(with: regexp)
}

func isStateValid(text: String) -> Bool {
    let regexp = "^[A-Z]{2}$"
    return text.evaluate(with: regexp)
}

func isCVCValid(text: String) -> Bool {
    let regexp = "^[0-9]{3,4}$"
    return text.evaluate(with: regexp)
}

func isEmailValid(text: String) -> Bool {
    let regexp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    return text.evaluate(with: regexp)
}
func isPasswordContainsSpecialCharacter(text:String) -> Bool {
    let regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?&]{6,}$"
    return text.evaluate(with: regexp)
}
func isPasswordValid(text: String) -> Bool {
    if !isPasswordContainsSpecialCharacter(text: text) {
        return false
    }
    return true
}

func isAlphaNumeric(text: String) -> Bool {
    let regexp = "^[a-zA-Z0-9_]*$" //"[^a-zA-Z0-9]"
    return text.evaluate(with: regexp)
}


extension AVCaptureDevice {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizeVideo(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.video, completion: completion)
    }
    
    class func authorizeAudio(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: AVMediaType.audio, completion: completion)
    }
    
    private class func authorize(mediaType: AVMediaType, completion: ((AuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            authorizationImagePickerAlert(title: appName, message: LangCommon.pleaseGivePermissionToAccessCamera)
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if(granted) {
                        completion?(.justAuthorized)
                    }
                    else {
                        completion?(.justDenied)
                    }
                }
            })
        @unknown default:
            print("Error=========")
        }
    }
}

//
//MARK: - PHPhotoLibrary
//
extension PHPhotoLibrary {
    enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizePhotoLibrary(completion: ((AuthorizationStatus) -> Void)?) {
        let authorizeStatus = PHPhotoLibrary.authorizationStatus()
            switch authorizeStatus{
            case .denied:
                authorizationImagePickerAlert(title: appName, message: LangCommon.pleaseGivePermission)
                completion?(.alreadyDenied)
                break
            case .authorized:
                 completion?(.alreadyAuthorized)
                break
            case .restricted:
                completion?(.restricted)
                break
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                    switch status{
                    case .authorized:
                        completion?(.justAuthorized)
                    case .denied:
                        completion?(.justDenied)
                        break
                    default:
                        break
                    }
                })
                break
            default:
                break
            }
    }
}

//
//MARK: - Image picker authorization alert
//
func authorizationImagePickerAlert(title:String, message:String) -> Void {
    let commonAlert = CommonAlert()
    commonAlert.setupAlert(alert: title,alertDescription: message,  okAction: LangCommon.ok, cancelAction: LangCommon.cancel)
    commonAlert.addAdditionalOkAction(isForSingleOption: false) {
  
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                    // Fallback on earlier versions
                }
            }
        }
}

//MARK: MainStory board to use localize concept
extension UILabel{
    @IBInspectable
    var localize : Bool{
        get{
            return false
        }
        set{
            
        }
    }
}

extension UITextField {
    @IBInspectable
    var localizePlaceHolder: Bool {
        get {
            return false
        }
        set {
            
        }
    }
}

extension UIButton {
    @IBInspectable
    var localizeTitle: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.setTitle(self.currentTitle, for: .normal)
            }
        }
    }
}

extension UITextView {
    @IBInspectable
    var localizeText: Bool {
        get {
            return false
        }
        set {
            
        }
    }
}
extension UIButton{
    
    func setMainActive(_ active : Bool){
        if active{
            self.backgroundColor = .PrimaryColor
            self.isUserInteractionEnabled = true
        }else{
            self.backgroundColor = .TertiaryColor
            self.isUserInteractionEnabled = false
        }
    }
    func setLightActive(_ active : Bool){
        if active{
            self.backgroundColor = .PrimaryColor
            self.isUserInteractionEnabled = true
        }else{
            self.backgroundColor = .TertiaryColor
            self.isUserInteractionEnabled = false
        }
    }
}
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}
extension Double {
      static let twoFractionDigits: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          formatter.minimumFractionDigits = 1
          formatter.maximumFractionDigits = 4
          return formatter
      }()
      var formatted: String {
          return Double.twoFractionDigits.string(for: self) ?? ""
      }
  }
extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.0
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 250)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)]).withRenderingMode(.alwaysTemplate)
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame.withRenderingMode(.alwaysTemplate))
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    func anySatisfy(_ condition: @escaping (Element)-> Bool) -> Bool{
        for item in self{
            if condition(item){return true}
        }
        return false
    }
}

extension UITableView {
   func reloadDataWithAutoSizingCellWorkAround() {
       self.reloadData()
       self.setNeedsLayout()
       self.layoutIfNeeded()
       self.reloadData()
   }
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIApplication {
    func topViewController(_ base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        switch (base) {
        case let controller as UINavigationController:
            return topViewController(controller.visibleViewController)
        case let controller as UITabBarController:
            return controller.selectedViewController.flatMap { topViewController($0) } ?? base
        default:
            return base?.presentedViewController.flatMap { topViewController($0) } ?? base
        }
    }
}

extension UIViewController {
    func findLastBeforeVC() -> UIViewController? {
        if let controllers = self.navigationController?.viewControllers,
           controllers.count >= 2 {
            return controllers.value(atSafe: controllers.count - 2)
        } else {
            return self.navigationController?.viewControllers.last
        }
    }
}

extension NSMutableAttributedString {
    
    var fontSize:CGFloat { return 12 }
    
    var normalFont:UIFont { return UIFont(name: G_MediumFont, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func greenTextColor(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.init(named: "Green") ?? .PrimaryColor
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func colouredTextCreator(_ value: String,_ colour: UIColor)  -> NSMutableAttributedString  {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : colour
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func ImageColorSet(_ img : UIImage, imgColour : UIColor) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = img.withRenderingMode(.alwaysTemplate)
        let imgAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: imgColour,
                ]
        let attachmentString = NSMutableAttributedString(attachment: attachment)
                attachmentString.addAttributes(
                    imgAttributes,
                    range: NSMakeRange(
                        0,
                        attachmentString.length
                    )
                )
        self.append(attachmentString)
        return self
    }
    func normal(_ value:String,fontSize: CGFloat = 17) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.lightFont(size: fontSize),
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func bold(_ value:String,fontSize: CGFloat = 17) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.BoldFont(size: fontSize)
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func underlined(_ value:String,
                    fontSize: CGFloat = 17,
                    fontWeight: UIFont.Weight = .bold) -> NSMutableAttributedString {
        let font : UIFont!
        if fontWeight == .bold {
            font = .BoldFont(size: fontSize)
        } else {
            font = .lightFont(size: fontSize)
        }
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  font ?? .systemFont(ofSize: fontSize),
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
}

extension NSNotification {
    func getKeyboardHeight() -> CGFloat? {
        guard let keyboardFrame: NSValue = self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
        let keyboardRectangle = keyboardFrame.cgRectValue
        return keyboardRectangle.height
        
    }
}

extension UILabel {
    func setTextAlignment(aligned: NSTextAlignment = .left) {
        switch aligned {
        case .right:
            self.textAlignment = isRTLLanguage ? .left : .right
        case .left:
            self.textAlignment = isRTLLanguage ? .right : .left
        default:
            self.textAlignment = aligned
        }
        
    }
}

extension UIButton {
    func setTextAlignment(aligned: NSTextAlignment = .left) {
        switch aligned {
        case .right:
            self.contentHorizontalAlignment = isRTLLanguage ? .left : .right
        case .left:
            self.contentHorizontalAlignment = isRTLLanguage ? .right : .left
        default:
            self.contentHorizontalAlignment = .center
        }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
}

extension UITextField {
    func setTextAlignment(aligned: NSTextAlignment = .left) {
        switch aligned {
        case .right:
            self.textAlignment = isRTLLanguage ? .left : .right
        case .left:
            self.textAlignment = isRTLLanguage ? .right : .left
        default:
            self.textAlignment = aligned
        }
    }
}

extension UITextView {
    func setTextAlignment(aligned: NSTextAlignment = .left) {
        switch aligned {
        case .right:
            self.textAlignment = isRTLLanguage ? .left : .right
        case .left:
            self.textAlignment = isRTLLanguage ? .right : .left
        default:
            self.textAlignment = aligned
        }
    }
}
extension NSMutableAttributedString {
    func fontChange(_ value:String,font: UIFont) {
        let range: NSRange = self.mutableString.range(of: value, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
extension NSMutableAttributedString {
    func setColorForText(textToFind: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textToFind,
                                                      options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor,
                          value: color,
                          range: range)
    }
    func setFont(textToFind: String,
                 weight: UIFont.Weight,
                 fontSize: CGFloat) {
        let range: NSRange = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        switch weight {
        case .light:
            let myAttribute = [ NSAttributedString.Key.font: UIFont.lightFont(size: fontSize) ]
            self.setAttributes(myAttribute, range: range)
        case .medium:
            let myAttribute = [ NSAttributedString.Key.font: UIFont.MediumFont(size: fontSize) ]
            self.setAttributes(myAttribute, range: range)
        case .bold:
            let myAttribute = [ NSAttributedString.Key.font: UIFont.BoldFont(size: fontSize) ]
            self.setAttributes(myAttribute, range: range)
        default:
            let myAttribute = [ NSAttributedString.Key.font: UIFont.lightFont(size: fontSize) ]
            self.setAttributes(myAttribute, range: range)
        }
    }
    
}
