//
//  CurrencyListView.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import SwiftUI

struct CurrencyListView: View {
    @EnvironmentObject var viewModel: CurrencyConvertorViewModel
    @Binding var isPresented: Bool
    @State private var searchText = ""

    var selected: Currency?
    
    var body: some View {
        NavigationView {
            VStack {
                List(searchResults) { currency in
                    HStack {
                        Text("\(currency.code) - \(currency.name)")
                        Spacer()
                        if selected?.code == currency.code {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectedCurrency = currency
                        isPresented.toggle()
                    }
                }
                .navigationTitle("Currencies")

            }
        }
        .searchable(text: $searchText, prompt: "Search")
    }
    
    var searchResults: [Currency] {
        let term = searchText.lowercased()
        if term.isEmpty {
            return viewModel.currencies
        } else {
            return viewModel.currencies.filter { $0.name.lowercased().contains(term) || $0.code.lowercased().contains(term) }
        }
    }
}


#Preview {
    let viewModel = CurrencyConvertorViewModel.instantiateWithDI()
    let c1: Currency = CoreDataStorage().createEntity()
    c1.set(code: "USD", name: "United State Dollar")
    
    let c2: Currency = CoreDataStorage().createEntity()
    c2.set(code: "INR", name: "Indian Ruppes")

    viewModel.currencies = [c1, c2]
    return CurrencyListView(isPresented: .constant(true))
        .environmentObject(viewModel)
}
