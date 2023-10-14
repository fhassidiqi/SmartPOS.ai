//
//  BaseUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation

protocol BaseUseCase {
    associatedtype Params
    associatedtype Response
    func execute(params: Params) async -> Result<Response, Error>
}
