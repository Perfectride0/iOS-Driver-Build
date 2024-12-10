//
//  StarStackView.swift
//  GoferHandy
//
//  Created by trioangle on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit


class StarStackView : UIStackView{
    @IBOutlet var stars : [UIImageView]!
    
    
    private var rating : Double = 0.0
    private var initalStartPoint : CGFloat?
    lazy var panGesture : UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.onPanGesutreAction(_:)))
    }()
    lazy var tapGesture : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.onTapGesutreAction(_:)))
    }()
    func setRating(_ rating : Double){
        
        self.isHidden = rating == 0
        self.rating = rating
        let intRatingValue = Int(rating)
       
        for index in Array(0...stars.count){
            let star = stars.value(atSafe: index)
            star?.image = UIImage(named: "StarFull")
            if index < intRatingValue{
                star?.tintColor = .systemYellow
            }else{
                star?.tintColor = UIColor(hex: "EFF1F3")
            }
            
        }
        if rating - Double(intRatingValue) > 0{
            self.stars.value(atSafe: intRatingValue)?.image = UIImage(named: "StarHalf")
        }
        
        
    }
    func getRating() -> Double{
        return rating
    }
    
    func ratingValue(canBeEdited editingEnabled : Bool){
        if editingEnabled{
            self.addGestureRecognizer(self.panGesture)
            self.addGestureRecognizer(self.tapGesture)
            self.isUserInteractionEnabled = true
           
        }else{
            self.removeGestureRecognizer(self.panGesture)
            self.removeGestureRecognizer(self.tapGesture)
        }
    }
    @objc
    func onPanGesutreAction(_ gesture : UIPanGestureRecognizer){

//        let rtlValue : CGFloat = isRTL ? 1 : -1
        let translation = gesture.translation(in: self)
        gesture.location(in: self)
        let xMovement = translation.x
        let finalXValue : CGFloat
        switch gesture.state {
        case .began:
            let viewX = gesture.location(in: self).x
            self.initalStartPoint = viewX
            finalXValue = viewX + xMovement
        case .changed:
            finalXValue = (self.initalStartPoint ?? 0.0) + xMovement
        case .ended:
            fallthrough
        default:
            finalXValue = (self.initalStartPoint ?? 0.0) + xMovement
            self.initalStartPoint = nil
            
        }
        let calculateXValue = ((finalXValue / self.frame.width) * 100) / 20
        let doubleValue = Double(calculateXValue < 1 ? 1 : calculateXValue > 4.5 ? 5 : calculateXValue)
        self.setRating(doubleValue)
    }
        @objc
        func onTapGesutreAction(_ gesture : UITapGestureRecognizer){

            let finalXValue = gesture.location(in: self).x
            let calculateXValue = ((finalXValue / self.frame.width) * 100) / 20
            print("ş:\(calculateXValue)")
            let doubleValue = Double(calculateXValue < 1 ? 1 : calculateXValue > 4.5 ? 5 : calculateXValue)
            self.setRating(doubleValue.rounded(.up))
        }
}
