//
//  ErrorView.swift
//  CurrencyConvertorApp
//
//  Created by Vikash Kumar on 06/04/24.
//

import SwiftUI

struct ErrorView: View {
    private let error: ConvertorError
    private let onClose: (()-> Void)?
    private let onRetry: (()-> Void)?

    init(error: ConvertorError, onClose: (() -> Void)? = nil, onRetry: (() -> Void)? = nil) {
        self.error = error
        self.onClose = onClose
        self.onRetry = onRetry
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // background
            VStack(spacing:10) {
                Text("Error")
                    .font(.headline)
                Text(error.description)
                
                Button {
                onRetry?()
                } label: {
                    Text("Retry")
                }

            }
            .padding(25)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.red.opacity(0.3))
            }
            // close button
            Button {
                onClose?()
            } label: {
                Image(systemName: "multiply.circle")
            }
            .frame(width: 35, height: 35)
        }
    }
}

#Preview {
    ErrorView(error: ConvertorError.badUrl, onClose: nil)
}
