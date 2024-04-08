//
//  ErrorView.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 06/04/24.
//

import SwiftUI

struct ErrorView: View {
    let error: ConvertorError
    let onClose: (()-> Void)?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // background
            VStack(spacing:10) {
                Text("Error")
                    .font(.headline)
                Text(error.description)
                
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
