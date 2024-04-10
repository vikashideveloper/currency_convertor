//
//  HomeView.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 05/04/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var viewModel: CurrencyConvertorViewModel
    @State private var isCurrencySelectorPresented = false
    @FocusState private var isTextFieldFocused: Bool

    private var isLoading: Bool {
        viewModel.loadingState == .loadingRates || viewModel.loadingState == .loadingCurrencies
    }
    
    private func loadConvertorData() async {
        viewModel.error = nil
        await viewModel.fetchCurrencyConvertorData()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                HStack {
                    // amount input field
                    TextField("Enter amount", text: $viewModel.amountToConvert )
                        .focused($isTextFieldFocused)
                        .keyboardType(.decimalPad)
                        .padding()
                        .frame(height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.blue)
                        }
                    // currency dropdown button
                    Button {
                        if !isLoading {
                            isTextFieldFocused = false
                            isCurrencySelectorPresented.toggle()
                        }
                    } label: {
                        HStack {
                            if viewModel.loadingState == .loadingCurrencies {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            } else {
                                Text(viewModel.selectedCurrency?.code ?? "Select Currency")
                                Image(systemName: "chevron.down")
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                        }
                    }
                }
                
                // error view if any error occurrs
                if let error = viewModel.error as? ConvertorError {
                    ErrorView(error: error, onClose: {
                        viewModel.error = nil
                    }, onRetry: {
                        Task {
                            await loadConvertorData()
                        }
                    })
                }
                
                // progress view for loading rates
                if viewModel.loadingState == .loadingRates {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        Text("Fetching rates...")
                    }
                } else {
                    if !viewModel.rates.isEmpty {
                        RatesGridView(amount:viewModel.amount, rates: viewModel.rates)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Currency Convertor")
            .sheet(isPresented: $isCurrencySelectorPresented) {
                CurrencyListView(isPresented: $isCurrencySelectorPresented, selected: viewModel.selectedCurrency)
            }
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .onAppear {
            Task {
                await loadConvertorData()
            }
        }
    }
}

#Preview {
    let viewModel = CurrencyConvertorViewModel.instantiateWithDI()
    return HomeView()
        .environmentObject(viewModel)
}
