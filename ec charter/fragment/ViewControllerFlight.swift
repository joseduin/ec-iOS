//
//  ViewControllerFlight.swift
//  ec charter
//
//  Created by Jose Duin on 2/13/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerFlight: UIViewController, UITextFieldDelegate, writeValueBackDelegate {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gps_flitgh_time.delegate = self
        self.final_hour.delegate = self
        self.initial_hour.delegate = self
        
        loadReport()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadReport() {
        self.gps_flitgh_time.text = String(format:"%.2f", reportPassF.gps_flight_time)
        self.final_hour.text = String(format:"%.2f", reportPassF.hour_final)
        self.initial_hour.text = String(format:"%.2f", reportPassF.hour_initial)
        self.log_time.text = String(format:"%.2f", reportPassF.long_time)
        self.engenie_1.text = String(format:"%.2f", reportPassF.engine1)
        self.combo_engenie_1.setTitle(reportPassF.comboEngine1, for: .normal)
        self.engenie_2.text = String(format:"%.2f", reportPassF.engine2)
        self.combo_engenie_2.setTitle(reportPassF.comboEngine2, for: .normal)
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        if textField == self.gps_flitgh_time {
            if textField.text != "" || string != "" {
                let res = (textField.text ?? "") + string
                return Double(res) != nil
            }
        } else if textField == self.final_hour {
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            
            let components = string.components(separatedBy: inverseSet)
            
            let filtered = components.joined(separator: "")
            
            if filtered == string {
                return true
            } else {
                if string == "." {
                    let countdots = textField.text!.components(separatedBy:".").count - 1
                    if countdots == 0 {
                        return true
                    }else{
                        if countdots > 0 && string == "." {
                            return false
                        } else {
                            return true
                        }
                    }
                }else{
                    return false
                }
            }
        } else if textField == self.initial_hour {
            let numberOnly = NSCharacterSet.init(charactersIn: "0123456789")
            let stringFromTextField = NSCharacterSet.init(charactersIn: string)
            let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
            
            return strValid
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
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // pendiente para calcular el logTime
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
                self.reportPassF.customer = value
                self.bd.reportUpdate(report: self.reportPassF, atributo: "combo_engine1")
            } else {
                self.combo_engenie_2.setTitle(value, for: .normal)
                self.reportPassF.customer = value
                self.bd.reportUpdate(report: self.reportPassF, atributo: "combo_engine2")
            }
        }
    }
    
}
