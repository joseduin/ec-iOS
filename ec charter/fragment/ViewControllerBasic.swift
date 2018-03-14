//
//  ViewControllerBasic.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift
import DatePickerDialog

class ViewControllerBasic: UIViewController, writeValueBackDelegate,
    UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var date_label: UIButton!
    @IBOutlet weak var passenger: UITextView!
    @IBOutlet weak var passengerPhoto: UILabel!
    @IBOutlet weak var customer: UIButton!
    @IBOutlet weak var aircraft: UIButton!
    @IBOutlet weak var capitan: UIButton!
    @IBOutlet weak var copilot: UIButton!
    @IBOutlet weak var cockpit: UISwitch!
    
    let bd: BaseDatos = BaseDatos()
    var reportPassB: Report = Report()
    let hora: Hora = Hora()

    let defaults = UserDefaults.standard
    var buscarCombo: Int = 0
    var cameraRequest: Bool = false
    var photo_path: Data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passenger.delegate = self
        
        loadReport()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func camereOrGalleryPhotoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Select a Method", message: nil, preferredStyle: .alert)//.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler:{ (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.cameraRequest = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.view.makeToast("Camera not available", duration: 3.0, position: .bottom)
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler:{ (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.cameraRequest = false
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        if !self.photo_path.isEmpty {
            actionSheet.addAction(UIAlertAction(title: "Preview", style: .default, handler:{ (action:UIAlertAction) in
                if self.defaults.data(forKey: self.passengerPhoto.text!) == nil {
                    self.view.makeToast("Wait a second, loading image on app..", duration: 3.0, position: .bottom)
                } else {
                    self.performSegue(withIdentifier: "imagenPreviewBasic", sender: self)
                }
            }))
        }
        if !self.photo_path.isEmpty {
            actionSheet.addAction(UIAlertAction(title: "Remove Picture", style: .default, handler:{ (action:UIAlertAction) in
                self.photo_path = Data()
                self.passengerPhoto.text = ""
                self.reportPassB.passengers_photo = ""
                self.bd.reportUpdate(report: self.reportPassB, atributo: "passengers_photo")
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagen = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.photo_path = UIImageJPEGRepresentation(imagen!, 0.8)!//UIImagePNGRepresentation(imagen!)!
        
        let path = String(describing: photo_path).replacingOccurrences(of: "bytes", with: "")
        self.passengerPhoto.text = path
        self.reportPassB.passengers_photo = path
        self.bd.reportUpdate(report: self.reportPassB, atributo: "passengers_photo")

        DispatchQueue.global(qos: .background).async {
            self.defaults.set(self.photo_path, forKey: path)
            self.defaults.synchronize()
        }
        
        // Guardar la photo en la libreria
        if (self.cameraRequest) {
            UIImageWriteToSavedPhotosAlbum(imagen!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.view.makeToast(error.localizedDescription, duration: 3.0, position: .bottom)

        } else {
            print("Saved!")
        }
    }
    
    @IBAction func show_custo(_ sender: UIButton) {
        self.buscarCombo = 1
        self.performSegue(withIdentifier: "reportToCombo", sender: self)
    }
    @IBAction func show_aircraft(_ sender: UIButton) {
        self.buscarCombo = 2
        self.performSegue(withIdentifier: "reportToCombo", sender: self)
    }
    @IBAction func show_capitan(_ sender: UIButton) {
        self.buscarCombo = 3
        self.performSegue(withIdentifier: "reportToCombo", sender: self)
    }
    @IBAction func show_copilot(_ sender: UIButton) {
        self.buscarCombo = 4
        self.performSegue(withIdentifier: "reportToCombo", sender: self)
    }
    @IBAction func cockpit_check(_ sender: UISwitch) {
        self.reportPassB.cockpit = self.cockpit.isOn
        self.bd.reportUpdate(report: self.reportPassB, atributo: "cockpit")
    }
    @IBAction func selectPhoto(_ sender: UIButton) {
        camereOrGalleryPhotoPicker()
    }
    @IBAction func show_datePicker(_ sender: UIButton) {
        DatePickerDialog().show("Select a date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MMM-yy"
                self.date_label.setTitle(formatter.string(from: dt).uppercased(), for: .normal)
                
                self.reportPassB.date = formatter.string(from: dt).uppercased()
                self.bd.reportUpdate(report: self.reportPassB, atributo: "date")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportToCombo" {

            if let viewController = segue.destination as? ReportCombo {
                viewController.buscar = self.buscarCombo
                viewController.delegate = self
             }
        } else if segue.identifier == "imagenPreviewBasic"  {
            
            if let viewController = segue.destination as? ImagePreview {
                viewController.img = defaults.data(forKey: self.passengerPhoto.text!)!
            }
        }
    }
    
    func writeValueBack(value: String) {
        if self.buscarCombo == 1 {
            self.customer.setTitle(value, for: .normal)
            self.reportPassB.customer = value
            self.bd.reportUpdate(report: self.reportPassB, atributo: "customer")
        } else if self.buscarCombo == 2 {
            self.aircraft.setTitle(value, for: .normal)
            self.reportPassB.aircraft = value
            self.bd.reportUpdate(report: self.reportPassB, atributo: "aircraft")
        } else if self.buscarCombo == 3 {
            self.capitan.setTitle(value, for: .normal)
            self.reportPassB.capitan = value
            self.bd.reportUpdate(report: self.reportPassB, atributo: "capitan")
        } else if self.buscarCombo == 4 {
            self.copilot.setTitle(value, for: .normal)
            self.reportPassB.copilot = value
            self.bd.reportUpdate(report: self.reportPassB, atributo: "copilot")
        }
    }
    
    func loadReport() {
        self.customer.setTitle(self.reportPassB.customer, for: .normal)
        self.aircraft.setTitle(self.reportPassB.aircraft, for: .normal)
        self.capitan.setTitle(self.reportPassB.capitan, for: .normal)
        self.copilot.setTitle(self.reportPassB.copilot, for: .normal)
        self.date_label.setTitle(self.reportPassB.date, for: .normal)
        self.passenger.text = self.reportPassB.passengers
        self.passengerPhoto.text = self.reportPassB.passengers_photo
        if !self.reportPassB.passengers_photo.isEmpty {
            self.photo_path = defaults.data(forKey: self.reportPassB.passengers_photo)!
        }
        self.cockpit.isOn = self.reportPassB.cockpit
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /* Dissmis keyboad to TextView */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView == self.passenger) {
            self.passenger.text = self.passenger.text!.replacingOccurrences(of: ",", with: "\n")
        }
        
        if (text == "\n") {
            self.passenger.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.reportPassB.passengers = self.passenger.text!
        self.bd.reportUpdate(report: self.reportPassB, atributo: "passangers")
    }
    
}
