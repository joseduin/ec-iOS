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
        if (text == "\n") {
            self.remarks.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = self.remarks.text
        print(text as Any)
    }
    
    func loadReport() {
        remarks.text = reportPassR.remarks
    }
    
    @IBAction func send(_ sender: UIButton) {
        let report: Report = bd.reportById(id: reportPassR.id)
        
       // if (report.aircraft.isEmpty
       //     || report.capitan.isEmpty
       //     || report.route.isEmpty) {
       //     self.view.makeToast("Required fields: Aircraft, Capitan and Route", duration: 3.0, position: .bottom)
       //     return
       // }
        
       // if (report.hour_final < report.hour_initial) {
        //    self.view.makeToast("Hour Final must be greater than Hour Initial", duration: 3.0, position: .bottom)
       //     return
       // }
        sendMail(report: report)
    }
    
    func sendMail(report: Report) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setCcRecipients([email.EMAIL])
            mail.setSubject(email.titleNormalEmail(report: report))
            mail.setMessageBody("test", isHTML: false)
            
            //let imageData: NSData = // UIImagePNGRepresentation(image)!
            // mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName")
            
            self.present(mail, animated: true, completion: nil)
        } else {
             self.view.makeToast("Can not send mails", duration: 3.0, position: .bottom)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // https://stackoverflow.com/questions/37574689/how-to-load-image-from-local-path-ios-swift-by-path
    private func load(fileName: String) -> UIImage? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let fileURL = photoURL.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL!)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
}
