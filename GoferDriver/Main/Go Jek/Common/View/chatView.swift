//
//  chatView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 23/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class chatView: BaseView {

    //MARK: variables and outlets
    
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var jobIDLbl: SecondarySmallLabel!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var riderAvatar : UIImageView!
    @IBOutlet weak var chatTableView: CommonTableView!
    @IBOutlet weak var driverName : SecondaryHeaderLabel!
    @IBOutlet weak var driverRating : SecondarySmallHeaderLabel!
    @IBOutlet weak var messageTextField: CommonTextField!
    @IBOutlet weak var arrowImage: PrimaryImageView!
    @IBOutlet weak var chatPlaceholder: SecondaryView!
    @IBOutlet weak var noChatMessage: SecondarySubHeaderLabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bottomChatBar: SecondaryView!
    
    var chatTableRect : CGRect!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.driverRating.customColorsUpdate()
        if let text = self.driverRating.attributedText {
            let attrStr = NSMutableAttributedString(attributedString: text)
            attrStr.setColorForText(textToFind: "⭑",
                                        withColor: .PrimaryColor)
            self.driverRating.attributedText = attrStr
        }
        self.headerView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.driverName.customColorsUpdate()
        self.jobIDLbl.customColorsUpdate()
        self.chatTableView.customColorsUpdate()
        self.chatTableView.reloadData()
        self.messageTextField.customColorsUpdate()
        self.chatPlaceholder.customColorsUpdate()
        self.noChatMessage.customColorsUpdate()
        self.bottomChatBar.customColorsUpdate()
        self.bottomChatBar.transform = .identity
        self.endEditing(true)
    }
    
    
    var viewController = ChatVC()
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as! ChatVC
        self.initView()
        self.initGesture()
        self.darkModeChange()
    }
    func initView(){
        self.jobIDLbl.setTextAlignment(aligned: .right)
        let image = UIImage(named: "sent")?.withRenderingMode(.alwaysTemplate)
        self.arrowImage.image = image
        self.arrowImage.tintColor = .PrimaryColor
        if isRTLLanguage{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.sendBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.arrowImage.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
        }else{
            //self.backBtn.setTitle("e", for: .normal)
        }
        
        if let dImage = self.viewController.riderImage,
            let url = URL(string: dImage){
            self.riderAvatar.sd_setImage(with: url,
                                         placeholderImage: UIImage(named:"user_dummy"),
                                         options: .highPriority,
                                         progress: nil,
                                         completed: nil)
        }else if let thumb_str = self.viewController.preference.string(forKey: TRIP_RIDER_THUMB_URL),
                 let thumb_url = URL(string: thumb_str) {
            self.riderAvatar.sd_setImage(with: thumb_url,
                                         placeholderImage: UIImage(named:"user_dummy"),
                                         options: .highPriority,
                                         progress: nil,
                                         completed: nil)
        }else{
            self.riderAvatar.image = UIImage(named: "user_dummy") ?? UIImage()
        }
        
        //Set name
        if !self.viewController.riderName.isEmpty && self.viewController.riderName != LangCommon.rider{
            self.driverName.text = self.viewController.riderName
        }else if let name = self.viewController.preference.string(forKey: TRIP_RIDER_NAME){
            self.driverName.text = name
        }else{
            self.driverName.text = LangCommon.rider.capitalized
//            self.driverName.text = "Rider".localize

        }
        //Set Rating
        if self.viewController.rating != 0.0{
            self.driverRating.isHidden = false
            let AttrStr = NSMutableAttributedString(string: "\(self.viewController.rating) ⭑")
            AttrStr.setColorForText(textToFind: "⭑", withColor: .PrimaryColor)
            self.driverRating.attributedText = AttrStr
        }else if let str_rating = self.viewController.preference.string(forKey: TRIP_RIDER_RATING),
            let _rating = Double(str_rating),
            _rating != 0.0{
            self.viewController.rating = _rating
            self.driverRating.isHidden = false
            let AttrStr = NSMutableAttributedString(string: "\(_rating) ⭑")
            AttrStr.setColorForText(textToFind: "⭑", withColor: .PrimaryColor)
            self.driverRating.attributedText = AttrStr
        }else{
            self.driverRating.isHidden = true
        }
        self.messageTextField.autocorrectionType = .no
        self.messageTextField.textAlignment = isRTLLanguage ? .right : .left
        self.riderAvatar.isRoundCorner = true
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        if let ID = ChatVC.currentTripID {
            self.jobIDLbl.text = "\(LangCommon.no) #" + ID
        } else {
            self.jobIDLbl.text = "*****"
            print("ID is Missing")
        }
        self.messageTextField.placeholder =  LangCommon.typeAMessage
        self.noChatMessage.text = LangCommon.noMessagesYet
        
//        self.messageTextField.placeholder =  "Type a message...".localize
//        self.noChatMessage.text = "No messages, yet.".localize

        
        self.bottomChatBar.isRoundCorner = true
        self.bottomChatBar.border(0.5, .gray)
        
        self.bottomChatBar.elevate(2.0)
        self.chatTableView.reloadData()
    }
    func initGesture(){
        self.chatTableView.addAction(for: .tap) {
            self.endEditing(true)
        }
        self.addAction(for: .tap) {
            self.endEditing(true)
        }
        self.bottomChatBar.addAction(for: .tap) {
            
        }
        self.chatTableRect = self.chatTableView.frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.chatTableRect = self.chatTableView.frame
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardShowning), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardHidded), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    @objc func KeyboardShowning(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.15) {
            self.bottomChatBar.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
            
           // var contentInsets:UIEdgeInsets
            //(UIApplication.shared.statusBarOrientation)
            if UIApplication.shared.statusBarOrientation.isPortrait {
                self.chatTableView.frame = CGRect(x: 10, y: 10, width: self.chatTableRect.width, height: self.chatTableRect.height - keyboardFrame.height)
                //contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0);
            }
            else {
                self.chatTableView.frame = CGRect(x: 10, y: 10, width: self.chatTableRect.width, height: self.chatTableRect.height - keyboardFrame.width)
              //  contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.width, right: 0.0);
                
            }
            //self.chatTableView.contentInset = contentInsets
            
            let count = self.viewController.messages.count - 1
            if count > 0{
                self.chatTableView.scrollToRow(at: IndexPath(row: count, section: 0),
                                               at: .bottom,
                                               animated: true)
            }
            self.layoutIfNeeded()
        }
        
        
    }
    //hide the keyboard
    @objc func KeyboardHidded(notification: NSNotification)
    {
        
        UIView.animate(withDuration: 0.15) {
            self.bottomChatBar.transform = .identity
           // self.chatTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0);
            self.chatTableView.frame = self.chatTableRect
            let count = self.viewController.messages.count - 1
            if count > 0{
                self.chatTableView.scrollToRow(at: IndexPath(row: count, section: 0),
                                               at: .bottom,
                                               animated: true)
            }
            self.layoutIfNeeded()
        }
    }
    //MARK: Actions
    @IBAction func BackAct(_ sender: UIButton) {
        self.viewController.exitScreen(animated: true)
        ChatVC.currentTripID = nil
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.viewController.sendButtonTapped()
    }
    

}
extension chatView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewController.messages.count
        if count > 0{
            self.chatTableView.backgroundView = nil
            return count
        } else{
            self.chatTableView.backgroundView = self.chatPlaceholder
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.viewController.messages[indexPath.row]
        if message.type == .driver{
            
            let driverURL = URL(string: Shared.instance.userProfile?.user_thumb_image ?? "")
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverCell.identifier) as! ReceiverCell
            cell.setCell(withMessage: message, avatar: self.riderAvatar.image ?? UIImage(named: "user_dummy")!)
            cell.receiverImage.sd_setImage(with: driverURL, placeholderImage: UIImage(named: "user_dummy"), options: .highPriority, context: nil)
            cell.ThemeUpdate()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderCell.identifier) as! SenderCell
            cell.setCell(withMessage: message,avatar: self.riderAvatar.image ?? UIImage(named: "user_dummy")! )
            cell.ThemeUpdate()
            return cell
        }
    }
    
    
}




//MARK: Cells

class SenderCell : UITableViewCell {
    @IBOutlet weak var messageLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var avatarImage : UIImageView!
    @IBOutlet weak var background : UIView!
    
    static var identifier = "SenderCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.ThemeUpdate()
    }
    func ThemeUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.contentView.backgroundColor  = self.isDarkStyle ?
                                .DarkModeBackground :
                                .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setCell(withMessage message: ChatModel,avatar : UIImage){
        self.messageLbl.text = message.message
        self.avatarImage.image = avatar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.background.clipsToBounds = true
            self.avatarImage.clipsToBounds = true
            self.avatarImage.cornerRadius = 10
            self.background.cornerRadius = 10
        }
        self.background.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        self.messageLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
}
class ReceiverCell : UITableViewCell{
    @IBOutlet weak var messageLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var background : UIView!
    @IBOutlet weak var receiverImage: UIImageView!
    
    static var identifier = "ReceiverCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ThemeUpdate()
    }
    
    func ThemeUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.contentView.backgroundColor  = self.isDarkStyle ?
                .DarkModeBackground : .SecondaryColor
            self.messageLbl.textColor = .PrimaryTextColor
        } else {
            // Fallback on earlier versions
        }

        
    }
    
    func setCell(withMessage message: ChatModel,avatar : UIImage){
        self.messageLbl.text = message.message
        self.receiverImage.image = avatar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.background.clipsToBounds = true
            self.receiverImage.clipsToBounds = true
            self.receiverImage.cornerRadius = 10
            self.background.cornerRadius = 10
        }
        self.background.backgroundColor = .PrimaryColor
    }
    
}
