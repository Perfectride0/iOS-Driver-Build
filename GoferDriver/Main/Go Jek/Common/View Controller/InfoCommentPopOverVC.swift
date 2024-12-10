//
//  InfoCommentPopOverVC.swift
//  GoferDriver
//
//  Created by trioangle on 06/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

class InfoCommentPopOverVC: UIViewController {

    
    @IBOutlet weak var commentLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.themeChange()
    }
    
    func themeChange() {
        let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
        self.view.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.commentLbl.textColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.themeChange()
    }
    
    func setFont(_ font : String,
                 weight : CGFloat) {
        self.commentLbl.font = UIFont(name: font,
                                      size: weight)
    }
    
    func set(font : UIFont) {
        self.commentLbl.font = font
    }
    
    //MARK:- initWithStory
    class func initWithStory(preferredFrame size : CGSize,on host : UIView) -> InfoCommentPopOverVC{
        let infoWindow : InfoCommentPopOverVC = UIStoryboard.gojekCommon.instantiateViewController()
        infoWindow.preferredContentSize = size
        infoWindow.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = infoWindow.popoverPresentationController!
        popover.delegate = infoWindow
        popover.sourceView = host
        popover.backgroundColor = UIColor(hex: "ECF2FB")
        popover.permittedArrowDirections = UIPopoverArrowDirection.down
        
        
        return infoWindow
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension InfoCommentPopOverVC : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
extension UIViewController {
    func showPopOver(withComment comment : String,on host : UIView){
        let infoWindow = InfoCommentPopOverVC
            .initWithStory(preferredFrame: CGSize(width: self.view.frame.width,
                                                  height: 100),
                           on: host)
        self.present(infoWindow, animated: true, completion: {
            infoWindow.commentLbl.text = comment
            infoWindow.set(font: .MediumFont(size: 17))
        })
    }
}
