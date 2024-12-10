/**
* LoadWebKitView.swift
*
* @package GoferDriver
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit

class LoadWebKitView : BaseVC{
    
    @IBOutlet var loadwebkitsubview: LoadWebKitSubView!
    
    var strWebUrl = ""

    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- initWithStory
    class func initWithStory() -> LoadWebKitView{
        let view : LoadWebKitView = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onAddListTapped(){
        
    }
}




