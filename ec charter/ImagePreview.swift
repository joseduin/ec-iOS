//
//  ImagePreview.swift
//  ec charter
//
//  Created by Jose Duin on 3/8/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import UIKit

class ImagePreview: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    
    var img: Data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Preview"
        
        self.imagen.image = UIImage(data: self.img)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

}
