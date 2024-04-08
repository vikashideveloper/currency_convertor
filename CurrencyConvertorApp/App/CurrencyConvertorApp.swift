//
//  CurrencyConvertorApp.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import SwiftUI
import SwiftData

@main
struct CurrencyConvertorApp: App {

    var body: some Scene {
        let viewModel = CurrencyConvertorViewModel.instantiateWithDI()
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
    }
}
