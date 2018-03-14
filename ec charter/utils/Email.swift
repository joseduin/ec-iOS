//
//  Email.swift
//  ec charter
//
//  Created by Jose Duin on 2/13/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class Email {
    
    let EMAIL: String = "1flightreport@gmail.com"
    let EMAIL_REPORT: String = "ecchmant@gmail.com"
    let SPLIT: String = " - "
    
    func titleNormalEmail(report: Report) -> String {
        return "\(report.customer)\(self.SPLIT)\(report.capitan)\(self.SPLIT)\(report.date)\(self.SPLIT)\(report.route)"
    }
    
    func titleReportEmail(report: Report) -> String {
        return "\(report.aircraft)\(self.SPLIT)\(report.capitan)\(self.SPLIT)\(report.date)\(self.SPLIT)\(report.route)"
    }
    
    func validateStringNull(s: String) -> String {
        return s.isEmpty ? "" : s
    }
    
    func basic(report: Report, cantImg: Int) -> String {
        var emailText: String = ""
        emailText += "CUSTOMER:                  \(self.validateStringNull(s: report.customer)) \n"
        emailText += "PASSENGERS:               \(validateStringNull(s: report.passengers)) \n"
        var c = cantImg
        if !report.passengers_photo.isEmpty {
            c = c + 1
            emailText += "PASSENGERS PHOTO: #\(c) \n"
        }
        emailText += "AIRCRAFT:                      \(self.validateStringNull(s: report.aircraft)) \n"
        emailText += "CAPITAN:                        \(self.validateStringNull(s: report.capitan)) \n"
        emailText += "COPILOT:                        \(self.validateStringNull(s: report.copilot)) \n"
        if report.cockpit {
            emailText += "COCKPIT SPLITTED \n"
        }
        emailText += "DATE:                               \(report.date) \n"
        emailText += "ROUTE:                            \(self.validateStringNull(s: report.route)) \n"
        emailText += "GPS FLIGHT TIME:         \(String(format:"%.2f", report.gps_flight_time)) \n"
        emailText += "HOUR INITIAL:                \(String(format:"%.2f",report.hour_initial)) \n"
        emailText += "HOUR FINAL:                  \(String(format:"%.2f",report.hour_final)) \n"
        emailText += "LOG TIME:                        \(String(format:"%.1f",report.long_time)) \n"
        
        return emailText;
    }
    
    func expense(expenses: [Expenses], cantImg: Int) -> String {
        var emailText: String = ""
        emailText += "\n EXPENSES \n"
        var c = cantImg

        for expense in expenses {
            emailText += "   TOTAL:                         \(expense.total) \(expense.currency) \n"
            emailText += "   DESCRIPTION:           \(expense.description) \n"
            if !expense.photo.isEmpty {
                c = c + 1
                emailText += "   PHOTO:                       #\(c)\n"
            }
            emailText += "   --------------------------- \n"
        }
        return emailText;
    }
    
    func aircraft(aircrafts: [AircraftReport], report: Report, cantImg: Int) -> String {
        var emailText: String = ""
        emailText += "\n AIRCRAFT REPORT \n"
        var c = cantImg

        if aircrafts.count > 0 {
            for aircraf in aircrafts {
                emailText += "   DESCRIPTION:           \(aircraf.description) \n"
                c = c + 1
                if !aircraf.photo.isEmpty {
                    emailText += "   PHOTO:                       #\(c) \n"
                }
                emailText += "   --------------------------- \n"
            }
        }
        
        emailText += "\n"
        if report.engine1 != 0.0 {
            emailText += "ENGINE 1:                      \(String(format:"%.2f",report.engine1)) \(report.comboEngine1) \n"
        }
        
        if report.engine2 != 0.0 {
            emailText += "ENGINE 2:                      \(String(format:"%.2f",report.engine2)) \(report.comboEngine2) \n"
        }
        
        return emailText;
    }
    
}
