//
//  Lista.swift
//  ec charter
//
//  Created by Jose Duin on 2/9/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class Lista {
    
    var id: Int
    var description: String
    
    init(id: Int, description: String) {
        self.id = id
        self.description = description
    }
    
    convenience init() {
        self.init(id: 0, description: "")
    }
    
}
