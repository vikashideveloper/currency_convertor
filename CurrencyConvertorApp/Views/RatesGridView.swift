//
//  RatesGridView.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 06/04/24.
//

import SwiftUI

struct RatesGridView: View {
    let amount: Double
    let rates: [Rate]
    let layout = [
        GridItem(.adaptive(minimum:150))
    ]
    @State var searchText = ""
    
    var searchResults: [Rate] {
        let term = searchText.lowercased()
        if term.isEmpty {
            return rates
        } else {
            return rates.filter { $0.code.lowercased().contains(term)}
        }
    }
    
    @FocusState var isTextFieldFocused: Bool
    
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
    let r: Rate = CoreDataStorage().create()
    r.set(code: "USD", rate: 4.5, symbol: "$")
    
    let r2: Rate = CoreDataStorage().create()
    r2.set(code: "INR", rate: 10.6, symbol: "₹")
    
    return RatesGridView(amount:2.5, rates: [r, r2])
}
