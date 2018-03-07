//
//  ViewControllerReport.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewControllerReport: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var photo: UILabel!
    
    var reportPass:AircraftReport = AircraftReport()
    var delegate: writeValueBackDelegate?
    let bd: BaseDatos = BaseDatos()
    var guardar: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Aircraft Report"

        self.descripcion.delegate = self
     
        self.guardar = self.reportPass.id == 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectPhoto(_ sender: UIButton) {
    }
    @IBAction func btn_agregar(_ sender: UIButton) {
        if (self.descripcion.text?.isEmpty)! {
            self.view.makeToast("Empty Field", duration: 3.0, position: .bottom)
            return
        }
        
        self.reportPass.description = self.descripcion.text!
        // photo
        
        if (guardar) {
            self.bd.aircraftInsert(aircraft: self.reportPass)
        } else {
            // actualizar
            self.bd.aircraftUpdate(aircraft: self.reportPass)
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
        self.descripcion.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // guardar data
        print(textField.text as Any)
    }
    
    func imagenPreview() {
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let imgTitle = UIImage(named:"imgTitle.png")
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle
        
        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

}
