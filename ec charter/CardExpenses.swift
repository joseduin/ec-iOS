//
//  CardExpenses.swift
//  ec charter
//
//  Created by Jose Duin on 2/3/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class CardExpenses: UITableViewCell {

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var photo: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var photo_boton: UIButton!
    @IBAction func delete_item(_ sender: UIButton) {
    }
    @IBAction func edit_item(_ sender: UIButton) {
    }
    @IBAction func preview_photo(_ sender: UIButton) {
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
