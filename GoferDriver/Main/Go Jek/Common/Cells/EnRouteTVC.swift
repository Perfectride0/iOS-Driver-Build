//
//  EnRouteTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 27/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class EnRouteTVC: BaseTableViewCell {

    
    @IBOutlet weak var bottomLineView: SecondaryView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var outerView: PrimaryView!
    @IBOutlet weak var number: PrimaryButtonTypeLabel!
    @IBOutlet weak var timeLbl: SecondaryRegularLabel!
    @IBOutlet weak var statusLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var innerDot : UIView!
    @IBOutlet weak var lineView : SecondaryView!
    @IBOutlet weak var elevatedView : SecondaryView!
    @IBOutlet weak var dotView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setTheme()
    }

    func setTheme() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.setSpecificCornersForTop(cornerRadius: 15)
        self.lineView.customColorsUpdate()
        self.lineView.backgroundColor = .clear
        self.mainView.backgroundColor = .clear
        self.innerDot.backgroundColor = .PrimaryColor
        self.dotView.elevate(2)
        self.timeLbl.customColorsUpdate()
        self.elevatedView.layer.cornerRadius = 10
        self.elevatedView.elevate(2)
        self.elevatedView.customColorsUpdate()
        self.statusLbl.customColorsUpdate()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView,color:UIColor) {
        DispatchQueue.main.async {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.lineDashPattern = [6.2, 2]
            let path = CGMutablePath()
            path.addLines(between: [p0, p1])
            shapeLayer.path = path
            view.layer.addSublayer(shapeLayer)
        }
    }
    func addDottedLayer(view: UIView,color: CGColor) {
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = color
        lineLayer.lineWidth = 2
        lineLayer.lineDashPattern = [6.2, 2]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: view.bounds.midX, y: view.bounds.minY),
                                CGPoint(x: view.bounds.midX, y: view.bounds.maxY)])
        lineLayer.path = path
        view.layer.addSublayer(lineLayer)
    }
}
