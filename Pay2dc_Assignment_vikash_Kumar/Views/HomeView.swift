//
//  HomeView.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 05/04/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var viewModel: CurrencyConvertorViewModel
    @State var isCurrencySelectorPresented = false
    
    var isLoading: Bool {
        viewModel.loadingRates || viewModel.loadingCurrencies
    }
    
    @FocusState var isTextFieldFocused: Bool
    
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
                            if viewModel.loadingCurrencies {
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
                    ErrorView(error: error) {
                        viewModel.error = nil
                    }
                }
                
                // progress view for loading rates
                if viewModel.loadingRates {
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
//            .ignoresSafeArea(edges: .bottom)
        }
        .onTapGesture {
            isTextFieldFocused = false
        }

        .onAppear {
            Task {
                // fetch currencies and rates
                await viewModel.fetchCurrencies()
                await viewModel.fetchRates()
            }
        }
    }
}

#Preview {
    let repository = OpenExchangeRepository(appId: Constants.OE_APP_ID)
    let storage = CoreDataStorage()
    let viewModel = CurrencyConvertorViewModel(service: DataService(repository: repository, store: storage))
    
    return HomeView()
        .environmentObject(viewModel)
}
