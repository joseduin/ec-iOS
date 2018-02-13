//
//  Hora.swift
//  ec charter
//
//  Created by Jose Duin on 2/10/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class Hora {
    
    let formatter = DateFormatter()
    
    func today() -> String {
        formatter.dateFormat = "dd-MMM-yy"
        return formatter.string(from: Date()).uppercased()
    }
    
    func time() -> String {
        formatter.dateFormat = "dd-MMM-yy-HH-mm-ss"
        return formatter.string(from: Date())
    }
    
}
