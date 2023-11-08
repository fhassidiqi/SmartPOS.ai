//
//  CategoryRepository.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation

protocol ICategoryRepository {
    func getCategories() async throws -> [CategoryModel]
    func getCategory() async throws -> CategoryModel?
}

class CategoryRepository: ICategoryRepository {
    private let remoteDataSource = RemoteDataSource.shared
    static let shared = CategoryRepository()
    
    func getCategories() async throws -> [CategoryModel] {
        let categoriesResponse = try await remoteDataSource.fetchCategories()
        return categoriesResponse.map { categoryResponse in
            CategoryModel(id: categoryResponse.id.orEmpty(), name: categoryResponse.name)
        }
    }
    
    func getCategory() async throws -> CategoryModel? {
        return nil
    }
    
    
}
