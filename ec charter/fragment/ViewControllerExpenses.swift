//
//  ViewControllerExpenses.swift
//  ec charter
//
//  Created by Jose Duin on 3/2/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerExpenses: UIViewController, UITableViewDelegate, UITableViewDataSource, writeValueBackDelegate {

    @IBOutlet weak var tabla: UITableView!
    
    var reportPassE: Report = Report()
    let bd: BaseDatos = BaseDatos()
    var listado:[Expenses] = [Expenses]()
    var expensePass:Expenses = Expenses()

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
        cell.photo.text = item.photo
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
