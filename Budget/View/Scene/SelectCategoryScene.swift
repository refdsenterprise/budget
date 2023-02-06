//
//  SelectCategoryScene.swift
//  Budget
//
//  Created by Rafael Santos on 02/02/23.
//

import SwiftUI
import RefdsUI

struct SelectCategoryScene: View {
    @Binding var selection: CategoryEntity?
    @State var selected: CategoryEntity?
    @Binding var date: Date
    @State private var categories: [CategoryEntity] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(categories, id: \.id) { category in
                        Button {
                            self.selected = category
                            self.selection = category
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                dismiss()
                            }
                        } label: {
                            HStack(spacing: 10) {
                                indicatorPoint(color: selected?.id == category.id ? category.color : .secondary)
                                RefdsText(category.name.capitalized)
                                Spacer()
                                if let budget = category.budgets.first(where: { $0.date.asString(withDateFormat: "MM/yyyy") == date.asString(withDateFormat: "MM/yyyy") }) {
                                    RefdsText(budget.amount.formatted(.currency(code: "BRL")), color: .secondary, family: .moderatMono)
                                }
                            }
                        }
                    }
                } header: {
                    RefdsText("Categorias", size: .extraSmall, color: .secondary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Selecione a categoria")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .symbolRenderingMode(.hierarchical)
                            .frame(height: 25)
                    }
                    .tint(.secondary)
                }
            }
        }
        .onAppear {
            selected = selection
            categories = Storage.shared.category.getCategories(from: date, format: "MM/yyyy")
        }
    }
    
    private func indicatorPoint(color: Color) -> some View {
        VStack {
            VStack {
            }
            .frame(width: 10, height: 10)
            .background(color)
            .clipShape(Circle())
        }
        .frame(width: 20, height: 20)
        .background(color.opacity(0.2))
        .clipShape(Circle())
    }
}

struct SelectCategoryScene_Previews: PreviewProvider {
    static var previews: some View {
        SelectCategoryScene(selection: Binding(get: { .init(name: "any-category", color: .green, budgets: []) }, set: { _, _ in }), date: Binding(get: { Date() }, set: { _, _ in }))
    }
}
