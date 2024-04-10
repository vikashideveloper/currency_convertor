//
//  RatesGridView.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 06/04/24.
//

import SwiftUI

struct RatesGridView: View {
    @State private var searchText = ""
    @FocusState private var isTextFieldFocused: Bool
    
    init(amount: Double, rates: [Rate]) {
        self.amount = amount
        self.rates = rates
    }
    
    private let amount: Double
    private let rates: [Rate]
    private let layout = [
        GridItem(.adaptive(minimum:150))
    ]

    private var searchResults: [Rate] {
        let term = searchText.lowercased()
        if term.isEmpty {
            return rates
        } else {
            return rates.filter { $0.code.lowercased().contains(term)}
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .font(Font.system(size: 21))
                    .focused($isTextFieldFocused)
            }
            .padding(7)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(50)
            
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(searchResults, id: \.code) { rate in
                        Rectangle()
                            .fill(.black.opacity(0.2))
                            .overlay {
                                VStack(spacing:10) {
                                    Text("\(rate.code)")
                                    Text(rate.displayPrice(for: amount))
                                }
                                .foregroundColor(.black)
                            }
                            .frame(height: 80)
                            .cornerRadius(5)
                    }
                }
            }
            .interactiveDismissDisabled(false)
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

#Preview {
    let rate1: Rate = CoreDataStorage().createEntity()
    rate1.set(code: "USD", rate: 4.5, symbol: "$")
    
    let rate2: Rate = CoreDataStorage().createEntity()
    rate2.set(code: "INR", rate: 10.6, symbol: "₹")
    
    return RatesGridView(amount:2.5, rates: [rate1, rate2])
}
