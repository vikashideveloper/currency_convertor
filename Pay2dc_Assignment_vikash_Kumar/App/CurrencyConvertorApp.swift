//
//  Pay2dc_Assignment_vikash_KumarApp.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 05/04/24.
//

import SwiftUI
import SwiftData

@main
struct CurrencyConvertorApp: App {

    var body: some Scene {
        let repository = OpenExchangeRepository(appId: Constants.OE_APP_ID)
        let storage = CoreDataStorage()
        let viewModel = CurrencyConvertorViewModel(service: DataService(repository: repository, store: storage))
       
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
        
    }
}
