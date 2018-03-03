//
//  ViewControllerBasic.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewControllerBasic: UIViewController, writeValueBackDelegate,
    UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var date_label: UITextField!
    @IBOutlet weak var passenger: UITextView!
    @IBOutlet weak var passengerPhoto: UILabel!
    @IBOutlet weak var customer: UIButton!
    @IBOutlet weak var aircraft: UIButton!
    @IBOutlet weak var capitan: UIButton!
    @IBOutlet weak var copilot: UIButton!
    @IBOutlet weak var cockpit: UISwitch!
    
    let bd: BaseDatos = BaseDatos()
    var reportPassB: Report = Report()
    var buscarCombo: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadReport()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportToCombo" {

            if let viewController = segue.destination as? ReportCombo {
                viewController.buscar = self.buscarCombo
                viewController.delegate = self
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
        self.date_label.text = self.reportPassB.date
        self.passenger.text = self.reportPassB.passengers
        self.passengerPhoto.text = self.reportPassB.passengers_photo
        self.cockpit.isOn = self.reportPassB.cockpit
    }
    
}
