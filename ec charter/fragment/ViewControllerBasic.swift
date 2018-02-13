//
//  ViewControllerBasic.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewControllerBasic: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var customer_label: UITextField!
    @IBOutlet weak var aircraft_label: UITextField!
    @IBOutlet weak var capitan_label: UITextField!
    @IBOutlet weak var copilot_label: UITextField!
    @IBOutlet weak var date_label: UITextField!
    
    @IBOutlet weak var customer: UIPickerView!
    @IBOutlet weak var aircraft: UIPickerView!
    @IBOutlet weak var capitan: UIPickerView!
    @IBOutlet weak var copilot: UIPickerView!
    @IBOutlet weak var fecha: UIDatePicker!
    
    var arrCustomer = [String]()
    var arrAircraft = [String]()
    var arrCapitan  = [String]()
    var arrCopilot  = [String]()
    
    let bd: BaseDatos = BaseDatos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ocultarCombos()
        self.cargarCombos()
        
        camereOrGalleryPhotoPicker()
    }
    
    func camereOrGalleryPhotoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Select a Method", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler:{ (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.view.makeToast("Camera not available", duration: 3.0, position: .bottom)
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler:{ (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageUrl          = info[UIImagePickerControllerPHAsset] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.appendingPathComponent(imageName!)
        let image             = info[UIImagePickerControllerOriginalImage]as! UIImage
        let data              = UIImagePNGRepresentation(image)
        
        print("PHOTOOO")
        do {
            try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
            print(String(describing: imageName))
        } catch {
            print("Error")
            print(error)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargarCombos() {
        self.arrCustomer = self.bd.listaCustomer()
        self.arrAircraft = self.bd.listaAircraft()
        self.arrCapitan = self.bd.listaCapitan()
        self.arrCopilot = self.bd.listaCapitan()
    }
    func ocultarCombos() {
        self.customer.isHidden = true
        self.aircraft.isHidden = true
        self.capitan.isHidden = true
        self.copilot.isHidden = true
        self.fecha.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.customer_label {
            self.customer.isHidden = false
        } else if textField == self.aircraft_label {
            self.aircraft.isHidden = false
        } else if textField == self.capitan_label {
            self.capitan.isHidden = false
        } else {
            self.copilot.isHidden = false
        }
        textField.endEditing(true)
    }
    @IBAction func show_custo(_ sender: UIButton) {
        print("customerss")
        self.customer.isHidden = false
        
        let alertView = UIAlertController(
            title: "Select item from list",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
      
        
        // comment this line to use white color
        self.customer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(self.customer)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: {
            self.customer.frame.size.width = alertView.view.frame.size.width
        })
    }
    @IBAction func show_customer(_ sender: UITextField) {
        self.customer.isHidden = false
    }
    @IBAction func show_aircraft(_ sender: UITextField) {
        self.aircraft.isHidden = false
    }
    @IBAction func show_capitan(_ sender: UITextField) {
        self.capitan.isHidden = false
    }
    @IBAction func show_copilot(_ sender: UITextField) {
        self.copilot.isHidden = false
    }
    @IBAction func show_fecha(_ sender: UITextField) {
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.customer {
            return self.arrCustomer.count
        } else if pickerView == self.aircraft {
            return self.arrAircraft.count
        } else if pickerView == self.capitan {
            return self.arrCapitan.count
        } else {
            return self.arrCopilot.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)

        if pickerView == self.customer {
            return self.arrCustomer[row]
        } else if pickerView == self.aircraft {
            return self.arrAircraft[row]
        } else if pickerView == self.capitan {
            return self.arrCapitan[row]
        } else {
            return self.arrCopilot[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.customer {
            self.customer_label.text = self.arrCustomer[row]
            self.customer.isHidden = true
        } else if pickerView == self.aircraft {
            self.aircraft_label.text = self.arrAircraft[row]
            self.aircraft.isHidden = true
        } else if pickerView == self.capitan {
            self.capitan_label.text = self.arrCapitan[row]
            self.capitan.isHidden = true
        } else {
            self.copilot_label.text = self.arrCopilot[row]
            self.copilot.isHidden = true
        }
    }
    
    func agregarCombo() {
        let alert = UIAlertController(title: "titulo", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "ITEM" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let combo = alert.textFields?.first?.text
                else {return}
            print(combo)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
