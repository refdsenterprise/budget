//
//  AddTransactionScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

struct AddTransactionScene: View {
    @StateObject private var presenter: AddTransactionPresenter = .instance
    @State private var isPresentedAlert = false
    @State private var isPresentedSelectionCategory = false
    @State private var document: DataDocument = .init()
    @State private var isImporting: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        form
            .navigationTitle("Nova Transação")
            .onAppear { presenter.loadData() }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        Application.shared.endEditing()
                        if presenter.canAddNewTransaction {
                            do {
                                try Storage.shared.transaction.addTransaction(date: presenter.date, description: presenter.description, category: presenter.category!, amount: presenter.amount)
                                dismiss()
                            } catch {
                                isPresentedAlert.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(presenter.buttonForegroundColor)
                    }
                    
                    //  buttonImport
                }
            }
//            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { result in
//                switch result {
//                case .success(let url): Storage.shared.transaction.replaceAllTransactions(try? Data(contentsOf: url))
//                case .failure(_): print("error import file")
//                }
//            }
            .sheet(isPresented: $isPresentedSelectionCategory) {
                HalfSheet {
                    SelectCategoryScene(selection: $presenter.category, date: $presenter.date)
                }
            }
    }
    
    private var form: some View {
        Form {
            sectionAmount
        }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionAmount: some View {
        Section {
            rowCategory
            rowDescription
            rowDate
        } header: {
            RefdsCurrency(value: Binding(get: { presenter.amount }, set: { presenter.amount = $0 }), size: .custom(40))
                .padding()
        }
    }
    
    private var rowDate: some View {
        DatePicker("Informe o mês", selection: Binding(get: { presenter.date }, set: { presenter.date = $0; presenter.loadData() }), displayedComponents: [.date, .hourAndMinute])
            .font(.refds(size: 16, scaledSize: 1.2 * 16))
            .datePickerStyle(.graphical)
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText("Descrição")
            Spacer()
            RefdsTextField("Informe a descrição (Opicional)", text: $presenter.description, alignment: .trailing, textInputAutocapitalization: .sentences)
        }
    }
    
    private var rowCategory: some View {
        VStack {
            if presenter.category != nil, let name = presenter.category?.name, let color = presenter.category?.color {
                HStack {
                    RefdsText("Categoria")
                    Spacer()
                    RefdsTag(name, size: .extraSmall, color: color)
                }
                .onTapGesture {
                    isPresentedSelectionCategory.toggle()
                }
            } else {
                NavigationLink {
                    AddCategoryScene()
                } label: {
                    HStack {
                        RefdsText("Categoria")
                        Spacer()
                        RefdsText("Adicionar nova categoria", color: .secondary, alignment: .trailing, lineLimit: 1)
                    }
                }
            }
        }
    }
    
    private var buttonImport: some View {
        Button {
            Application.shared.endEditing()
            isImporting.toggle()
        } label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(presenter.buttonForegroundColor)
        }
    }
}

struct AddTransactionScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { AddTransactionScene() }
    }
}

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            // configure at will
            presentation.detents = [.medium()]
        }
    }
}

struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {
    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {

    }
}
