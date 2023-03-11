//
//  CategoryiOSView.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface
import Resource

struct CategoryiOSView<Presenter: CategoryPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    private let transactionScene: ((CategoryEntity, Date) -> any View)?
    
    init(presenter: Presenter, transactionScene: ((CategoryEntity, Date) -> any View)? = nil) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.transactionScene = transactionScene
    }
    
    var body: some View {
        list
            .budgetAlert($presenter.alert)
            .navigationTitle(presenter.string(.navigationTitle))
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddCategory } }
            .searchable(text: $presenter.query, prompt: presenter.string(.searchPlaceholder))
            .onAppear { presenter.loadData()  }
            .background(
                NavigationLink(
                    destination: AddCategoryScreen(
                        device: .iOS,
                        presenter: AddCategoryPresenter.instance
                    ),
                    isActive: $presenter.isPresentedAddCategory
                ) { EmptyView() }.hidden()
            )
            .background(
                NavigationLink(
                    destination: AddCategoryScreen(
                        device: .iOS,
                        presenter: AddCategoryPresenter(category: presenter.category)
                    ),
                    isActive: $presenter.isPresentedEditCategory
                ) { EmptyView() }.hidden()
            )
    }
    
    private var list: some View {
        List {
            sectionOptions
            
            if let previousDate = presenter.getDateFromLastCategoriesByCurrentDate() {
                sectionDuplicateCategories(previousDate: previousDate)
            }
            
            if !presenter.getCategoriesFiltred().isEmpty, let transactionScene = transactionScene {
                sectionCategories(transactionScene: transactionScene)
                sectionTotal
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private var sectionOptions: some View {
        CollapsedView(title: presenter.string(.sectionOptions)) {
            Group {
                HStack {
                    Toggle(isOn: $presenter.isFilterPerDate) {
                        RefdsText(presenter.string(.sectionOptionsFilterPerDate))
                    }
                    .toggleStyle(CheckBoxStyle())
                }
                
                if presenter.isFilterPerDate {
                    PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy"))
                }
            }
        }
    }
    
    private func sectionDuplicateCategories(previousDate: Date) -> some View {
        Section {
            VStack(alignment: .center, spacing: 20) {
                RefdsText(presenter.string(.sectionDuplicateNotFound), size: .large, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.sectionDuplicateSuggestion), color: .secondary, alignment: .center)
                Button {
                    presenter.duplicateCategories(from: previousDate)
                } label: {
                    RefdsText(presenter.string(.sectionDuplicateButton).uppercased(), size: .small, color: .accentColor, weight: .bold)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.accentColor.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func sectionCategories(transactionScene: @escaping (CategoryEntity, Date) -> any View) -> some View {
        Section {
            ForEach(presenter.getCategoriesFiltred(), id: \.id) { category in
                NavigationLink(destination: {
                    AnyView(transactionScene(category, presenter.date))
                        .tint(category.color)
                }, label: {
                    rowCategory(category)
                })
                .contextMenu {
                    contextMenuEditCategory(category)
                    contextMenuRemoveCategory(category)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    swipeEditCategory(category)
                    swipeRemoveCategory(category)
                }
            }
        } header: {
            RefdsText(
                presenter.string(.sectionCategoriosHeader),
                size: .extraSmall,
                color: .secondary
            )
        }
    }
    
    private var sectionTotal: some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText(
                    presenter.string(.currentValue).uppercased(),
                    size: .custom(12),
                    color: .secondary
                )
                RefdsText(
                    presenter.totalActual.formatted(.currency(code: presenter.string(.currency))),
                    size: .custom(40),
                    color: .primary,
                    weight: .bold,
                    family: .moderatMono,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(
                    presenter.totalBudget.formatted(.currency(code: presenter.string(.currency))),
                    size: .custom(20),
                    color: .accentColor,
                    weight: .bold,
                    family: .moderatMono
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func rowCategory(_ category: CategoryEntity) -> some View {
        HStack(spacing: 10) {
            IndicatorPointView(color: category.color)
            VStack(spacing: 2) {
                HStack {
                    RefdsText(category.name.capitalized, weight: .bold)
                    Spacer()
                    if let budget = presenter.getBudget(by: category) {
                        RefdsText(
                            budget.amount.formatted(.currency(code: presenter.string(.currency))),
                            family: .moderatMono,
                            lineLimit: 1
                        )
                    }
                }
                if let transactions = presenter.getTransactions(by: category),
                   let percent = presenter.getDifferencePercent(on: category, hasPlaces: true) {
                    HStack {
                        RefdsText(presenter.string(.rowCategorySpending(percent)), color: .secondary)
                        Spacer()
                        RefdsText(presenter.string(.rowCategoryTransaction(transactions.count)), color: .secondary)
                    }
                }
            }
        }
    }
    
    private func swipeRemoveCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.remove(category: category) {
                presenter.alert.present(error: $0)
            }
        } label: {
            RefdsIcon(
                symbol: .trashFill,
                color: .white,
                size: 25,
                renderingMode: .hierarchical
            )
        }
        .tint(.red)
    }
    
    private func swipeEditCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.category = category
            presenter.isPresentedEditCategory.toggle()
        } label: {
            RefdsIcon(
                symbol: .squareAndPencil,
                color: .white,
                size: 25,
                renderingMode: .hierarchical
            )
        }
        .tint(.orange)
    }
    
    private func contextMenuEditCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.category = category
            presenter.isPresentedEditCategory.toggle()
        } label: {
            Label(presenter.string(.edit), systemImage: RefdsIconSymbol.squareAndPencil.rawValue)
        }
    }
    
    private func contextMenuRemoveCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.remove(category: category) {
                presenter.alert.present(error: $0)
            }
        } label: {
            Label(presenter.string(.remove), systemImage: RefdsIconSymbol.trashFill.rawValue)
        }
    }
    
    private var buttonAddCategory: some View {
        Button { presenter.isPresentedAddCategory.toggle() } label: {
            RefdsIcon(
                symbol: .plusRectangleFill,
                color: .accentColor,
                size: 20,
                weight: .medium,
                renderingMode: .hierarchical
            )
        }
    }
}

struct CategoryiOSView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                CategoryScreen(device: .iOS, presenter: CategoryPresenter.instance)
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        }
    }
}
