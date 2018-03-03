//
//  BaseDatos.swift
//  ec charter
//
//  Created by Jose Duin on 2/9/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation
import SQLite

class BaseDatos {
    
    var database: Connection!
    let bd: ConstantesBaseDatos = ConstantesBaseDatos()
    
    init() {
        do {
            self.database = try Connection(bd.bd())
        } catch {
            print(error)
        }
    }
    
    /*
     *  GENERALES
     **/
    
    func createTables() {
        let tableReport = bd.TABLE_REPORT.create { (table) in
            table.column(bd.TABLE_REPORT_ID, primaryKey: true)
            table.column(bd.TABLE_REPORT_CUSTOMER)
            table.column(bd.TABLE_REPORT_PASSENGERS)
            table.column(bd.TABLE_REPORT_PASSENGERS_PHOTO)
            table.column(bd.TABLE_REPORT_AIRCRAFT)
            table.column(bd.TABLE_REPORT_CAPITAN)
            table.column(bd.TABLE_REPORT_COPILOT)
            table.column(bd.TABLE_REPORT_DATE)
            table.column(bd.TABLE_REPORT_ROUTE)
            table.column(bd.TABLE_REPORT_GPS_FLIGHT_TIME)
            table.column(bd.TABLE_REPORT_HOUR_INITIAL)
            table.column(bd.TABLE_REPORT_HOUR_FINAL)
            table.column(bd.TABLE_REPORT_LONG_TIME)
            table.column(bd.TABLE_REPORT_REMARKS)
            table.column(bd.TABLE_REPORT_SEND)
            table.column(bd.TABLE_REPORT_ENGINE_1)
            table.column(bd.TABLE_REPORT_ENGINE_2)
            table.column(bd.TABLE_REPORT_COMBO_ENGINE_1)
            table.column(bd.TABLE_REPORT_COMBO_ENGINE_2)
            table.column(bd.TABLE_REPORT_COCKPIT)
        }
        
        let tableExpenses = bd.TABLE_EXPENSES.create { (table) in
            table.column(bd.TABLE_EXPENSES_ID, primaryKey: true)
            table.column(bd.TABLE_EXPENSES_ID_REPORT)
            table.column(bd.TABLE_EXPENSES_TOTAL)
            table.column(bd.TABLE_EXPENSES_CURRENCY)
            table.column(bd.TABLE_EXPENSES_DESCRIPTION)
            table.column(bd.TABLE_EXPENSES_PHOTO)
            table.foreignKey(bd.TABLE_EXPENSES_ID_REPORT, references: bd.TABLE_REPORT, bd.TABLE_REPORT_ID)
        }
        
        let tableAircraft = bd.TABLE_AIRCRAFT_REPORT.create { (table) in
            table.column(bd.TABLE_AIRCRAFT_REPORT_ID, primaryKey: true)
            table.column(bd.TABLE_AIRCRAFT_REPORT_ID_REPORT)
            table.column(bd.TABLE_AIRCRAFT_REPORT_DESCRIPTION)
            table.column(bd.TABLE_AIRCRAFT_REPORT_PHOTO)
            table.foreignKey(bd.TABLE_AIRCRAFT_REPORT_ID_REPORT, references: bd.TABLE_REPORT, bd.TABLE_REPORT_ID)
        }
        
        let tableListCustomer   = createTableList(tabla: bd.TABLE_LIST_CUSTOMER)
        let tableListAircraft   = createTableList(tabla: bd.TABLE_LIST_AIRCRAFT)
        let tableListCapitan    = createTableList(tabla: bd.TABLE_LIST_CAPITAN)
        let tableListCopilot    = createTableList(tabla: bd.TABLE_LIST_COPILOT)
        let tableListCurrency   = createTableList(tabla: bd.TABLE_LIST_CURRENCY)
        let tableListEngine     = createTableList(tabla: bd.TABLE_LIST_ENGINE)
        
        self.execute(sql: tableReport)
        self.execute(sql: tableExpenses)
        self.execute(sql: tableAircraft)
        self.execute(sql: tableListCustomer)
        self.execute(sql: tableListAircraft)
        self.execute(sql: tableListCapitan)
        self.execute(sql: tableListCopilot)
        self.execute(sql: tableListCurrency)
        self.execute(sql: tableListEngine)
    }
    
    func createTableList(tabla: Table) -> String {
        return tabla.create { (table) in
            table.column(bd.TABLE_LIST_ID, primaryKey: true)
            table.column(bd.TABLE_LIST_DESCRIPTION)
        }
    }
    
    func dropTables() {
        let tableReport         = bd.TABLE_REPORT.drop(ifExists: true)
        let tableExpenses       = bd.TABLE_EXPENSES.drop(ifExists: true)
        let tableAircraft       = bd.TABLE_AIRCRAFT_REPORT.drop(ifExists: true)
        let tableListCustomer   = bd.TABLE_LIST_CUSTOMER.drop(ifExists: true)
        let tableListAircraft   = bd.TABLE_LIST_AIRCRAFT.drop(ifExists: true)
        let tableListCapitan    = bd.TABLE_LIST_CAPITAN.drop(ifExists: true)
        let tableListCopilot    = bd.TABLE_LIST_COPILOT.drop(ifExists: true)
        let tableListCurrency   = bd.TABLE_LIST_CURRENCY.drop(ifExists: true)
        let tableListEngine     = bd.TABLE_LIST_ENGINE.drop(ifExists: true)

        self.execute(sql: tableReport)
        self.execute(sql: tableExpenses)
        self.execute(sql: tableAircraft)
        self.execute(sql: tableListCustomer)
        self.execute(sql: tableListAircraft)
        self.execute(sql: tableListCapitan)
        self.execute(sql: tableListCopilot)
        self.execute(sql: tableListCurrency)
        self.execute(sql: tableListEngine)
    }
    
    func execute(sql: String) {
        do {
            try self.database.run(sql)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    func executeUpdate(sql: Update) {
        do {
            try self.database.run(sql)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    func executeInsert(sql: Insert) {
        do {
            try self.database.run(sql)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    func executeDelete(sql: Delete) {
        do {
            try self.database.run(sql)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    /*
     *  REPORT
     **/
    
    func reportTodos() -> [Report] {
        var list = [Report]()
        do {
            let listModel = try self.database.prepare(bd.TABLE_REPORT)
            for l in listModel {
                list.append( rowToReport(l: l) )
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func reportEnviados() -> [Report] {
        var list = [Report]()
        do {
            let listModel = try self.database.prepare( bd.TABLE_REPORT.where(bd.TABLE_REPORT_SEND == 1) )
            for l in listModel {
                list.append( rowToReport(l: l) )
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func reportById(id: Int) -> Report {
        var report = Report()
        do {
            let listModel = try self.database.prepare( bd.TABLE_REPORT.where(bd.TABLE_REPORT_ID == id) )
            for l in listModel {
                report = rowToReport(l: l)
            }
        } catch {
            print(error)
        }
        return report
    }
    
    func ultimoBorrador() -> Report {
        var report = Report()
        do {
            let listModel = try self.database.prepare( bd.TABLE_REPORT )
            for l in listModel {
                report = rowToReport(l: l)
            }
        } catch {
            print(error)
        }
        return report
    }
    
    func reportUpdate(report: Report, atributo: String) {
        
        let reportAux = self.bd.TABLE_REPORT.filter(bd.TABLE_REPORT_ID == report.id)
        var sql: Update
        
        switch atributo {
            case "remarks":
                sql = reportAux.update(bd.TABLE_REPORT_REMARKS <- report.remarks)
                break
            case "passangers":
                sql = reportAux.update(bd.TABLE_REPORT_PASSENGERS <- report.passengers )
                break
            case "customer":
                sql = reportAux.update(bd.TABLE_REPORT_CUSTOMER <- report.customer )
                break
            case "aircraft":
                sql = reportAux.update(bd.TABLE_REPORT_AIRCRAFT <- report.aircraft )
                break
            case "capitan":
                sql = reportAux.update(bd.TABLE_REPORT_CAPITAN <- report.capitan )
                break
            case "copilot":
                sql = reportAux.update(bd.TABLE_REPORT_COPILOT <- report.copilot )
                break
            case "route":
                sql = reportAux.update(bd.TABLE_REPORT_ROUTE <- report.route )
                break
            case "hour_initial":
                sql = reportAux.update(bd.TABLE_REPORT_HOUR_INITIAL <- report.hour_initial )
                break
            case "hour_final":
                sql = reportAux.update(bd.TABLE_REPORT_HOUR_FINAL <- report.hour_final )
                break
            case "gps_flight_time":
                sql = reportAux.update(bd.TABLE_REPORT_GPS_FLIGHT_TIME <- report.gps_flight_time )
                break
            case "log_time":
                sql = reportAux.update(bd.TABLE_REPORT_LONG_TIME <- report.long_time )
                break
            case "send":
                sql = reportAux.update(bd.TABLE_REPORT_SEND <- bd.intergetConvert(b: report.send) )
                break
            case "passengers_photo":
                sql = reportAux.update(bd.TABLE_REPORT_PASSENGERS_PHOTO <- report.passengers_photo )
                break
            case "date":
                sql = reportAux.update(bd.TABLE_REPORT_DATE <- report.date )
                break
            case "engine1":
                sql = reportAux.update(bd.TABLE_REPORT_ENGINE_1 <- report.engine1 )
                break
            case "engine2":
                sql = reportAux.update(bd.TABLE_REPORT_ENGINE_2 <- report.engine2 )
                break
            case "combo_engine1":
                sql = reportAux.update(bd.TABLE_REPORT_COMBO_ENGINE_1 <- report.comboEngine1 )
                break
            case "combo_engine2":
                sql = reportAux.update(bd.TABLE_REPORT_COMBO_ENGINE_2 <- report.comboEngine2 )
                break;
            case "cockpit":
                sql = reportAux.update(bd.TABLE_REPORT_COCKPIT <- bd.intergetConvert(b: report.cockpit) )
                break
            default:
            sql = reportAux.update(bd.TABLE_REPORT_REMARKS <- report.remarks)
        }
        executeUpdate(sql: sql)
    }
    
    func reportInsert(report: Report) {
        let sql = self.bd.TABLE_REPORT.insert(
            bd.TABLE_REPORT_REMARKS <- report.remarks,
            bd.TABLE_REPORT_PASSENGERS <- report.passengers,
            bd.TABLE_REPORT_CUSTOMER <- report.customer,
            bd.TABLE_REPORT_AIRCRAFT <- report.aircraft,
            bd.TABLE_REPORT_CAPITAN <- report.capitan,
            bd.TABLE_REPORT_COPILOT <- report.copilot,
            bd.TABLE_REPORT_ROUTE <- report.route,
            bd.TABLE_REPORT_HOUR_INITIAL <- report.hour_initial,
            bd.TABLE_REPORT_HOUR_FINAL <- report.hour_final,
            bd.TABLE_REPORT_GPS_FLIGHT_TIME <- report.gps_flight_time,
            bd.TABLE_REPORT_LONG_TIME <- report.long_time,
            bd.TABLE_REPORT_SEND <- bd.intergetConvert(b: report.send) ,
            bd.TABLE_REPORT_PASSENGERS_PHOTO <- report.passengers_photo,
            bd.TABLE_REPORT_DATE <- report.date,
            bd.TABLE_REPORT_ENGINE_1 <- report.engine1,
            bd.TABLE_REPORT_ENGINE_2 <- report.engine2,
            bd.TABLE_REPORT_COMBO_ENGINE_1 <- report.comboEngine1,
            bd.TABLE_REPORT_COMBO_ENGINE_2 <- report.comboEngine2,
            bd.TABLE_REPORT_COCKPIT <- bd.intergetConvert(b: report.cockpit)
        )
        executeInsert(sql: sql)
    }
    
    func reportDelete(report: Report) {
        let r = self.bd.TABLE_REPORT.filter(bd.TABLE_REPORT_ID == report.id)
        let sql = r.delete()
        executeDelete(sql: sql)
    }
    
    func rowToReport(l: Row) -> Report {
        return Report(
            id: l[bd.TABLE_REPORT_ID],
            customer: l[bd.TABLE_REPORT_CUSTOMER],
            passengers: l[bd.TABLE_REPORT_PASSENGERS],
            passengers_photo: l[bd.TABLE_REPORT_PASSENGERS_PHOTO],
            aircraft: l[bd.TABLE_REPORT_AIRCRAFT],
            capitan: l[bd.TABLE_REPORT_CAPITAN],
            copilot: l[bd.TABLE_REPORT_COPILOT],
            date: l[bd.TABLE_REPORT_DATE],
            route: l[bd.TABLE_REPORT_ROUTE],
            gps_flight_time: l[bd.TABLE_REPORT_GPS_FLIGHT_TIME],
            hour_initial: l[bd.TABLE_REPORT_HOUR_INITIAL],
            hour_final: l[bd.TABLE_REPORT_HOUR_FINAL],
            long_time: l[bd.TABLE_REPORT_LONG_TIME],
            remarks: l[bd.TABLE_REPORT_REMARKS],
            send: bd.booleanConvert(b: l[bd.TABLE_REPORT_SEND] ),
            engine1: l[bd.TABLE_REPORT_ENGINE_1],
            engine2: l[bd.TABLE_REPORT_ENGINE_2],
            comboEngine1: l[bd.TABLE_REPORT_COMBO_ENGINE_1],
            comboEngine2: l[bd.TABLE_REPORT_COMBO_ENGINE_2],
            cockpit: bd.booleanConvert(b: l[bd.TABLE_REPORT_COCKPIT]))
    }
    
    /*
     *  EXPENSE
     **/
    
    func expensestTodos(id_report: Int) -> [Expenses] {
        var list = [Expenses]()
        do {
            let listModel = try self.database.prepare( bd.TABLE_EXPENSES.where(bd.TABLE_EXPENSES_ID_REPORT == id_report) )
            for l in listModel {
                list.append( rowToExpense(l: l) )
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func expensesById(id: Int) -> Expenses {
        var list = Expenses()
        do {
            let listModel = try self.database.prepare( bd.TABLE_EXPENSES.where(bd.TABLE_EXPENSES_ID == id) )
            for l in listModel {
                list = rowToExpense(l: l)
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func expensesUpdate(expense: Expenses) {
        let update = self.bd.TABLE_EXPENSES.filter(bd.TABLE_EXPENSES_ID == expense.id)
        let sql = update.update(bd.TABLE_EXPENSES_TOTAL <- expense.total,
                                bd.TABLE_EXPENSES_CURRENCY <- expense.currency,
                                bd.TABLE_EXPENSES_DESCRIPTION <- expense.description,
                                bd.TABLE_EXPENSES_PHOTO <- expense.photo)
        executeUpdate(sql: sql)
    }
    
    func expensesInsert(expense: Expenses) {
        let sql = self.bd.TABLE_EXPENSES.insert(
            bd.TABLE_EXPENSES_TOTAL <- expense.total,
            bd.TABLE_EXPENSES_CURRENCY <- expense.currency,
            bd.TABLE_EXPENSES_DESCRIPTION <- expense.description,
            bd.TABLE_EXPENSES_PHOTO <- expense.photo)
        executeInsert(sql: sql)
    }
    
    func expensesDelete(expense: Expenses) {
        let e = self.bd.TABLE_EXPENSES.filter(bd.TABLE_EXPENSES_ID == expense.id)
        let sql = e.delete()
        executeDelete(sql: sql)
    }
    
    func rowToExpense(l: Row) -> Expenses {
        return Expenses(
                id: l[bd.TABLE_EXPENSES_ID],
                report: reportById(id: l[bd.TABLE_EXPENSES_ID_REPORT] ),
                total: l[bd.TABLE_EXPENSES_TOTAL],
                currency: l[bd.TABLE_EXPENSES_CURRENCY],
                description: l[bd.TABLE_EXPENSES_DESCRIPTION],
                photo: l[bd.TABLE_EXPENSES_PHOTO])
    }
    
    /*
     *  AIRCRAFT
     **/
    
    func aircraftTodos(id_report: Int) -> [AircraftReport] {
        var list = [AircraftReport]()
        do {
            let listModel = try self.database.prepare( bd.TABLE_AIRCRAFT_REPORT.where(bd.TABLE_AIRCRAFT_REPORT_ID_REPORT == id_report) )
            for l in listModel {
                list.append( rowToAircraft(l: l) )
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func aircraftReportById(id: Int) -> AircraftReport {
        var list = AircraftReport()
        do {
            let listModel = try self.database.prepare( bd.TABLE_AIRCRAFT_REPORT.where(bd.TABLE_AIRCRAFT_REPORT_ID == id) )
            for l in listModel {
                list = rowToAircraft(l: l)
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func aircraftUpdate(aircraft: AircraftReport) {
        let update = self.bd.TABLE_AIRCRAFT_REPORT.filter(bd.TABLE_AIRCRAFT_REPORT_ID == aircraft.id)
        let sql = update.update(bd.TABLE_AIRCRAFT_REPORT_DESCRIPTION <- aircraft.description,
                                bd.TABLE_AIRCRAFT_REPORT_PHOTO <- aircraft.photo)
        executeUpdate(sql: sql)
    }
    
    func aircraftInsert(aircraft: AircraftReport) {
        let sql = self.bd.TABLE_AIRCRAFT_REPORT.insert(
            bd.TABLE_AIRCRAFT_REPORT_DESCRIPTION <- aircraft.description,
            bd.TABLE_AIRCRAFT_REPORT_PHOTO <- aircraft.photo)
        executeInsert(sql: sql)
    }
    
    func aircraftDelete(aircraft: AircraftReport) {
        let e = self.bd.TABLE_AIRCRAFT_REPORT.filter(bd.TABLE_AIRCRAFT_REPORT_ID == aircraft.id)
        let sql = e.delete()
        executeDelete(sql: sql)
    }
    
    func rowToAircraft(l: Row) -> AircraftReport {
        return AircraftReport(
            id: l[bd.TABLE_AIRCRAFT_REPORT_ID],
            report: reportById(id: l[bd.TABLE_AIRCRAFT_REPORT_ID_REPORT] ),
            description: l[bd.TABLE_AIRCRAFT_REPORT_DESCRIPTION],
            photo: l[bd.TABLE_AIRCRAFT_REPORT_PHOTO])
    }
    
    /*
     *  LISTAS
     **/
    
    func actualizarListado(value: String, id: Int, table: Table) {
        let update = table.filter(bd.TABLE_LIST_ID == id)
        let sql = update.update(bd.TABLE_LIST_DESCRIPTION <- value)
        executeUpdate(sql: sql)
    }
    
    func borrarListado(id: Int, table: Table) {
        let e = table.filter(bd.TABLE_LIST_ID == id)
        let sql = e.delete()
        executeDelete(sql: sql)
    }
    
    func obtenerPosInListado(value: String, listado: Table) -> Int {
        var i: Int = 0
        do {
            let listModel = try self.database.prepare( listado )
            for l in listModel {
                if (l[bd.TABLE_LIST_DESCRIPTION == value]) {
                    i = l[bd.TABLE_LIST_ID]
                    break
                }
            }
        } catch {
            print(error)
        }
        return i
    }
    
    func insertarLista(table:Table, c: String) {
        let sql = table.insert(
            bd.TABLE_LIST_DESCRIPTION <- c)
        executeInsert(sql: sql)
    }
    
    func obtenerListado(table: Table) -> [String] {
        var list = [String]()
        do {
            let listModel = try self.database.prepare( table )
            for l in listModel {
                list.append( l[bd.TABLE_LIST_DESCRIPTION] )
            }
        } catch {
            print(error)
        }
        return list
    }
    
    func rowToList(l: Row) -> Lista {
        return Lista(
            id: l[bd.TABLE_LIST_ID],
            description: l[bd.TABLE_LIST_DESCRIPTION])
    }
    
    func listaCustomer() -> [String] {
        return sortAlphabetic(list: obtenerListado(table: bd.TABLE_LIST_CUSTOMER) )
    }
    
    func listaCustomerInsert(c: String) {
        insertarLista(table: bd.TABLE_LIST_CUSTOMER, c: c)
    }
    
    func listaAircraft() -> [String] {
        return sortAlphabetic(list: obtenerListado(table: bd.TABLE_LIST_AIRCRAFT) )
    }
    
    func listaAircraftInsert(c: String) {
        insertarLista(table: bd.TABLE_LIST_AIRCRAFT, c: c)
    }
   
    func listaCapitan() -> [String] {
        if (obtenerListado(table: bd.TABLE_LIST_CAPITAN).isEmpty == true) {
            cargarListados()
        }
        return sortAlphabetic(list: obtenerListado(table: bd.TABLE_LIST_CAPITAN) )
    }
    
    func listaCapitanInsert(c: String) {
        insertarLista(table: bd.TABLE_LIST_CAPITAN, c: c)
    }
    
    func listaCurrency() -> [String] {
        return obtenerListado(table: bd.TABLE_LIST_CURRENCY)
    }
    
    func listaCurrencyInsert(c: String) {
        insertarLista(table: bd.TABLE_LIST_CURRENCY, c: c)
    }
    
    func listaEngine() -> [String] {
        return obtenerListado(table: bd.TABLE_LIST_ENGINE)
    }
    
    func listaEngineInsert(c: String) {
        insertarLista(table: bd.TABLE_LIST_ENGINE, c: c)
    }
    
    func sortAlphabetic(list: [String]) -> [String] {
        return list.sorted(by: < )
    }
    
    func listPosition(list: [String], name: String) -> Int {
        var i = 0
        if (name.isEmpty == true) { return i }
    
        for l in list {
            if (l != name) {
                i = i + 1
            } else {
                break;
            }
        }
        return i
    }
    
    func cargarListados() {
        /**
         * CURRENCY
         */
        listaCurrencyInsert(c: "BS");
        listaCurrencyInsert(c: "$");
    
        /**
         * ENGINE
         */
        listaEngineInsert(c: "QUARTS");
        listaEngineInsert(c: "LITERS");
    
        /**
         * CAPITAN AND COPILOT
         */
        listaCapitanInsert(c: "Juan Ramirez".uppercased());
        listaCapitanInsert(c: "Eduardo Almanzor".uppercased());
        listaCapitanInsert(c: "Armando Travieso".uppercased());
        listaCapitanInsert(c: "Fernando Figueredo".uppercased());
        listaCapitanInsert(c: "Gustavo Reyes".uppercased());
        listaCapitanInsert(c: "Henrique Pocaterra".uppercased());
        listaCapitanInsert(c: "Juan Carlos Belandria".uppercased());
        listaCapitanInsert(c: "Luis Branger".uppercased());
        listaCapitanInsert(c: "Gerxi Tovar".uppercased());
        listaCapitanInsert(c: "Emely Fernandez".uppercased());
        listaCapitanInsert(c: "Esthefania Rojas".uppercased());
    
        /**
         *   CUSTOMER
         **/
        listaCustomerInsert(c: "AGUSTO MERINO");
        listaCustomerInsert(c: "ALBERTO DIAZ");
        listaCustomerInsert(c: "ALBERTO FINOL");
        listaCustomerInsert(c: "ALEJANDRO GARCIA");
        listaCustomerInsert(c: "ALEJANDRO PROSPERI");
        listaCustomerInsert(c: "ALEJANDRO REBOLLEDO");
        listaCustomerInsert(c: "ALEJANDRO SILVA");
        listaCustomerInsert(c: "ALESSANDRO BAZZONI");
        listaCustomerInsert(c: "ALEXIS NAVARRETE");
        listaCustomerInsert(c: "ALIETTE SALAZAR");
        listaCustomerInsert(c: "ALVARO ROTONDARO");
        listaCustomerInsert(c: "ANIBAL SOUKI");
        listaCustomerInsert(c: "ANTONIO MORAZZANI");
        listaCustomerInsert(c: "ARMANDO BRIQUET");
        listaCustomerInsert(c: "BERNARDO PEREZ BEICOS");
        listaCustomerInsert(c: "BRILAND");
        listaCustomerInsert(c: "CARLOS BENSHIMOL");
        listaCustomerInsert(c: "CARLOS MARTINS");
        listaCustomerInsert(c: "CEO");
        listaCustomerInsert(c: "COMMAN AIR.C.A");
        listaCustomerInsert(c: "CPVEN");
        listaCustomerInsert(c: "DANIEL DE GRAZIA");
        listaCustomerInsert(c: "DANIEL FINOL");
        listaCustomerInsert(c: "DAVID LOPEZ");
        listaCustomerInsert(c: "DAVID RODRIGUEZ");
        listaCustomerInsert(c: "DIEGO DIAZ");
        listaCustomerInsert(c: "EDUARDO ORTIZ");
        listaCustomerInsert(c: "EDUARDO PANTIN");
        listaCustomerInsert(c: "EDUARDO WALLIS");
        listaCustomerInsert(c: "ENRIQUE CASTRO");
        listaCustomerInsert(c: "ENRIQUE CONDE");
        listaCustomerInsert(c: "ERNESTO BRANGER");
        listaCustomerInsert(c: "EUDES RODRIGUEZ");
        listaCustomerInsert(c: "FEDERICO SHEMEL");
        listaCustomerInsert(c: "FERNANDO NAVARRO");
        listaCustomerInsert(c: "FRANCISCO SACCINI");
        listaCustomerInsert(c: "HECTOR VALECILLO");
        listaCustomerInsert(c: "HENRIQUE POCATERRA");
        listaCustomerInsert(c: "HUMBERTO DIAZ");
        listaCustomerInsert(c: "JAHROLD MAIZO");
        listaCustomerInsert(c: "JAVIER SANGUINO");
        listaCustomerInsert(c: "GRUPO ATAHUALPA");
        listaCustomerInsert(c: "JOBEL HERRERA");
        listaCustomerInsert(c: "JOHAN HOFFMANN");
        listaCustomerInsert(c: "JOHAN SCHNELL");
        listaCustomerInsert(c: "JORGE CAMPINS");
        listaCustomerInsert(c: "JORGE PINEDA");
        listaCustomerInsert(c: "JORGE PLAZA");
        listaCustomerInsert(c: "JOSE BORTONES");
        listaCustomerInsert(c: "JOSE LUIS MERINO");
        listaCustomerInsert(c: "JOSE RAFAEL PARRA");
        listaCustomerInsert(c: "JUAN CARLOS BRIQUET");
        listaCustomerInsert(c: "JUAN CHOURIO");
        listaCustomerInsert(c: "JUAN PAREDES");
        listaCustomerInsert(c: "JUAN PONCE");
        listaCustomerInsert(c: "LEONARDO BARRIOS");
        listaCustomerInsert(c: "LERYS MICCIOLO");
        listaCustomerInsert(c: "LOWIS MICIOLO");
        listaCustomerInsert(c: "MANUEL ARAUJO");
        listaCustomerInsert(c: "MARIA ELENA VALERO");
        listaCustomerInsert(c: "MARIA GABRIELA SENIOR");
        listaCustomerInsert(c: "MARIO HERRERA");
        listaCustomerInsert(c: "MAXIMO SACCINI");
        listaCustomerInsert(c: "MICKHAIL ALVAREZ");
        listaCustomerInsert(c: "MILOS MANAGEMENT");
        listaCustomerInsert(c: "OIL CONSULTING ENTERPRISE, INC");
        listaCustomerInsert(c: "PABLO TRONCONE");
        listaCustomerInsert(c: "ROBERTO CAVALLIN");
        listaCustomerInsert(c: "PEPE LEGGIO");
        listaCustomerInsert(c: "PIER ");
        listaCustomerInsert(c: "PROAGRO, C.A.");
        listaCustomerInsert(c: "SAID CAMACHO");
        listaCustomerInsert(c: "RAFAEL ANGULO");
        listaCustomerInsert(c: "RAFAEL GUZMAN");
        listaCustomerInsert(c: "ROMULO LANDER");
        listaCustomerInsert(c: "ROELVIS RESTREPO");
        listaCustomerInsert(c: "ROMINA PETROCELLI");
        listaCustomerInsert(c: "SAMIR BAZZI");
        listaCustomerInsert(c: "SAMUEL MERIDA");
        listaCustomerInsert(c: "DUBRAZKA DAZA");
        listaCustomerInsert(c: "TOMAS TRONCONE");
        listaCustomerInsert(c: "TULIO HINESTROSA");
        listaCustomerInsert(c: "UNIKA INTERNATIONAL INVESTMENT");
        listaCustomerInsert(c: "RICARDO MELENDEZ");
        listaCustomerInsert(c: "VESERCA");
        listaCustomerInsert(c: "VHICOA");
        listaCustomerInsert(c: "GENERAL ZAMBRANO");
        listaCustomerInsert(c: "VICTOR MARTINS");
        listaCustomerInsert(c: "WILLIAM PACANINS");
        listaCustomerInsert(c: "CARMELO DE GRAZIA");
        listaCustomerInsert(c: "ARMANDO TRAVIESO");
        listaCustomerInsert(c: "JORGE VALDEZ");
        listaCustomerInsert(c: "JOANNA GLOD");
        listaCustomerInsert(c: "JOAQUIN SARRIA");
        listaCustomerInsert(c: "DANIEL DURAN");
        listaCustomerInsert(c: "JUAN CARLOS ANGLADE");
        listaCustomerInsert(c: "ARGENIS AZUAJE");
        listaCustomerInsert(c: "JOSE LARA");
        listaCustomerInsert(c: "RONALD MAGALLANES");
        listaCustomerInsert(c: "EDUARDO ALMANSOR");
        listaCustomerInsert(c: "MARITIME CONTRACTORS");
        listaCustomerInsert(c: "JEANNOT DUCOURNAU");
        listaCustomerInsert(c: "LUIS RODRIGUEZ");
        listaCustomerInsert(c: "JUAN CARLOS BELANDRIA");
        listaCustomerInsert(c: "ALEXANDER LIRA");
        listaCustomerInsert(c: "XIGA TOURS 1069, C.A.");
        listaCustomerInsert(c: "MODABALY C.A.");
        listaCustomerInsert(c: "FABRITZIO DELLA POLLA");
        listaCustomerInsert(c: "ALEJANDRO QUINTAVALLE");
    
        /**
         *   AIRCRAFT
         **/
        listaAircraftInsert(c: "YV3346");
        listaAircraftInsert(c: "YV2949");
        listaAircraftInsert(c: "YV2951");
        listaAircraftInsert(c: "YV3310");
        listaAircraftInsert(c: "YV2853");
        listaAircraftInsert(c: "YV3048");
        listaAircraftInsert(c: "YV1039");
    }
    
}
