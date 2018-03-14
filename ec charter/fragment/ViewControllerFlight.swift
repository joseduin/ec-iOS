//
//  ViewControllerFlight.swift
//  ec charter
//
//  Created by Jose Duin on 2/13/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerFlight: UIViewController, UITextFieldDelegate, writeValueBackDelegate {

    @IBOutlet weak var route: UITextField!
    @IBOutlet weak var gps_flitgh_time: UITextField!
    @IBOutlet weak var final_hour: UITextField!
    @IBOutlet weak var initial_hour: UITextField!
    @IBOutlet weak var log_time: UITextField!
    @IBOutlet weak var engenie_2: UITextField!
    @IBOutlet weak var engenie_1: UITextField!
    @IBOutlet weak var combo_engenie_2: UIButton!
    @IBOutlet weak var combo_engenie_1: UIButton!
    
    let bd: BaseDatos = BaseDatos()
    var reportPassF: Report = Report()
    var buscarCombo: Int = 0
    var buscarComboEngenie: Int = 0
    var engenies:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gps_flitgh_time.delegate = self
        self.final_hour.delegate = self
        self.initial_hour.delegate = self
        self.engenie_1.delegate = self
        self.engenie_2.delegate = self
        self.route.delegate = self
        
        self.engenies = bd.listaEngine()
        loadReport()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadReport() {
        self.route.text = reportPassF.route
        if (reportPassF.gps_flight_time != 0.0) {
            self.gps_flitgh_time.text = String(format:"%.2f", reportPassF.gps_flight_time)
        }
        if (reportPassF.hour_final != 0.0) {
            self.final_hour.text = String(format:"%.2f", reportPassF.hour_final)
        }
        if (reportPassF.hour_initial != 0.0) {
            self.initial_hour.text = String(format:"%.2f", reportPassF.hour_initial)
        }
        self.log_time.text = String(format:"%.2f", reportPassF.long_time)
        if (reportPassF.engine1 != 0.0) {
            self.engenie_1.text = String(format:"%.2f", reportPassF.engine1)
        }
        self.combo_engenie_1.setTitle(reportPassF.comboEngine1.isEmpty ? self.engenies.last : self.reportPassF.comboEngine1, for: .normal)
        if (reportPassF.engine2 != 0.0) {
            self.engenie_2.text = String(format:"%.2f", reportPassF.engine2)
        }
        self.combo_engenie_2.setTitle(reportPassF.comboEngine2.isEmpty ? self.engenies.last : self.reportPassF.comboEngine2, for: .normal)
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        
        if textField == self.gps_flitgh_time  ||
            textField == self.final_hour  ||
            textField == self.initial_hour ||
            textField == self.engenie_1 ||
            textField == self.engenie_2 {
            if textField.text != "" || string != "" {
                let res = (textField.text ?? "") + string
                return Double(res) != nil
            }
        }
        return true
    }
    
    // cuando se aprieta fuera del campo de texto
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // boton return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // next buttons
        /*
        if textField == self.route {
            self.gps_flitgh_time.becomeFirstResponder()
        } else if textField == self.gps_flitgh_time {
            self.initial_hour.becomeFirstResponder()
        } else if textField == self.initial_hour {
            self.final_hour.becomeFirstResponder()
        } else if textField == self.final_hour {
            self.engenie_1.becomeFirstResponder()
        } else if textField == self.engenie_1 {
            self.engenie_2.becomeFirstResponder()
        }
        */
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var value = textField.text!.isEmpty ? "" : textField.text!
        
        if textField == self.route {
            self.reportPassF.route = value
            self.bd.reportUpdate(report: self.reportPassF, atributo: "route")
        }
        
        value = textField.text!.isEmpty ? "0.0" : textField.text!
        if textField == self.gps_flitgh_time  {
            self.reportPassF.gps_flight_time = Double(value)!
            self.bd.reportUpdate(report: self.reportPassF, atributo: "gps_flight_time")
        } else if textField == self.final_hour  {
            self.reportPassF.hour_final = Double(value)!
            self.bd.reportUpdate(report: self.reportPassF, atributo: "hour_final")
            calcularLog()
        } else if textField == self.initial_hour {
            self.reportPassF.hour_initial = Double(value)!
            self.bd.reportUpdate(report: self.reportPassF, atributo: "hour_initial")
            calcularLog()
        } else if textField == self.engenie_1 {
            self.reportPassF.engine1 = Double(value)!
            self.bd.reportUpdate(report: self.reportPassF, atributo: "engine1")
        } else if textField == self.engenie_2 {
            self.reportPassF.engine2 = Double(value)!
            self.bd.reportUpdate(report: self.reportPassF, atributo: "engine2")
        }
    }
    
    func calcularLog() {
        if !(self.initial_hour.text?.isEmpty)! &&
            !(self.final_hour.text?.isEmpty)! {

            let initial = Double(self.initial_hour.text!)!
            let final = Double(self.final_hour.text!)!
            
            if final > initial ||
                final == initial {
                self.log_time.text = String(format:"%.2f", final - initial)
                self.reportPassF.long_time = (final - initial)
                self.bd.reportUpdate(report: self.reportPassF, atributo: "log_time")
            }
        }
    }
    
    @IBAction func btn_engine_1(_ sender: UIButton) {
        self.buscarCombo = 5
        self.buscarComboEngenie = 1
        self.performSegue(withIdentifier: "reportToCombo2", sender: self)
    }
    
    @IBAction func btn_engine_2(_ sender: UIButton) {
        self.buscarCombo = 5
        self.buscarComboEngenie = 2
        self.performSegue(withIdentifier: "reportToCombo2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportToCombo2" {
            
            if let viewController = segue.destination as? ReportCombo {
                viewController.buscar = self.buscarCombo
                viewController.delegate = self
            }
        }
    }
    
    func writeValueBack(value: String) {
        if self.buscarCombo == 5 {
            if self.buscarComboEngenie == 1 {
                self.combo_engenie_1.setTitle(value, for: .normal)
                self.reportPassF.comboEngine1 = value
                self.bd.reportUpdate(report: self.reportPassF, atributo: "combo_engine1")
            } else {
                self.combo_engenie_2.setTitle(value, for: .normal)
                self.reportPassF.comboEngine2 = value
                self.bd.reportUpdate(report: self.reportPassF, atributo: "combo_engine2")
            }
        }
    }
    
}
