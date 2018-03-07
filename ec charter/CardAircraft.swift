//
//  CardAircraft.swift
//  ec charter
//
//  Created by Jose Duin on 2/3/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class CardAircraft: UITableViewCell {

    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var photo: UILabel!
    @IBOutlet weak var photo_boton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func photo_preview(_ sender: UIButton) {
    }

}
