import SwiftUI

struct FlipClockDigit: View {
    let text: String
    let isAnimating: Bool
    
    private let braunDark = Color(red: 0.13, green: 0.13, blue: 0.13)
    private let braunLight = Color(red: 0.95, green: 0.95, blue: 0.95)
    
    @State private var rotation: Double = 0
    @State private var dotOpacities: [Double] = [1, 0.3, 0.3]
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            // Background frame
            RoundedRectangle(cornerRadius: 4)
                .fill(braunDark)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(braunDark, lineWidth: 1)
                )
            
            if isAnimating {
                // Loading dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(braunLight)
                            .frame(width: 8, height: 8)
                            .opacity(dotOpacities[index])
                    }
                }
            } else {
                // Content
                Text(text)
                    .font(.system(.title2, design: .monospaced))
                    .foregroundColor(braunLight)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            }
        }
        .frame(height: 60)
        .onChange(of: isAnimating) { newValue in
            if newValue {
                startDotAnimation()
            } else {
                stopDotAnimation()
            }
        }
    }
    
    private func startDotAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                dotOpacities.rotate()
            }
        }
    }
    
    private func stopDotAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        dotOpacities = [1, 0.3, 0.3]
    }
}

extension Array {
    mutating func rotate() {
        guard count > 0 else { return }
        let lastElement = self[count - 1]
        for i in (1..<count).reversed() {
            self[i] = self[i - 1]
        }
        self[0] = lastElement
    }
} 