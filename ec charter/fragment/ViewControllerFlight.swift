//
//  ViewControllerFlight.swift
//  ec charter
//
//  Created by Jose Duin on 2/13/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerFlight: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gps_flitgh_time: UITextField!
    @IBOutlet weak var final_hour: UITextField!
    @IBOutlet weak var initial_hour: UITextField!
    
    var reportPassF: Report = Report()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gps_flitgh_time.delegate = self
        self.final_hour.delegate = self
        self.initial_hour.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        if textField == self.gps_flitgh_time {
            if textField.text != "" || string != "" {
                let res = (textField.text ?? "") + string
                return Double(res) != nil
            }
        } else if textField == self.final_hour {
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            
            let components = string.components(separatedBy: inverseSet)
            
            let filtered = components.joined(separator: "")
            
            if filtered == string {
                return true
            } else {
                if string == "." {
                    let countdots = textField.text!.components(separatedBy:".").count - 1
                    if countdots == 0 {
                        return true
                    }else{
                        if countdots > 0 && string == "." {
                            return false
                        } else {
                            return true
                        }
                    }
                }else{
                    return false
                }
            }
        } else if textField == self.initial_hour {
            let numberOnly = NSCharacterSet.init(charactersIn: "0123456789")
            let stringFromTextField = NSCharacterSet.init(charactersIn: string)
            let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
            
            return strValid
        }
        return true
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
