//
//  ViewControllerInicio.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerInicio: UIViewController {
    
    @IBOutlet weak var btn_report: UIButton!
    
    var reportPass: Report = Report()
    let variable: Variable = Variable()
    let bd: BaseDatos = BaseDatos()
    let hora: Hora = Hora()
    var reports:[Report] = [Report]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ec Charter"
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnReport()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        bd.createTables()
        let _ = bd.listaCapitan()
    }
    
    func btnReport() {
        self.reports = bd.reportTodos()
        var text: String = ""
        if (reports.isEmpty == true) {
            text = "NEW REPORT"
        } else {
            if (reports.last?.send == true) {
                text = "NEW REPORT"
            } else {
                text = "CONTINUE WITH REPORT"
            }
        }
        btn_report.setTitle(text, for: .normal)
    }
    
    @IBAction func goToReport(_ sender: UIButton) {
        self.reportPass = Report()
        if (reports.isEmpty == true) {
            let report: Report = Report()
            report.date = hora.today()
            report.send = false
            bd.reportInsert(report: report)
            
            self.reportPass = bd.ultimoBorrador()
        } else {
            if (reports.last?.send == true) {
                let report: Report = Report()
                report.date = hora.today()
                report.send = false
                bd.reportInsert(report: report)
                
                self.reportPass = bd.ultimoBorrador()
            }
        }
        self.performSegue(withIdentifier: "inicioToReport", sender: self)
    }
    
    @IBAction func goToHistory(_ sender: UIButton) {
        self.performSegue(withIdentifier: "inicioToHistory", sender: self)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inicioToReport" {
            
            if let viewController = segue.destination as? ViewControllerReport {
                viewController.reportPass = self.reportPass
            }
            
        }
    }

}
