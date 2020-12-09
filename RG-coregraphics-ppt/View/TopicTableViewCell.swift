//
//  TopicTableViewCell.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 07/12/20.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
