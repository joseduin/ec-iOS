//
//  CardHistory.swift
//  ec charter
//
//  Created by Jose Duin on 2/3/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class CardHistory: UITableViewCell {

    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var aircraft: UILabel!
    @IBOutlet weak var capitan: UILabel!
    @IBOutlet weak var copilot: UILabel! 
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var draft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
