//
//  OnboardingView.swift
//  
//
//  Created by Rafael Santos on 18/03/23.
//

import SwiftUI
import RefdsUI
import Resource

public struct OnboardingViewData {
    public var image: ResourceImage
    public var title: String
    public var description: String
    
    public init(image: ResourceImage, title: String, description: String) {
        self.image = image
        self.title = title
        self.description = description
    }
}

public struct OnboardingView: View {
    private var viewData: [OnboardingViewData]
    
    public init(viewData: [OnboardingViewData]) {
        self.viewData = viewData
    }
    
    public var body: some View {
        GeometryReader { proxy in
            TabView {
                ForEach(viewData.indices, id: \.self) { index in
                    let data = viewData[index]
                    let textAlignment: TextAlignment = index % 2 == 0 ? .leading : .trailing
                    VStack(alignment: index % 2 == 0 ? .leading : .trailing, spacing: 10) {
                        Spacer()
                        RefdsText(data.title, size: .custom(28), weight: .bold, alignment: textAlignment)
                        data.image.image
                            .resizable()
                            .scaledToFit()
                            .frame(height: proxy.size.height * 0.4)
                        RefdsText(data.description, color: .secondary, alignment: textAlignment)
                        Spacer()

                    }
                    .padding()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewData: [
            .init(
                image: .categoriesOnboarding,
                title: "Categorias",
                description: "Organize suas despesas por categorias e acompanhe o quanto está gastando em cada uma delas."
            ),
            .init(
                image: .transactionsOnboarding,
                title: "Transações",
                description: "Adicione dispesas de forma rápida e intuitiva. Filtre as informações de um jeito simples."
            )
        ])
    }
}
