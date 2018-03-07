//
//  ViewControllerExpense.swift
//  ec charter
//
//  Created by Jose Duin on 3/6/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewControllerExpense: UIViewController, UITextFieldDelegate, writeValueBackDelegate {

    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var photo: UILabel!
    @IBOutlet weak var total_button: UIButton!
    
    var expensePass:Expenses = Expenses()
    let bd: BaseDatos = BaseDatos()
    var buscarCombo: Int = 0
    var guardar: Bool = true
    var delegate: writeValueBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Expense"

        self.descripcion.delegate = self
        self.total.delegate = self

        self.guardar = self.expensePass.id == 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btn_total(_ sender: UIButton) {
        self.buscarCombo = 6
        self.performSegue(withIdentifier: "reportToCombo3", sender: self)
    }
    @IBAction func selectPhoto(_ sender: UIButton) {
    }
    @IBAction func btn_agregar(_ sender: UIButton) {
        if ((self.descripcion.text?.isEmpty)! &&
            (self.total.text?.isEmpty)! &&
            (self.total_button.title(for: .normal)?.isEmpty)!) {
            
            self.view.makeToast("Empty Fields", duration: 3.0, position: .bottom)
            return
        }
        
        self.expensePass.description = self.descripcion.text!
        self.expensePass.total = Double(self.total.text!)!
        self.expensePass.currency = self.total_button.title(for: .normal)!
        // photo
        
        if (guardar) {
            self.bd.expensesInsert(expense: self.expensePass)
        } else {
            // actualizar
            self.bd.expensesUpdate(expense: self.expensePass)
        }
        delegate?.writeValueBack(value: "reload")
    }
    @IBAction func btn_cancelar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if (textField == self.total) {
            
        } else if (textField == self.descripcion) {
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportToCombo3" {
            
            if let viewController = segue.destination as? ReportCombo {
                viewController.buscar = self.buscarCombo
                viewController.delegate = self
            }
        }
    }
    
    func writeValueBack(value: String) {
        if self.buscarCombo == 6 {
            self.total_button.setTitle(value, for: .normal)
        }
    }
    

}
