//
//  ViewControllerRemarks.swift
//  ec charter
//
//  Created by Jose Duin on 2/13/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit
import MessageUI
import Toast_Swift

class ViewControllerRemarks: UIViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    
    var reportPassR: Report = Report()
    let bd: BaseDatos = BaseDatos()
    let email: Email = Email()
    var haveAircraftReport: Bool = false
    var aircraftReport: Report = Report()
    let defaults = UserDefaults.standard

    @IBOutlet weak var remarks: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remarks.delegate = self

        loadReport()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn  range: NSRange, replacementText text: String) -> Bool {
        if (textView == self.remarks) {
            self.remarks.text = self.remarks.text!.replacingOccurrences(of: ",", with: "\n")
        }
        
        if (text == "\n") {
            self.remarks.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.reportPassR.remarks = self.remarks.text!
        self.bd.reportUpdate(report: self.reportPassR, atributo: "remarks")
    }
    
    func loadReport() {
        remarks.text = reportPassR.remarks
    }
    
    @IBAction func send(_ sender: UIButton) {
        let report: Report = bd.reportById(id: reportPassR.id)
        
        if (report.aircraft.isEmpty
            || report.capitan.isEmpty
            || report.route.isEmpty) {
            self.view.makeToast("Required fields: Aircraft, Capitan and Route", duration: 3.0, position: .center)
            return
        }
                
         if (report.hour_final < report.hour_initial) {
            self.view.makeToast("Hour Final must be greater than Hour Initial", duration: 3.0, position: .center)
            return
        }
        
        self.aircraftReport = report
        sendMail(report: report)
    }
    
    func sendAircrafReport(report: Report) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients([email.EMAIL_REPORT])
            mail.setSubject(email.titleReportEmail(report: report))
            
            self.haveAircraftReport = false
            let aircrafts: [AircraftReport] = self.bd.aircraftTodos(id_report: report.id)
            
            var emailText: String = ""
            emailText += email.aircraft(aircrafts: aircrafts, report: report, cantImg: 0)
            for aircraf in aircrafts {
                if !aircraf.photo.isEmpty {
                    let imageData = defaults.data(forKey: aircraf.photo)!
                    mail.addAttachmentData(imageData, mimeType: "image/png", fileName: aircraf.photo)
                }
            }
            mail.setMessageBody(emailText, isHTML: false)
            
            self.present(mail, animated: true, completion: nil)
        } else {
            self.view.makeToast("Can not send mails", duration: 3.0, position: .bottom)
        }
    }
    
    func sendMail(report: Report) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self

            let expenses: [Expenses] = self.bd.expensestTodos(id_report: report.id)
            let aircrafts: [AircraftReport] = self.bd.aircraftTodos(id_report: report.id)
            
            mail.setToRecipients([email.EMAIL])
            mail.setSubject(email.titleNormalEmail(report: report))
            
            var emailText: String = ""
            emailText += email.basic(report: report, cantImg: 0)
            if !report.passengers_photo.isEmpty {
                let imageData = defaults.data(forKey: report.passengers_photo)!
                mail.addAttachmentData(imageData, mimeType: "image/png", fileName: report.passengers_photo)
            }
            
            if !expenses.isEmpty {
                emailText += email.expense(expenses: expenses, cantImg: 0)
                for expense in expenses {
                    if !expense.photo.isEmpty {
                        let imageData = defaults.data(forKey: expense.photo)!
                        mail.addAttachmentData(imageData, mimeType: "image/png", fileName: expense.photo)
                    }
                }
            }
            if !aircrafts.isEmpty {
                emailText += email.aircraft(aircrafts: aircrafts, report: report, cantImg: 0)
                for aircraf in aircrafts {
                    if !aircraf.photo.isEmpty {
                        let imageData = defaults.data(forKey: aircraf.photo)!
                        mail.addAttachmentData(imageData, mimeType: "image/png", fileName: aircraf.photo)
                    }
                }
            }
            emailText += "\n REMARKS: \(email.validateStringNull(s: report.remarks)) \n"
            
            if !(aircrafts.isEmpty)
                || report.engine1 != 0.0
                || report.engine2 != 0.0 {
                self.haveAircraftReport = true;
            }
            mail.setMessageBody(emailText, isHTML: false)
           
            self.present(mail, animated: true, completion: nil)
        } else {
             self.view.makeToast("Can not send mails", duration: 3.0, position: .bottom)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        if haveAircraftReport {
            self.sendAircrafReport(report: self.aircraftReport)
        } else {
            self.aircraftReport.send = true
            self.bd.reportUpdate(report: self.aircraftReport, atributo: "send")
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}
