//
//  BudgetWidget.swift
//  BudgetWidget
//
//  Created by Rafael Santos on 13/03/23.
//

import WidgetKit
import SwiftUI
import RefdsUI
import Presentation
import Domain
import Intents
import UserInterface
import Charts

struct Provider: IntentTimelineProvider {
    static var presenter: WidgetPresenter = .shared
    
    func placeholder(in context: Context) -> CurrencyEntry {
        CurrencyEntry(
            date: .current,
            diff: Self.presenter.diff,
            totalBudget: Self.presenter.totalBudget,
            diffColor: Self.presenter.diffColor,
            totalActual: Self.presenter.totalActual,
            chartData: Self.presenter.chartData,
            categories: Self.presenter.categories,
            isEmpty: Self.presenter.isEmpty,
            isActive: Self.presenter.isActive
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CurrencyEntry) -> ()) {
        let entry = CurrencyEntry(
            date: .current,
            diff: Self.presenter.diff,
            totalBudget: Self.presenter.totalBudget,
            diffColor: Self.presenter.diffColor,
            totalActual: Self.presenter.totalActual,
            chartData: Self.presenter.chartData,
            categories: Self.presenter.categories,
            isEmpty: Self.presenter.isEmpty,
            isActive: Self.presenter.isActive
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [CurrencyEntry] = [
            CurrencyEntry(
                date: .current,
                diff: Self.presenter.diff,
                totalBudget: Self.presenter.totalBudget,
                diffColor: Self.presenter.diffColor,
                totalActual: Self.presenter.totalActual,
                chartData: Self.presenter.chartData,
                categories: Self.presenter.categories,
                isEmpty: Self.presenter.isEmpty,
                isActive: Self.presenter.isActive
            )
        ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct CurrencyEntry: TimelineEntry {
    var date: Date
    let diff: Double
    let totalBudget: Double
    let diffColor: Color
    let totalActual: Double
    let chartData: [ChartDataItem]
    let categories: [(color: Color, name: String, percent: Double, percentColor: Color)]
    let isEmpty: Bool
    let isActive: Bool
}

struct BudgetWidgetEntryView : View {
    @Environment(\.widgetFamily) var size
    private var presenter = WidgetPresenter.shared
    var entry: Provider.Entry
    
    public init(entry: Provider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        let diff = entry.diff
        let totalBudget = entry.totalBudget
        let diffColor = entry.diffColor
        let totalActual = entry.totalActual
        let chartData = entry.chartData
        let categories = entry.categories
        let isEmpty = entry.isEmpty
        let isActive = entry.isActive
        
        switch size {
        case .systemSmall: systemSmall(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor, isEmpty: isEmpty || !isActive)
        case .systemMedium: systemMedium(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor, chartData: chartData, isEmpty: isEmpty || !isActive)
        case .systemLarge: systemLarge(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor, chartData: chartData, categories: categories, isEmpty: isEmpty || !isActive)
        case .accessoryInline: accessoryInline(diff: diff, isEmpty: isEmpty || !isActive)
        case .accessoryRectangular: accessoryRectangular(diff: diff, totalBudget: totalBudget, totalActual: totalActual, isEmpty: isEmpty || !isActive)
        case .accessoryCircular: accessoryCircular(diff: diff, totalBudget: totalBudget, isEmpty: isEmpty || !isActive)
        default: HStack{}
        }
    }
    
    private var systemSmallEmpty: some View {
        ViewThatFits {
            VStack(alignment: .leading) {
                Label {
                    Text("Budget")
                        .font(.system(size: 18, weight: .bold))
                        .minimumScaleFactor(0.5)
                } icon: {
                    Image(systemName: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green)
                        .scaleEffect(1.3)
                }
                
                Spacer()
                Text(entry.isActive ? "Até o momento, nenhum orçamento para o mês de \(entry.date.asString(withDateFormat: .custom("MMMM"))) foi realizado." : "Tenha acesso a todos as funcionalidades, como: relatórios e recursos especiais.")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: {}) {
                    Text((entry.isActive ? "planejar" : "seja pro").uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 8)
                .background(Color.green)
                .cornerRadius(6)
            }
        }
    }

    private func systemSmall(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color, isEmpty: Bool) -> some View {
        ViewThatFits {
            if isEmpty {
                systemSmallEmpty
            } else {
                VStack(alignment: .leading) {
                    Label {
                        (
                            Text("Budget ") +
                            Text(entry.date.asString(withDateFormat: .custom("MMM")).capitalized)
                                .foregroundColor(.secondary)
                        )
                        .font(.system(size: 20, weight: .bold))
                        .minimumScaleFactor(0.5)
                    } icon: {
                        Image(systemName: "dollarsign.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(diffColor)
                            .scaleEffect(1.3)
                    }
                    
                    Spacer()
                    Text("valor atual".uppercased())
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    Text(totalActual.currency)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(diffColor)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(totalBudget.currency)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text("valor budget".uppercased())
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 5) {
                            Text(presenter.string(.diff).uppercased())
                                .font(.system(size: 10, weight: .bold))
                            Text("restante".uppercased())
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        ProgressView(value: totalActual, total: totalBudget)
                            .progressViewStyle(.linear)
                            .scaleEffect(1.5)
                            .tint(diffColor)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .padding()
    }
    
    private var systemMediumEmpty: some View {
        ViewThatFits {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack {
                        Image(systemName: "dollarsign.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                            .scaleEffect(1.5)
                        Text("Budget")
                            .font(.system(size: 17, weight: .bold))
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Button(action: {}) {
                            Text((entry.isActive ? "planejar" : "seja pro").uppercased())
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: 100)
                        .padding(.all, 8)
                        .background(Color.green)
                        .cornerRadius(6)
                    }
                }
                Spacer()
                Text(entry.isActive ? "Até o momento, nenhum orçamento para o mês de \(entry.date.asString(withDateFormat: .custom("MMMM"))) foi realizado. Clique aqui e comece seu mês planejando sua vida financeira." : "Para utilizar os widget é necessário ser PRO. Com isso, você terá acesso a todos os relatórios e diversos recursos especiais.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        }
    }
    
    private func systemMedium(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color, chartData: [ChartDataItem], isEmpty: Bool) -> some View {
        ViewThatFits {
            if isEmpty {
                systemMediumEmpty
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack {
                            Image(systemName: "dollarsign.square.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(diffColor)
                                .scaleEffect(1.5)
                            VStack(alignment: .leading) {
                                (
                                    Text("Budget ") +
                                    Text(entry.date.asString(withDateFormat: .custom("MMM")).capitalized)
                                        .foregroundColor(.secondary)
                                )
                                .font(.system(size: 17, weight: .bold))
                                Text(totalBudget.currency)
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }
                        ProgressView(value: totalActual, total: totalBudget) {
                            HStack(spacing: 5) {
                                Text(totalActual.currency)
                                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                                    .lineLimit(1)
                                
                                Spacer()
                                Text(String(format: "%02d", Int((totalActual * 100) / totalBudget)) + "%")
                                    .font(.system(size: 8.5))
                                
                            }
                        }
                        .scaleEffect(1.5)
                        .progressViewStyle(.linear)
                        .tint(diffColor)
                        .padding()
                        .padding(.horizontal, 15)
                        .padding(.leading, 3)
                    }
                    sectionChartBar(chartData: chartData, isLarge: false)
                }
                .padding()
            }
        }
    }
    
    private func systemLarge(
        diff: Double,
        totalBudget: Double,
        totalActual: Double,
        diffColor: Color,
        chartData: [ChartDataItem],
        categories: [(color: Color, name: String, percent: Double, percentColor: Color)]
        , isEmpty: Bool) -> some View {
        ViewThatFits {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack {
                        Image(systemName: "dollarsign.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(diffColor)
                            .scaleEffect(1.5)
                        VStack(alignment: .leading) {
                            (
                                Text("Budget ") +
                                Text(entry.date.asString(withDateFormat: .custom("MMM")).capitalized)
                                    .foregroundColor(.secondary)
                            )
                            .font(.system(size: 17, weight: .bold))
                            Text(totalBudget.currency)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                    ProgressView(value: totalActual, total: totalBudget) {
                        HStack(spacing: 5) {
                            Text(totalActual.currency)
                                .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                                .lineLimit(1)
                            
                            Spacer()
                            Text(String(format: "%02d", Int((totalActual * 100) / totalBudget)) + "%")
                                .font(.system(size: 8.5))
                            
                        }
                    }
                    .scaleEffect(1.5)
                    .progressViewStyle(.linear)
                    .tint(diffColor)
                    .padding()
                    .padding(.horizontal, 15)
                    .padding(.leading, 3)
                }
                
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 0) {
                                IndicatorPointView(color: category.color)
                                    .scaleEffect(0.5)
                                Text(category.name.capitalized)
                                    .font(.system(size: 12))
                                    .lineLimit(1)
                                Spacer()
                                Text(String(format: "%d", Int(category.percent)) + "%")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            ProgressView(value: category.percent, total: 100)
                                .scaleEffect(1.5)
                                .padding(.horizontal, 28)
                                .tint(category.percentColor)
                        }
                        
                    }
                }
                
                Spacer()
                
                sectionChartBar(chartData: chartData, isLarge: true)
            }
            .padding()
        }
    }
    
    private var accessoryRectangularEmpty: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "dollarsign.square.fill")
                    .symbolRenderingMode(.hierarchical)
                    .fontWeight(.bold)
                    .scaleEffect(1.2)
                Text("Budget")
                    .fontWeight(.bold)
            }
            
            Text(entry.isActive ? "Faça orçamento para \(entry.date.asString(withDateFormat: .custom("MMMM")))." : "Funcionalidade para usuário PRO.")
        }
    }
    
    private func accessoryRectangular(diff: Double, totalBudget: Double, totalActual: Double, isEmpty: Bool) -> some View {
        ViewThatFits {
            if isEmpty {
                accessoryRectangularEmpty
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "dollarsign.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .fontWeight(.bold)
                            .scaleEffect(1.2)
                        Text(presenter.string(.diff) + " Restante")
                            .fontWeight(.bold)
                    }
                    
                    ProgressView(value: totalActual, total: totalBudget)
                        .progressViewStyle(.linear)
                        .scaleEffect(1.5)
                        .padding(.horizontal, 25)
                    
                    HStack {
                        Text("Valor:")
                        Text((totalBudget - totalActual).currency)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var accessoryCircularEmpty: some View {
        Image(systemName: "dollarsign.square.fill")
            .symbolRenderingMode(.hierarchical)
            .scaleEffect(3.5)
    }
    
    private func accessoryCircular(diff: Double, totalBudget: Double, isEmpty: Bool) -> some View {
        ViewThatFits {
            if isEmpty {
                accessoryCircularEmpty
            } else {
                ProgressView(value: diff, total: totalBudget) {
                    Image(systemName: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .scaleEffect(0.9)
                }
                .progressViewStyle(.circular)
            }
        }
    }
    
    private var accessoryInlineEmpty: some View {
        ViewThatFits {
            Label {
                Text(entry.isActive ? "\(entry.date.asString(withDateFormat: .custom("MMMM")).capitalized) sem orçamento" : "Funcionalidade PRO")
            } icon: {
                Image(systemName: "dollarsign.square.fill")
                    .symbolRenderingMode(.hierarchical)
                     
            }
        }
    }
    
    private func accessoryInline(diff: Double, isEmpty: Bool) -> some View {
        ViewThatFits {
            if isEmpty {
                accessoryInlineEmpty
            } else {
                Label {
                    Text("Resta \((diff).currency)")
                } icon: {
                    Image(systemName: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .scaleEffect(1.1)
                }
            }
        }
    }
    
    private func sectionChartBar(chartData: [ChartDataItem], isLarge: Bool) -> some View {
        Chart(chartData, id: \.label) { chartData in
            ForEach(chartData.data, id: \.category) {
                BarMark(
                    x: .value(presenter.string(.category), String($0.category.prefix(3)) + "."),
                    y: .value(presenter.string(.value), $0.value)
                )
                .foregroundStyle(by: .value(presenter.string(.category), chartData.label))
                .position(by: .value(presenter.string(.category), chartData.label))
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.budget): Color.blue,
            presenter.string(.current): entry.diffColor
        ])
        .chartLegend(.hidden)
        .chartYAxis { AxisMarks(position: .trailing) }
        .frame(height: isLarge ? 150 : 90)
        .scaledToFill()
        .minimumScaleFactor(0.1)
        .frame(maxWidth: .infinity)
    }
}

struct BudgetWidget: Widget {
    let kind: String = "BudgetWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BudgetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Budget")
        .description("Acompanhe suas dispesas sabendo até quanto pode gastar")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryRectangular,
            .accessoryCircular,
            .accessoryInline,
        ])
    }
}

struct BudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entryView = BudgetWidgetEntryView(entry: .init(
            date: .current,
            diff: 9584.56 - 3510.05,
            totalBudget: 9584.56,
            diffColor: .teal,
            totalActual: 3510.05,
            chartData: [],
            categories: [],
            isEmpty: true,
            isActive: false
        ))
        
        entryView
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Accessory Rectangular")
        
        entryView
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Accessory Circular")
        
        entryView
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Accessory Inline")
        
        entryView
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("System Small")
        
        entryView
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("System Medium")
        
        entryView
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("System Large")
    }
}
