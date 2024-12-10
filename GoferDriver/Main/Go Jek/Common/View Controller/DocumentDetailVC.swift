/**
 * DocumentMainVC.swift
 *
 * @package GoferDriver
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */



import UIKit
import Foundation
import IQKeyboardManagerSwift

protocol DocumentUploadDelegate
{
    func documentDetail(onUpload : DynamicDocumentModel)
    
}

class DocumentDetailVC: BaseVC
{
    var delegate: DocumentUploadDelegate?
    var documet : DynamicDocumentModel!
    var purpose : DynamicDocumentVC.Purpose!
   
    @IBOutlet var documentDetailView: DocumentDetailView!
    override var stopSwipeExitFromThisScreen: Bool?{
        return !self.documentDetailView.viewMediaHoder.isHidden
    }
    // MARK: - ViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
    }
    
  
    class func initWithStory(purpose : DynamicDocumentVC.Purpose,
        forDoc doc : DynamicDocumentModel,
                             usingDelegate delegate : DocumentUploadDelegate) -> DocumentDetailVC{
        let view : DocumentDetailVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.delegate = delegate
        view.purpose = purpose
        view.documet = doc
        return view
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
}




