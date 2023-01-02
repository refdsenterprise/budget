//
//  BudgetScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Charts

struct BudgetScene: View {
    @StateObject private var presenter: BudgetPresenter = .instance
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(BudgetApp.TabItem.budget.title)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            if presenter.isFilterPerDate { buttonCalendar }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if presenter.isFilterPerDate {
                            RefdsTag(presenter.date.asString(withDateFormat: "MMMM, yyyy"), color: .teal)
                        }
                    }
                }
                .onAppear { presenter.loadData() }
                
        }
        .tabItem {
            Image(systemName: "dollarsign.square.fill")
            RefdsText(BudgetApp.TabItem.budget.title, size: .normal)
        }
        .tag(BudgetApp.TabItem.budget)
    }
    
    private var content: some View {
        List {
            sectionActualAndBudget
            if !presenter.categories.isEmpty {
                sectionDifference
                sectionTotalDifference
                sectionChartBudgetVsActualTitle
                sectionChartBudgetVsActual
            }
            sectionOptions
        }
    }
    
    private var sectionOptions: some View {
        Section {
            HStack {
                Toggle(isOn: Binding(get: { presenter.isFilterPerDate }, set: { presenter.isFilterPerDate = $0; presenter.loadData() })) { RefdsText("Filtrar por data") }
            }
        } header: {
            RefdsText("opções", size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionActualAndBudget: some View {
        Section { } footer: {
            ZStack {
                ForEach(0..<3) { index in
                    currentValueView
                        .scaleEffect(1.0 - abs(distance(index)) * 0.25)
                        .opacity(1.0 - abs(distance(index)) * 0.7)
                        .offset(x: myXOffset(index), y: 0)
                        .zIndex(1.0 - abs(distance(index)) * 0.1)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        draggingItem = snappedItem + value.translation.width / 100
                    }
                    .onEnded { value in
                        withAnimation {
                            draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                            draggingItem = round(draggingItem).remainder(dividingBy: Double(3))
                            snappedItem = draggingItem
                        }
                    }
            )
            .padding(.top, 25)
            .padding(.bottom, 15)
        }
    }
    
    private func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(3))
    }
    
    private func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(3) * distance(item)
        return sin(angle) * 100
    }
    
    private var currentValueView: some View {
        VStack {
            if let actual = presenter.getTotalActual(),
               let budget = presenter.getTotalBudget() {
                VStack(spacing: 10) {
                    VStack {
                        RefdsText("valor atual".uppercased(), size: .custom(12), color: .secondary)
                        RefdsText(
                            actual.formatted(.currency(code: "BRL")),
                            size: .custom(40),
                            color: presenter.getActualColor(actual: actual, budget: budget),
                            weight: .bold,
                            family: .moderatMono,
                            alignment: .center,
                            lineLimit: 1
                        )
                    }
                    RefdsText(budget.formatted(.currency(code: "BRL")), size: .custom(16), family: .moderatMono)
                }
                .padding()
                .padding(.horizontal)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
            }
            
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionDifference: some View {
        Section {
            ForEach(presenter.categories) { category in
                if let budget = presenter.getBudget(by: category)?.amount,
                   let actual = presenter.getActualTransaction(by: category) {
                    HStack {
                        VStack(alignment: .leading) {
                            RefdsTag(category.name, size: .custom(11), color: presenter.getColor(by: category), lineLimit: 1)
                        }
                        Spacer()
                        RefdsText((budget - actual).formatted(.currency(code: "BRL")), color: budget - actual < 0 ? .pink : .secondary, weight: .bold)
                    }
                }
            }
        } header: {
            if !presenter.categories.isEmpty {
                RefdsText("restante", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private var sectionTotalDifference: some View {
        Section {
            HStack {
                RefdsText("Total das categorias")
                Spacer()
                RefdsText(
                    presenter.getTotalDifference().formatted(.currency(code: "BRL")),
                    color: presenter.getTotalDifference() <= 0 ? .pink : .accentColor,
                    weight: .bold,
                    family: .moderatMono,
                    lineLimit: 1
                )
            }
        } header: {
            if !presenter.categories.isEmpty {
                RefdsText("total restante", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private var sectionChartBudgetVsActualTitle: some View {
        Section { } footer: {
            RefdsText("Budget vs Atual", size: .large, weight: .bold, alignment: .center)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var sectionChartBudgetVsActual: some View {
        Section {
            if let chartData = presenter.getChartData(), !chartData.flatMap({ $0.data }).isEmpty {
                VStack(spacing: 10) {
                    Chart(chartData, id: \.label) { chartData in
                        ForEach(chartData.data, id: \.category) {
                            BarMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .foregroundStyle(by: .value("category", chartData.label))
                            .position(by: .value("category", chartData.label))
                        }
                    }
                    .chartLegend(position: .overlay, alignment: .top, spacing: -20)
                    .chartYAxis { AxisMarks(position: .leading) }
                    .frame(minHeight: 150)
                    .padding()
                    .padding(.top)
                    
                    Divider()
                    
                    Chart {
                        ForEach(chartData[0].data, id: \.category) {
                            LineMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(dash: [5, 10]))
                            .symbol(by: .value("category", chartData[0].label))
                            .symbolSize(30)
                            .foregroundStyle(by: .value("category", chartData[0].label))
                            .position(by: .value("category", chartData[0].label))
                        }
                        
                        ForEach(chartData[1].data, id: \.category) {
                            LineMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol(by: .value("category", chartData[1].label))
                            .symbolSize(30)
                            .foregroundStyle(by: .value("category", chartData[1].label))
                            .position(by: .value("category", chartData[1].label))
                            
                            AreaMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol(by: .value("category", chartData[1].label))
                            .symbolSize(30)
                            .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
                            .position(by: .value("category", chartData[1].label))
                        }
                    }
                    .chartLegend(position: .overlay, alignment: .top, spacing: -20)
                    .chartYAxis { AxisMarks(position: .leading) }
                    .frame(minHeight: 150)
                    .padding()
                    .padding(.top)
                }
            }
        }
    }
    
    private var buttonCalendar: some View {
        Button {  } label: {
            ZStack {
                DatePicker("", selection: Binding(get: { presenter.date }, set: { presenter.date = $0; presenter.loadData() }), displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .frame(width: 20, height: 20)
                    .clipped()
                SwiftUIWrapper {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.accentColor)
                        .bold()
                }.allowsHitTesting(false)
            }
        }
    }
}

struct BudgetScene_Previews: PreviewProvider {
    static var previews: some View {
        BudgetScene()
    }
}
