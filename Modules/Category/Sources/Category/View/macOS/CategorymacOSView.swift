//
//  CategorymacOSView.swift
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

struct CategorymacOSView<Presenter: CategoryPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        MacUIView(sections: [
            .init(maxAmount: 2, content: {
                Group {
                    sectionTotal
                    sectionOptions
                }
            }),
            .init(maxAmount: nil, content: {
                sectionCategories
            })
        ])
            .budgetAlert($presenter.alert)
            .navigationTitle(presenter.string(.navigationTitle))
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddCategory } }
            .searchable(text: $presenter.query, prompt: presenter.string(.searchPlaceholder))
            .onAppear { presenter.loadData()  }
            .navigation(isPresented: $presenter.isPresentedAddCategory) {
                presenter.router.configure(routes: .addActegory(nil))
            }
            .navigation(isPresented: $presenter.isPresentedEditCategory) {
                presenter.router.configure(routes: .addActegory(presenter.category))
            }
    }
    
    private var sectionTotal: some View {
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
            .frame(maxWidth: .infinity)
            RefdsText(
                presenter.totalBudget.formatted(.currency(code: presenter.string(.currency))),
                size: .custom(20),
                color: .accentColor,
                weight: .bold,
                family: .moderatMono
            )
        }
    }
    
    private var sectionOptions: some View {
        SectionGroup {
            Group {
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
                
                if let previousDate = presenter.getDateFromLastCategoriesByCurrentDate() {
                    sectionDuplicateCategories(previousDate: previousDate)
                }
            }
        }
    }
    
    private func sectionDuplicateCategories(previousDate: Date) -> some View {
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
    
    private var sectionCategories: some View {
        ForEach(presenter.getCategoriesFiltred(), id: \.id) { category in
            NavigationLink(destination: {
                presenter.router.configure(routes: .transactions(category, presenter.date))
                    .tint(category.color)
            }, label: {
                rowCategory(category).padding()
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
                presenter.alert = .init(error: $0)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                presenter.isPresentedEditCategory.toggle()
            }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                presenter.isPresentedEditCategory.toggle()
            }
        } label: {
            Label(presenter.string(.edit), systemImage: RefdsIconSymbol.squareAndPencil.rawValue)
        }
    }
    
    private func contextMenuRemoveCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.remove(category: category) {
                presenter.alert = .init(error: $0)
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

struct CategorymacOSView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                HStack {}
                //CategoryScreen(device: .macOS, presenter: CategoryPresenter.instance)
            }
            .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
        }
    }
}
