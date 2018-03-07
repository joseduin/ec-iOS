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
    let bdc: ConstantesBaseDatos = ConstantesBaseDatos()

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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        let valor = self.listado[indexPath.row]
        agregarEditarItem(value: valor, tipo: 1)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {

            let valor = self.listado[indexPath.row]
            if self.attribute == 0 {
                let id = self.bd.obtenerPosInListado(value: valor, listado: bdc.TABLE_LIST_CUSTOMER)
                self.bd.borrarListado(id: id, table: bdc.TABLE_LIST_CUSTOMER)
                self.listado = self.bd.listaCustomer()
                
            } else if self.attribute == 1 {
                let id = self.bd.obtenerPosInListado(value: valor, listado: bdc.TABLE_LIST_AIRCRAFT)
                self.bd.borrarListado(id: id, table: bdc.TABLE_LIST_AIRCRAFT)
                self.listado = self.bd.listaAircraft()
                
            } else if self.attribute == 2 {
                let id = self.bd.obtenerPosInListado(value: valor, listado: bdc.TABLE_LIST_CAPITAN)
                self.bd.borrarListado(id: id, table: bdc.TABLE_LIST_CAPITAN)
                self.listado = self.bd.listaCapitan()
                
            }
            
            DispatchQueue.main.async { self.tabla.reloadData() }
        }
    }
    
    @IBAction func agregar_item(_ sender: UIButton) {
        agregarEditarItem(value: "", tipo: 0)
    }
    
    func agregarEditarItem(value: String, tipo: Int) {
        let alert = UIAlertController(title: value.isEmpty ? "Add Item" : "Edit Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = value.isEmpty ? "ADD ITEM" : "EDIT ITEM"
            tf.text = value
            tf.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        }
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let combo = alert.textFields?.first?.text
                else {return}
            if (!combo.isEmpty) {

                if tipo == 0 {
                    self.agregarItem(value: combo)
                } else {
                    self.actualizarItem(value: combo, valorViejo: value)
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
    
    func actualizarItem(value: String, valorViejo: String) {
        if self.attribute == 0 {
            let id = self.bd.obtenerPosInListado(value: valorViejo, listado: bdc.TABLE_LIST_CUSTOMER)
            self.bd.actualizarListado(value: value, id: id, table: bdc.TABLE_LIST_CUSTOMER)
            self.listado = self.bd.listaCustomer()

        } else if self.attribute == 1 {
            let id = self.bd.obtenerPosInListado(value: valorViejo, listado: bdc.TABLE_LIST_AIRCRAFT)
            self.bd.actualizarListado(value: value, id: id, table: bdc.TABLE_LIST_AIRCRAFT)
            self.listado = self.bd.listaAircraft()

        } else if self.attribute == 2 {
            let id = self.bd.obtenerPosInListado(value: valorViejo, listado: bdc.TABLE_LIST_CAPITAN)
            self.bd.actualizarListado(value: value, id: id, table: bdc.TABLE_LIST_CAPITAN)
            self.listado = self.bd.listaCapitan()

        }
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
