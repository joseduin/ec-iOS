//
//  AircraftReport.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class AircraftReport {
    
    var id: Int
    var report: Report
    var description: String
    var photo: String
    
    init(id: Int, report: Report, description: String, photo: String) {
        self.id = id
        self.report = report
        self.description = description
        self.photo = photo
    }
    
    convenience init() {
        self.init(id: 0, report: Report(), description: "", photo: "")
    }
    
}
