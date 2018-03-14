//
//  ViewControllerExpense.swift
//  ec charter
//
//  Created by Jose Duin on 3/6/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewControllerExpense: UIViewController, UITextFieldDelegate, UITextViewDelegate, writeValueBackDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var photo: UILabel!
    @IBOutlet weak var total_button: UIButton!
    @IBOutlet weak var boton: UIButton!
    
    var expensePass:Expenses = Expenses()
    let bd: BaseDatos = BaseDatos()
    var delegate: writeValueBackDelegate?
    var buscarCombo: Int = 0
    var guardar: Bool = true
    var photo_path: Data = Data()
    var cameraRequest: Bool = false
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Expense"

        self.descripcion.delegate = self
        self.total.delegate = self

        self.guardar = self.expensePass.id == 0
        
        if (!(self.guardar)) {
            self.boton.setTitle("UPDATE", for: .normal)
            loadCard()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCard() {
        self.descripcion.text = self.expensePass.description
        self.photo.text = self.expensePass.photo 
        self.total.text = String(format:"%.2f", self.expensePass.total)
        if !self.expensePass.currency.isEmpty {
            self.total_button.setTitle(self.expensePass.currency, for: .normal)
        }
        if !self.expensePass.photo.isEmpty {
            self.photo_path = self.defaults.data(forKey: self.expensePass.photo)!
        }
    }
    
    @IBAction func btn_total(_ sender: UIButton) {
        self.buscarCombo = 6
        self.performSegue(withIdentifier: "reportToCombo3", sender: self)
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        camereOrGalleryPhotoPicker()
    }
    
    @IBAction func btn_agregar(_ sender: UIButton) {
        if ((self.descripcion.text?.isEmpty)!
            || (self.total.text?.isEmpty)!
            || (self.total_button.title(for: .normal) == nil ? true : false)) {
            
            self.view.makeToast("Empty Fields", duration: 3.0, position: .bottom)
            return
        }
        
        self.expensePass.description = self.descripcion.text!
        self.expensePass.total = Double(self.total.text!)!
        self.expensePass.currency = self.total_button.title(for: .normal)!
        self.expensePass.photo = self.photo.text!

        if (guardar) {
            self.bd.expensesInsert(expense: self.expensePass)
        } else {
            // actualizar
            self.bd.expensesUpdate(expense: self.expensePass)
        }
        delegate?.writeValueBack(value: "reload")
        _ = navigationController?.popViewController(animated: true)
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
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        
        if textField == self.total {
            if textField.text != "" || string != "" {
                let res = (textField.text ?? "") + string
                return Double(res) != nil
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView == self.descripcion) {
            self.descripcion.text = self.descripcion.text!.replacingOccurrences(of: ",", with: "\n")
        }
        
        if (text == "\n") {
            self.descripcion.resignFirstResponder()
            return false
        }
        return true
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
                if self.defaults.data(forKey: self.photo.text!) == nil {
                    self.view.makeToast("Wait a second, loading image on app..", duration: 3.0, position: .bottom)
                } else {
                    self.performSegue(withIdentifier: "imagenPreviewExpense", sender: self)
                }
            }))
        }
        if !self.photo_path.isEmpty {
            actionSheet.addAction(UIAlertAction(title: "Remove Picture", style: .default, handler:{ (action:UIAlertAction) in
                self.photo_path = Data()
                self.photo.text = ""
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagen = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.photo_path = UIImageJPEGRepresentation(imagen!, 0.8)!//UIImagePNGRepresentation(imagen!)!
        
        let path = String(describing: photo_path).replacingOccurrences(of: "bytes", with: "")
        self.photo.text = path
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportToCombo3" {
            
            if let viewController = segue.destination as? ReportCombo {
                viewController.buscar = self.buscarCombo
                viewController.delegate = self
            }
        } else if segue.identifier == "imagenPreviewExpense"  {
            
            if let viewController = segue.destination as? ImagePreview {
                viewController.img = defaults.data(forKey: self.photo.text!)!
            }
        }
        
    }
    
    func writeValueBack(value: String) {
        if self.buscarCombo == 6 {
            self.total_button.setTitle(value, for: .normal)
        }
    }
    

}
