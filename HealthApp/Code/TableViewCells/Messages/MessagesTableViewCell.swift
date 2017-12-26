//
//  MessagesTableViewCell.swift
//  HealthApp
//
//  Created by UHS on 26/12/2017.
//  Copyright © 2017 Apkia. All rights reserved.
//

import UIKit

protocol MessagesTableViewCellDelegate {
    func messagesTableViewCellDeleteDidTapped(_ messageTableViewCell: MessagesTableViewCell)
}
class MessagesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    // MARK: Variables
    var delegate: MessagesTableViewCellDelegate?
    // To get indexpath.row in custom cell from main class
    var indexPathForCell: IndexPath?

    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    @IBAction func deleteButtonDidTapAction(_ sender: Any) {
        // Pass the viewcontroller as a delegate itself.
        delegate?.messagesTableViewCellDeleteDidTapped(self)
    }
}
