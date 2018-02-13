//
//  Email.swift
//  ec charter
//
//  Created by Jose Duin on 2/13/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class Email {
    
    let EMAIL: String = "josemiguelduin@gmail.com"//"1flightreport@gmail.com"
    let EMAIL_REPORT: String = "ecchmant@gmail.com"
    let SPLIT: String = " - "
    
    func titleNormalEmail(report: Report) -> String {
        return "\(report.customer)\(self.SPLIT)\(report.capitan)\(self.SPLIT)\(report.date)\(self.SPLIT)\(report.route)"
    }
    
}
