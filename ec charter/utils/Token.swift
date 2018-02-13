//
//  Token.swift
//  ec charter
//
//  Created by Jose Duin on 2/4/18.
//  Copyright © 2018 Jose Duin. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class Token {
  
    /**
     * Token que es usado como PIN
     */
    let token = "e07bceab69529b0f0b43625953fbf2a0";
    
    /**
     * Validamos el pass contra el token
     */
    func access(pass: String) -> Bool {
        return token == self.getMD5(input: pass)
    }
    
    /**
     * Convierte un string a cifrado md5
     */
    func getMD5(input: String) -> String {
        return input.md5()
    }
    
}
