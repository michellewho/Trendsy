//
//  CustomTableViewCell.swift
//  Trendsy
//
//  Created by Michelle Ho on 12/4/18.
//  Copyright © 2018 Michelle Ho. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
