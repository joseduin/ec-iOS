//
//  ViewControllerHistory.swift
//  ec charter
//
//  Created by Jose Duin on 2/11/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // falta enlazar y delegates
    @IBOutlet weak var tabla: UITableView!
    
    let bd: BaseDatos = BaseDatos()
    let bdc: ConstantesBaseDatos = ConstantesBaseDatos()
    var listado:[Report] = [Report]()
    var reportPass: Report = Report()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History Report"

        self.listado = self.bd.reportTodos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listado.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardHistory") as! CardHistory
        let item = listado[indexPath.row]
        cell.customer.text = item.customer
        cell.aircraft.text = item.aircraft
        cell.capitan.text = item.capitan
        cell .copilot.text = item.copilot
        cell.date.text = item.date
        cell.draft.isHidden = item.send
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.listado[indexPath.row]

        self.reportPass = item
        self.performSegue(withIdentifier: "historyToReport", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let item = self.listado[indexPath.row]
            
            self.bd.borrarListado(id: item.id, table: bdc.TABLE_REPORT)
            self.listado = self.bd.reportTodos()
            
            DispatchQueue.main.async { self.tabla.reloadData() }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyToReport" {
            
            let tabBarC : UITabBarController = segue.destination as! UITabBarController
            
            let basic: ViewControllerBasic      = tabBarC.viewControllers![0] as! ViewControllerBasic
            let flight: ViewControllerFlight    = tabBarC.viewControllers![1] as! ViewControllerFlight
            let expense: ViewControllerExpenses = tabBarC.viewControllers![2] as! ViewControllerExpenses
            let report: ViewControllerReports   = tabBarC.viewControllers![3] as! ViewControllerReports
            let remarks: ViewControllerRemarks  = tabBarC.viewControllers![4] as! ViewControllerRemarks
            
            basic.reportPassB   = self.reportPass
            flight.reportPassF  = self.reportPass
            expense.reportPassE = self.reportPass
            report.reportPassRe = self.reportPass
            remarks.reportPassR = self.reportPass
        }
    }
    

}
