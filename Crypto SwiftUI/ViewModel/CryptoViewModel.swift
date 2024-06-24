//
//  CryptoViewModel.swift
//  Crypto SwiftUI
//
//  Created by Batuhan Berk Ertekin on 23.06.2024.
//

import Foundation
import Alamofire


class CryptoViewModel : ObservableObject{
    
    @Published var crypto = [Crypto]()
    
    init() {
        fetchCryptos()
    }
    var topEarners: [Crypto] {
            crypto.sorted(by: { $0.priceChangePercentage24HInCurrency ?? 0 > $1.priceChangePercentage24HInCurrency ?? 0 })
        }
        
    func fetchCryptos(){
        
        AF.request("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h&locale=en",method: .get).responseDecodable(of: [Crypto].self) { response in
            
            switch response.result {
            case .success(let crypto):
               
                DispatchQueue.main.async{
                    self.crypto = crypto
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
