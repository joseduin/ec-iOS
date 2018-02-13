//
//  Report.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation

class Report {
    
    var id: Int
    var customer: String
    var passengers: String
    var passengers_photo: String
    var aircraft: String
    var capitan: String
    var copilot: String
    var date: String
    var route: String
    var gps_flight_time: Double
    var hour_initial: Double
    var hour_final: Double
    var long_time: Double
    var remarks: String
    var send: Bool
    var engine1: Double
    var engine2: Double
    var comboEngine1: String
    var comboEngine2: String
    var cockpit: Bool
    
    init(id: Int, customer: String, passengers: String, passengers_photo: String, aircraft: String, capitan: String, copilot: String, date: String, route: String, gps_flight_time: Double, hour_initial: Double, hour_final: Double, long_time: Double, remarks: String, send: Bool, engine1: Double, engine2: Double, comboEngine1: String, comboEngine2: String, cockpit: Bool) {
    
        self.id = id
        self.customer = customer
        self.passengers = passengers
        self.passengers_photo = passengers_photo
        self.aircraft = aircraft
        self.capitan = capitan
        self.copilot = copilot
        self.date = date
        self.route = route
        self.gps_flight_time = gps_flight_time
        self.hour_initial = hour_initial
        self.hour_final = hour_final
        self.long_time = long_time
        self.remarks = remarks
        self.send = send
        self.engine1 = engine1
        self.engine2 = engine2
        self.comboEngine1 = comboEngine1
        self.comboEngine2 = comboEngine2
        self.cockpit = cockpit
    }
    
    convenience init() {
        self.init(id: 0, customer: "", passengers: "", passengers_photo: "", aircraft: "", capitan: "", copilot: "", date: "", route: "", gps_flight_time: 0.0, hour_initial: 0.0, hour_final: 0.0, long_time: 0.0, remarks: "", send: false, engine1: 0.0, engine2: 0.0, comboEngine1: "", comboEngine2: "", cockpit: false)
    }
    
}
