

import UIKit

class RecepientTVC : UITableViewCell {
    
    @IBOutlet weak var reasonsStack: UIStackView!
    @IBOutlet weak var cameraTextLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var cameraIV: PrimaryImageView!
    @IBOutlet weak var selectedIV : PrimaryImageView!
    @IBOutlet weak var recepientDataLbl : SecondaryExtraSmallLabel!
    @IBOutlet var contactlessview: SecondaryView!
    @IBOutlet var contactlesstitleLbl: SecondaryExtraSmallLabel!
    @IBOutlet var contactlessImage: UIImageView!
    @IBOutlet var addimageview: SecondaryView!
    @IBOutlet var changeimageview: SecondaryView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        themeChange()
        self.selectionStyle = .none
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectedIV.isHidden = true
    }
    
    func themeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contactlessview.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.cameraIV.customColorsUpdate()
        self.cameraTextLbl.customColorsUpdate()
        self.recepientDataLbl.customColorsUpdate()
        self.contactlessview.customColorsUpdate()
        self.contactlesstitleLbl.customColorsUpdate()
        self.addimageview.customColorsUpdate()
        self.changeimageview.customColorsUpdate()
        self.selectedIV.customColorsUpdate()
    }
    
    func populate(with data: DropoffOption,
                  isSelected : Bool) {
        self.recepientDataLbl.text = data.name
        self.selectedIV.image = UIImage(named : "tick11.png")?.withRenderingMode(.alwaysTemplate)
        self.selectedIV.isHidden = !isSelected
    }
}
