import SwiftUI
import RefdsUI
struct NumberAnimator: View {
    @State private var currentNumber = 0.0
    let finalNumber : Double
    let color: Color
    var body: some View {
        RefdsText(
            currentNumber.currency,
            size: .custom(40),
            color: color,
            weight: .bold,
            family: .moderatMono,
            alignment: .center,
            lineLimit: 1
        )
        .onAppear(){
            self.startAnimation()
        }
    }
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: finalNumber * 0.00000269, repeats: true) { timer in
            if self.currentNumber < self.finalNumber {
                self.currentNumber += Double.random(in: 4...5)
            }
            else {
                timer.invalidate()
            }
        }
    }
}
