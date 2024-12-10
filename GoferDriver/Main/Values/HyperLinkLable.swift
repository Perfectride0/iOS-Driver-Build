//
//  HyperLinkLable.swift
//  GoferDriver
//
//  Created by trioangle on 15/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
class HyperLinkModel{
    var url : URL
    var string : String
    init(url : URL, string : String) {
        self.url = url
        self.string = string
    }
    
    fileprivate func findRange(inString fullText: String){
        let nsStr = (fullText) as NSString
        self.fullText = fullText
        self.range = nsStr.range(of: self.string)
        
    }
    var range : NSRange!
    var fullText : String!
    fileprivate static var textLinks : [Int : [HyperLinkModel] ] =  [Int : [HyperLinkModel] ]()
    
}

private var AssociatedObjectHandle: UInt8 = 28
extension UILabel{
   
    var linkId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setText(_ fullText : String,withLinks links : [HyperLinkModel]){
        let underlineAttribute : [NSAttributedString.Key : Any] = [
        .foregroundColor : self.isDarkStyle ? UIColor.DarkModeTextColor : UIColor.SecondaryTextColor,
        .font : UIFont.MediumFont(size: 13)]
        let underlineAttributedString = NSMutableAttributedString(string: fullText,
                                                                  attributes: underlineAttribute)
        let full_attr_str = underlineAttributedString
        let highlight = UIColor.ThemeTextColor
        let attributes : [NSAttributedString.Key : Any] = [.foregroundColor : highlight,
                                                           .underlineColor : highlight,
                                                           .underlineStyle : NSUnderlineStyle.single.rawValue,
                                                           .font : UIFont.MediumFont(size: 13)]
        for link in links{
            link.findRange(inString: fullText)
            full_attr_str.addAttributes(attributes, range: link.range!)
            
        }
        let id = HyperLinkModel.textLinks.count
        HyperLinkModel.textLinks[id] = links
        self.linkId = id
        
        self.attributedText = full_attr_str
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.attributedLabelTapped(_:)))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    @objc func attributedLabelTapped(_ gesture :UITapGestureRecognizer){
        guard let links = HyperLinkModel.textLinks[self.linkId] else {return}
        for link in links{
            if gesture.didTapAttributedTextInLabel(label: self, inRange: link.range){
                UIApplication.shared.open(link.url)
            }
        }
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * CGFloat(0.5) - textBoundingBox.origin.x,
                                          y:(labelSize.height - textBoundingBox.size.height) * CGFloat(0.5) - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
