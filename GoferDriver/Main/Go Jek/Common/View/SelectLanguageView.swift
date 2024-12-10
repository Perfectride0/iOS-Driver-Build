//
//  SelectLanguageView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
enum SwipeState {
  case full
  case middle
  case dismiss
}

enum TypeOfSwipe {
  case left
  case right
  case up
  case down
  case none
}

class SelectLanguageView : BaseView {
  
  
  @IBOutlet weak var dismissView : UIView!
  @IBOutlet weak var hoverView : TopCurvedView!
  @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
  @IBOutlet weak var languageTable : CommonTableView!
  @IBOutlet weak var hoverViewHeightCons: NSLayoutConstraint!
  
  var currentState : SwipeState = .middle
  var currentSwipe : TypeOfSwipe = .none
  var oldOrgin : CGPoint = .zero
  var oldSize : CGSize = .zero
  var viewController : SelectLanguageVC!
  
 
  override func didLoad(baseVC: BaseVC) {
    super.didLoad(baseVC: baseVC)
    viewController = baseVC as? SelectLanguageVC
    self.initView()
    self.initLanguage()
    self.setupGesture()
    self.darkModeChange()
    self.currentState = .middle
    self.stateBasedAnimation(state: self.currentState)
    self.dismissView.backgroundColor = .clear
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      self.initLayer()
    }
  }
  override func didAppear(baseVC: BaseVC) {
    super.didAppear(baseVC: baseVC)
    self.dismissView.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
  }
  override func willDisappear(baseVC: BaseVC) {
    super.willDisappear(baseVC: baseVC)
    self.dismissView.backgroundColor = .clear
  }
  //MARK:- initializers
  func initLanguage(){
    self.titleLbl.text = LangCommon.selectLanguage
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
        self.viewController.dismiss(animated: true) {
          print("Select Lanaguage is Completely Dismissed")
        }
      }
    }
  }
  
  override func darkModeChange() {
    super.darkModeChange()
    self.backgroundColor = .clear
    self.hoverView.customColorsUpdate()
    self.titleLbl.customColorsUpdate()
    self.languageTable.customColorsUpdate()
    self.languageTable.reloadData()
    
  }
  func setupGesture() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    swipeUp.direction = .up
    self.addGestureRecognizer(swipeUp)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    swipeDown.direction = .down
    self.hoverView.addGestureRecognizer(swipeDown)
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
  func initView() {
    self.languageTable.dataSource = self
    self.languageTable.delegate = self
    self.dismissView.addAction(for: .tap) { [weak self] in
      self?.viewController.dismiss(animated: true, completion: nil)
    }
  }
  func initLayer(){
    
  }
  
}

extension SelectLanguageView : UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availableLanguages.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.frame.height * 0.115
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell : LanguageTVC = tableView.dequeueReusableCell(for: indexPath)
    guard let data = availableLanguages.value(atSafe: indexPath.row) else{return cell}
    cell.populate(with: data)
    cell.ThemeChange()
    return cell
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      self.stateBasedAnimation(state: .full)
  }
}

extension SelectLanguageView : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedLang = availableLanguages.value(atSafe: indexPath.row),
          let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
    if selectedLang == currentLanguage {
      self.viewController.dismiss(animated: true, completion: nil)
    } else {
      if let _ = UserDefaults.standard.string(forKey: USER_ACCESS_TOKEN){
        self.viewController.update(language: selectedLang)
      } else {
        selectedLang.saveLanguage()
        appDelegate.makeSplashView(isFirstTime: false)
        //                appDelegate.onSetRootViewController(viewCtrl: self.viewController)
      }
    }
  }
}
