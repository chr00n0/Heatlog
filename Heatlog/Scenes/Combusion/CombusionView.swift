//
//  CombusionView.swift
//  Heatlog
//
//  Created by Emil Piórkowski on 20/10/2026.
//

import SwiftUI

struct CombusionView: View {
    
    @State private var viewModel = CombusionViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.combusionCoal.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 50))
                    Text("Nie dodałeś jeszcze żadnego spalania")
                    HStack {
                        Image(systemName: "plus")
                        Text("Dodaj spalanie")
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        viewModel.addRecord()
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 5)
                }
            } else {
                List(viewModel.combusionCoal) { _ in
                    VStack {
                        HStack {
                            Text("")
                            Spacer()
                            Text(viewModel.amount) 
                        }
                        HStack {
                            Text("\(viewModel.bagsCount)")
                            Text("25 kg")
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    CombusionView()
}
