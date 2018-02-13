//
//  CardSettingsCombo.swift
//  ec charter
//
//  Created by Jose Duin on 2/3/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class CardSettingsCombo: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var delete_button: UIButton!
    @IBAction func item_delete(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
