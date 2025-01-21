import SwiftUI

struct FlipClockDigit: View {
    let text: String
    let isAnimating: Bool
    
    private let braunDark = Color(red: 0.13, green: 0.13, blue: 0.13)
    private let braunLight = Color(red: 0.95, green: 0.95, blue: 0.95)
    
    @State private var displayText = ""
    @State private var showCursor = true
    @State private var cursorTimer: Timer?
    @State private var typeTimer: Timer?
    @State private var currentIndex = 0
    
    // Typing characteristics
    private let baseTypingSpeed: TimeInterval = 0.15
    private let speedVariation: TimeInterval = 0.08
    private let pauseChance: Double = 0.2
    private let pauseDuration: TimeInterval = 0.35
    private let totalAnimationTime: TimeInterval = 2.2 // Total time for animation
    
    var body: some View {
        HStack(spacing: 0) {
            Text(displayText)
                .font(.system(.title3, design: .monospaced))
                .foregroundColor(braunLight)
            
            if isAnimating {
                Text(showCursor ? "█" : " ")
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(braunLight)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: isAnimating) { newValue in
            if newValue {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }
    
    private func startAnimation() {
        displayText = ""
        currentIndex = 0
        showCursor = true
        
        // Calculate timing for each character
        let textLength = text.count
        let timePerChar = (totalAnimationTime - 0.8) / Double(textLength) // Subtract initial delay
        
        // Start cursor blink
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                showCursor.toggle()
            }
        }
        
        // Wait for 0.8 second before starting to type
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            typeNextCharacter(timePerChar: timePerChar)
        }
    }
    
    private func typeNextCharacter(timePerChar: TimeInterval) {
        guard currentIndex < text.count else {
            finishTyping()
            return
        }
        
        let index = text.index(text.startIndex, offsetBy: currentIndex)
        displayText += String(text[index])
        currentIndex += 1
        
        // Calculate next delay to maintain consistent total time
        let randomVariation = Double.random(in: -speedVariation/2...speedVariation/2)
        let nextTypeDelay = timePerChar + randomVariation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + nextTypeDelay) {
            typeNextCharacter(timePerChar: timePerChar)
        }
    }
    
    private func finishTyping() {
        // Keep cursor blinking for a moment after typing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            stopAnimation()
        }
    }
    
    private func stopAnimation() {
        cursorTimer?.invalidate()
        cursorTimer = nil
        typeTimer?.invalidate()
        typeTimer = nil
        
        withAnimation {
            displayText = text
            showCursor = false
        }
    }
} 

