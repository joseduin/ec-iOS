//
//  Variable.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation
import UIKit

class Variable {
    
    let tabColor = UIColor(red:18/255.0, green: 106/255.0, blue: 170/255.0, alpha: 1)
    
    func menuSettings() ->[String] {
        var menu:[String] = [String]()
        menu.append("CUSTOMER")
        menu.append("AIRCRAFT")
        menu.append("CAPITAN / COPILOT")
        return menu
    }
}

