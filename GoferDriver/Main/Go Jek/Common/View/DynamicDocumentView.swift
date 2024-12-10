//
//  DynamicDocumentView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class DynamicDocumentView: BaseView {

        //MARK:- Outlets
    @IBOutlet weak var titleLbl : PrimaryHeaderLabel!
    @IBOutlet weak var docTableView : CommonTableView!
    @IBOutlet weak var contentBGView: TopCurvedView!
    @IBOutlet weak var headerView: HeaderView!
    
    // MARK: - Variable
    var menuPresenter : MenuPresenter!
    var selectedIndex : IndexPath?
    var viewController: DynamicDocumentVC!
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? DynamicDocumentVC
        self.initView()
        self.darkModeChange()
//        self.backBtn?.setTitle(AppWebConstants.ClassConstants.language.getBackBtnText(), for: .normal)
    }
    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.docTableView.customColorsUpdate()
        self.contentBGView.customColorsUpdate()
        self.docTableView.reloadData()
    }
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        if self.viewController.documents.allSatisfy({$0.urlString.isEmpty}){
           self.titleLbl.text = LangCommon.addDocument.capitalized
       }else{
           self.titleLbl.text = LangCommon.manageDocuments.capitalized
       }
    }
    override func didAppear(baseVC: BaseVC) {
        super.didAppear(baseVC: baseVC)
        self.docTableView.reloadData()
    }
    //MARK:- initializers
    func initView(){
        self.docTableView.dataSource = self
        self.docTableView.delegate = self
        switch self.viewController.purposeFor {
        case .forDriver(id: _):
//            self.titleLbl.text = "Manage Driver Documents"
            self.titleLbl.text = LangCommon.manageDocuments.capitalized
        case .forVehicle(id: _):
            self.titleLbl.text = LangDelivery.manageVehicleDocuments
        default:break
        }
        
    }
    //MARK:- Action
       @IBAction func backAction(_ sender : UIButton){
        if self.viewController.isPresented(){
            self.viewController.dismiss(animated: true, completion: nil)
           }else{
            self.viewController.navigationController?.popViewController(animated: true)
           }
       }
}
extension DynamicDocumentView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewController.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DynamicDocTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let document = self.viewController.documents.value(atSafe: indexPath.row) else{return cell}
        cell.ThemeUpdate()
        cell.populate(wihtDoc: document)
//        let expand = self.selectedIndex != indexPath
        cell.docActionStack.isHidden = true
        cell.dropBtn.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1, y: 1) : .identity
        cell.dropBtn.isUserInteractionEnabled = false
//        cell.dropBtn.transform = CGAffineTransform(scaleX: 1, y: expand ? 1 : -1)
        return cell
    }
    
    
}
extension DynamicDocumentView : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedIndex = self.selectedIndex == indexPath ? nil : indexPath
//        tableView.reloadData()
        guard let document = self.viewController.documents.value(atSafe: indexPath.row) else{return}
        let propertyView =  DocumentDetailVC.initWithStory(purpose: self.viewController.purposeFor,
                                                         forDoc: document,
                                                         usingDelegate: self)
        self.viewController.navigationController?.pushViewController(propertyView, animated: true)
    }
}
extension DynamicDocumentView : DocumentUploadDelegate{
    func documentDetail(onUpload: DynamicDocumentModel) {
        
    }
    
    
    
}
