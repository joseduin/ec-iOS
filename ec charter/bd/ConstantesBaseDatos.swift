//
//  ConstantesBaseDatos.swift
//  ec charter
//
//  Created by Jose Duin on 2/9/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation
import SQLite

class ConstantesBaseDatos {
    
    let DATABASE_NAME = "ec_charter";
    let DATABASE_EXTENSION = "sqlite3";

    let TABLE_REPORT                    = Table("report")
    let TABLE_REPORT_ID                 = Expression<Int>("id")
    let TABLE_REPORT_CUSTOMER           = Expression<String>("customer")
    let TABLE_REPORT_PASSENGERS         = Expression<String>("passengers")
    let TABLE_REPORT_PASSENGERS_PHOTO   = Expression<String>("passengers_photo")
    let TABLE_REPORT_AIRCRAFT           = Expression<String>("aircraft")
    let TABLE_REPORT_CAPITAN            = Expression<String>("capitan")
    let TABLE_REPORT_COPILOT            = Expression<String>("copilot")
    let TABLE_REPORT_DATE               = Expression<String>("date")
    let TABLE_REPORT_ROUTE              = Expression<String>("route")
    let TABLE_REPORT_GPS_FLIGHT_TIME    = Expression<Double>("gps_flight_time")
    let TABLE_REPORT_HOUR_INITIAL       = Expression<Double>("hour_initial")
    let TABLE_REPORT_HOUR_FINAL         = Expression<Double>("hour_final")
    let TABLE_REPORT_LONG_TIME          = Expression<Double>("long_time")
    let TABLE_REPORT_REMARKS            = Expression<String>("remarks")
    let TABLE_REPORT_SEND               = Expression<Int>("send")
    let TABLE_REPORT_ENGINE_1           = Expression<Double>("engine_1")
    let TABLE_REPORT_ENGINE_2           = Expression<Double>("engine_2")
    let TABLE_REPORT_COMBO_ENGINE_1     = Expression<String>("combo_engine_1")
    let TABLE_REPORT_COMBO_ENGINE_2     = Expression<String>("combo_engine_2")
    let TABLE_REPORT_COCKPIT            = Expression<Int>("cockpit")
    let TABLE_REPORT_PASSENGERS_PHOTO_B = Expression<String>("passengers_photo_b")

    let TABLE_EXPENSES                = Table("expenses")
    let TABLE_EXPENSES_ID             = Expression<Int>("id")
    let TABLE_EXPENSES_ID_REPORT      = Expression<Int>("id_report")
    let TABLE_EXPENSES_TOTAL          = Expression<Double>("total")
    let TABLE_EXPENSES_CURRENCY       = Expression<String>("currency")
    let TABLE_EXPENSES_DESCRIPTION    = Expression<String>("description")
    let TABLE_EXPENSES_PHOTO          = Expression<String>("photo")
    let TABLE_EXPENSES_PHOTO_B        = Expression<String>("photo_b")

    let TABLE_AIRCRAFT_REPORT             = Table("aircraft_report")
    let TABLE_AIRCRAFT_REPORT_ID          = Expression<Int>("id")
    let TABLE_AIRCRAFT_REPORT_ID_REPORT   = Expression<Int>("id_report")
    let TABLE_AIRCRAFT_REPORT_DESCRIPTION = Expression<String>("description")
    let TABLE_AIRCRAFT_REPORT_PHOTO       = Expression<String>("photo")
    let TABLE_AIRCRAFT_REPORT_PHOTO_B     = Expression<String>("photo_b")

    let TABLE_LIST_CUSTOMER    = Table("list_customer")
    let TABLE_LIST_AIRCRAFT    = Table("list_aircraft")
    let TABLE_LIST_CAPITAN     = Table("list_capitan")
    let TABLE_LIST_COPILOT     = Table("list_copilot")
    let TABLE_LIST_CURRENCY    = Table("list_currency")
    let TABLE_LIST_ENGINE      = Table("list_engine")
    
    let TABLE_LIST_ID          = Expression<Int>("id")
    let TABLE_LIST_DESCRIPTION = Expression<String>("description")
    
    func booleanConvert(b: Int) -> Bool {
        return b != 0
    }
    
    func intergetConvert(b: Bool) -> Int {
        return b ? 1 : 0
    }
    
    func bd() -> String {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(self.DATABASE_NAME).appendingPathExtension(self.DATABASE_EXTENSION)
            return fileUrl.path
        } catch {
            print(error)
            return ""
        }
    }
    
}
