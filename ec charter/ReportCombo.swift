//
//  ReportCombo.swift
//  ec charter
//
//  Created by Jose Duin on 3/2/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift

class ReportCombo: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var btn_agregar: UIButton!
    
    let bd: BaseDatos = BaseDatos()
    var buscar: Int = 0
    var listado:[String] = [String]()
    var delegate: writeValueBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.buscar == 1 {
            self.title = "Customers"
            self.listado = self.bd.listaCustomer()
        } else if self.buscar == 2 {
            self.title = "Aircrafts"
            self.listado = self.bd.listaAircraft()
        } else if self.buscar == 3 {
            self.title = "Capitans"
            self.listado = self.bd.listaCapitan()
        } else if self.buscar == 4 {
            self.title = "Copilots"
            self.listado = self.bd.listaCapitan()
        } else if self.buscar == 5 {
            self.title = "Engine"
            self.listado = self.bd.listaEngine()
            self.btn_agregar.isHidden = true
        } else if self.buscar == 6 {
            self.title = "Currency"
            self.listado = self.bd.listaCurrency()
            self.btn_agregar.isHidden = true
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
        return listado.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportComboCell") as! ReportComboCell
        let item = listado[indexPath.row]
        cell.titulo.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valor = listado[indexPath.row]
        delegate?.writeValueBack(value: valor)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func agregar(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "ADD ITEM"
            tf.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        }
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let combo = alert.textFields?.first?.text
                else {return}
            if (!combo.isEmpty) {
                if self.buscar == 1 {
                    self.bd.listaCustomerInsert(c: combo)
                    self.listado = self.bd.listaCustomer()
                } else if self.buscar == 2 {
                    self.bd.listaAircraftInsert(c: combo)
                    self.listado = self.bd.listaAircraft()
                } else if self.buscar == 3 || self.buscar == 4 {
                    self.bd.listaCapitanInsert(c: combo)
                    self.listado = self.bd.listaCapitan()
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

}

