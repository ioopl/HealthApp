//
//  AppointmentsTableViewCell.swift
//  HealthApp
//
//  Created by UHS on 26/12/2017.
//  Copyright © 2017 Apkia. All rights reserved.
//

import UIKit

class AppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
