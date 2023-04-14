//
//  DetailViewModel.swift
//  EasyCrypto
//
//  Created by Mehran on 1/13/1402 AP.
//

import Foundation

final class DetailViewModel: ObservableObject {

    let title: String = Constants.Title.detailTitle
    @Published var marketPrice = MarketsPrice()
    
    private let repository: MarketPriceCacheRepositoryProtocol
    
    init(repository: MarketPriceCacheRepositoryProtocol = DIContainer.shared.inject(type: MarketPriceCacheRepositoryProtocol.self)!) {
        self.repository = repository
    }
    
    func addToWishlist(_ data: MarketsPrice) {
        _ = try! self.repository.save(data)
    }
    
    func deleteFromWishlist(_ data: MarketsPrice) {
        guard let name = data.name else {return}
        _ = try! self.repository.delete(name)
    }
    
    func checkIfItemExist(_ data: MarketsPrice) -> Bool {
        guard let name = data.name else {return false}
        if let _ = repository.fetchItem(name) {
            return true
        }
        return false
    }
}
