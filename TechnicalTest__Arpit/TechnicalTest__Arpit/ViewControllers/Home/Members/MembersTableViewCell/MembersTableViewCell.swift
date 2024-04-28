//
//  PostTableViewCell.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var memberInfo: [String:String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      

    }

    func setUpMemberData(memberInfo: [String:String]) {
        self.memberInfo = memberInfo
        self.lblMobile.text = memberInfo["mobileNumber"] as? String ?? ""
        self.lblName.text = memberInfo["name"] as? String ?? ""
        self.lblEmail.text = memberInfo["email"] as? String ?? ""
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
