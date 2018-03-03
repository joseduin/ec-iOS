//
//  ViewControllerComboSetting.swift
//  ec charter
//
//  Created by Jose Duin on 2/22/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerComboSetting: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tabla: UITableView!

    let bd: BaseDatos = BaseDatos()
    var attribute: Int = 0
    var listado:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.attribute == 0 {
            self.title = "Customer"
            self.listado = self.bd.listaCustomer()
        } else if self.attribute == 1 {
            self.title = "Aircraft"
            self.listado = self.bd.listaAircraft()
        } else if self.attribute == 2 {
            self.title = "Capitan / Copilot"
            self.listado = self.bd.listaCapitan()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listado.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardSettingsCombo") as! CardSettingsCombo
        let item = listado[indexPath.row]
        cell.titulo.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valor = listado[indexPath.row]
        agregarEditarItem(value: valor, tipo: 1)
    }
    
    @IBAction func agregar_item(_ sender: UIButton) {
        agregarEditarItem(value: "", tipo: 0)
    }
    
    func agregarEditarItem(value: String, tipo: Int) {
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = value.isEmpty ? "ADD ITEM" : "EDIT ITEM"
            tf.value(forKey: value)
        }
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let combo = alert.textFields?.first?.text
                else {return}
            if (!combo.isEmpty) {
                
                if tipo == 0 {
                    self.agregarItem(value: combo)
                } else {
                    self.actualizarItem(value: combo)
                }
                DispatchQueue.main.async { self.tabla.reloadData() }
            } else {
                self.view.makeToast("Empty Field", duration: 3.0, position: .bottom)
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func actualizarItem(value: String) {
        
        //if self.attribute == 0 {
        //    self.bd.listaCustomerInsert(c: combo)
        //    self.listado = self.bd.listaCustomer()
        //} else if self.attribute == 1 {
        //    self.bd.listaAircraftInsert(c: combo)
        //    self.listado = self.bd.listaAircraft()
       // } else if self.attribute == 2 {
        //    self.bd.listaCapitanInsert(c: combo)
        //    self.listado = self.bd.listaCapitan()
       // }
    }
    
    func agregarItem(value: String) {
        if self.attribute == 0 {
            self.bd.listaCustomerInsert(c: value)
            self.listado = self.bd.listaCustomer()
        } else if self.attribute == 1 {
            self.bd.listaAircraftInsert(c: value)
            self.listado = self.bd.listaAircraft()
        } else if self.attribute == 2 {
            self.bd.listaCapitanInsert(c: value)
            self.listado = self.bd.listaCapitan()
        }
    }

}
