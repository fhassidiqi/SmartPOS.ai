//
//  GetItemsUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation

class GetItemsUseCase: BaseUseCase {
    private let repository = ItemRepository.shared
    typealias Params = GetItemsUseCase.Param
    typealias Response = [ItemModel]
    
    func execute(params: Param) async -> Result<[ItemModel], Error> {
        do {
            let result = try await repository.getItems(categories: params.categories)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param {
        var categories: [String]? = nil
    }
}
