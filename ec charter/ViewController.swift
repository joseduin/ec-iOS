//
//  ViewController.swift
//  ec charter
//
//  Created by Jose Duin on 2/3/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift
import SQLite

class ViewController: UIViewController, UITextFieldDelegate {

    // https://github.com/Kilo-Loco/SQLite
    // https://www.youtube.com/watch?v=c4wLS9py1rU
    // https://www.youtube.com/watch?v=zzhG2MlZ8WU
    
    @IBOutlet weak var pin: UITextField!
    let token: Token = Token()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pin.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        let clave = pin.text
        
        if ( token.access(pass: clave!) ) {
            self.view.makeToast("PIN Incorrect", duration: 3.0, position: .bottom)
        } else {
            self.performSegue(withIdentifier: "loginToInicio", sender: self)
        }
    }
    
    // cuando se aprieta fuera del campo de texto
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // boton return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pin.resignFirstResponder()
        return true
    }
    
}
