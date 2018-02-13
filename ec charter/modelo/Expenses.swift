//
//  Expenses.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class Expenses {
    
    var id: Int
    var report: Report
    var total: Double
    var currency: String
    var description: String
    var photo: String
    
    init(id: Int, report: Report, total: Double, currency: String, description: String, photo: String) {
        self.id = id
        self.report = report
        self.total = total
        self.currency = currency
        self.description = description
        self.photo = photo
    }
    
    convenience init() {
        self.init(id: 0, report: Report(), total: 0.0, currency: "", description: "", photo: "")
    }
    
}
