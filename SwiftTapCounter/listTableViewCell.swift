//
//  listTableViewCell.swift
//  SwiftTapCounter
//
//  Created by Amesten Systems on 15/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit

class listTableViewCell: UITableViewCell {

    @IBOutlet var listLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
