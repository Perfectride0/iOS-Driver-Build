//
//  GenderSelectionVCViewController.swift
//  Goferjek Driver
//
//  Created by trioangle on 20/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class GenderSelectionViewController: BaseVC {
//MARK: - Outlets
    @IBOutlet var genderSelectionView: GenderSelectionView!
    
//MARK: - Local Variables
    var accViewModel : AccountViewModel!
    var homeModel : HandyHomeViewModel!
    class func initWithStory() -> GenderSelectionViewController{
        let view : GenderSelectionViewController = UIStoryboard.kirangofer.instantiateViewController()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func onUpdateGender(params: [AnyHashable: Any]){
        self.accViewModel.profileVCApiCall(parms: params){(result) in
            switch result{
            case .success(let val):
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                //AppDelegate.shared.createToastMessage(error.localizedDescription)
                break
              
            }
            
        }
    }
  
}
