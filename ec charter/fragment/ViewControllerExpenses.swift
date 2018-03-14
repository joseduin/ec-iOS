//
//  ViewControllerExpenses.swift
//  ec charter
//
//  Created by Jose Duin on 3/2/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerExpenses: UIViewController, UITableViewDelegate, UITableViewDataSource, writeValueBackDelegate, cellImagePreviewDelegate {

    @IBOutlet weak var tabla: UITableView!
    
    var reportPassE: Report = Report()
    let bd: BaseDatos = BaseDatos()
    var listado:[Expenses] = [Expenses]()
    var expensePass:Expenses = Expenses()
    var photoPathPass: String = ""
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        self.listado = self.bd.expensestTodos(id_report: self.reportPassE.id)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardExpenses") as! CardExpenses
        let item = listado[indexPath.row]
        cell.total.text = "\(String(format:"%.2f", item.total)) \(item.currency)"
        if item.photo.isEmpty {
            cell.photo.isHidden = true
            cell.photo_boton.isHidden = true
        } else {
            cell.photo.isHidden = false
            cell.photo_boton.isHidden = false
            
            cell.photo.text = item.photo
            cell.delegate = self
        }
        cell.descripcion.text = item.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.listado[indexPath.row]
        
        self.expensePass = item
        self.performSegue(withIdentifier: "expensesToExpense", sender: self)    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    } 
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let item = self.listado[indexPath.row]
            
            self.bd.expensesDelete(expense: item)
            self.listado = self.bd.expensestTodos(id_report: self.reportPassE.id)

            DispatchQueue.main.async { self.tabla.reloadData() }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = listado[indexPath.row]
        if item.photo.isEmpty {
            return 98
        } else {
            return 137
        }
    }
    
    func selectdCellImagenPreview(photo_path: String) {
        self.photoPathPass = photo_path
        self.performSegue(withIdentifier: "imagenPreview4", sender: self)
    }
    
    @IBAction func agregar(_ sender: UIButton) {
        self.expensePass = Expenses()
        self.performSegue(withIdentifier: "expensesToExpense", sender: self) 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expensesToExpense" {
            
            if let viewController = segue.destination as? ViewControllerExpense {
                self.expensePass.report = self.reportPassE
                viewController.expensePass = self.expensePass
                viewController.delegate = self
            }
        } else if segue.identifier == "imagenPreview4" {
            
            if let viewController = segue.destination as? ImagePreview {
                viewController.img = defaults.data(forKey: self.photoPathPass)!
            }
        }
    }
    
    func writeValueBack(value: String) {
        print(value)
        if (value == "reload") {
            self.listado = self.bd.expensestTodos(id_report: self.reportPassE.id)
            DispatchQueue.main.async { self.tabla.reloadData() }
        }
    }

}
