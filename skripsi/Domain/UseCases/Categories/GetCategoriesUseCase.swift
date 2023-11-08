//
//  GetCategoriesUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation

class GetCategoriesUseCase: BaseUseCase {
    
    private let repository = CategoryRepository()
    typealias Params = GetCategoriesUseCase.Param
    typealias Response = [CategoryModel]
    
    func execute(params: Param) async -> Result<[CategoryModel], Error> {
        do {
            let result = try await repository.getCategories()
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param {
        
    }
}
