//
//  ViewControllerSetting.swift
//  ec charter
//
//  Created by Jose Duin on 2/21/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ViewControllerSetting: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settings: UITableView!
    
    let variable:Variable = Variable()
    var arr_setting:[String] = [String]()
    var attribute: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"

        self.arr_setting = self.variable.menuSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_setting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardSettings") as! CardSettings
        cell.titulo.text = self.arr_setting[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.attribute = indexPath.row
        self.performSegue(withIdentifier: "SettingToComboSetting", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingToComboSetting" {
            if let viewController = segue.destination as? ViewControllerComboSetting {
                viewController.attribute = self.attribute
            }
        }
    }

}
