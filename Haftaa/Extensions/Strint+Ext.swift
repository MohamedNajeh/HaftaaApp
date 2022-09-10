//
//  Strint+Ext.swift
//  Haftaa
//
//  Created by Apple on 04/07/2022.
//

import Foundation
extension String {
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
