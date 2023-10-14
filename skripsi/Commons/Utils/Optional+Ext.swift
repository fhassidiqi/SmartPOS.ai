//
//  Optional+Ext.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation

extension Optional where Wrapped == String {
    func orEmpty() -> String {
        return self ?? ""
    }
}
