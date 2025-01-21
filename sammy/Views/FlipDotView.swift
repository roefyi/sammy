import SwiftUI

struct FlipDotView: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String
    
    private let braunColors = [
        Color(red: 0.95, green: 0.95, blue: 0.95), // Light gray
        Color(red: 0.13, green: 0.13, blue: 0.13)  // Dark gray
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(braunColors[1])
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedOption = option
                            }
                        }) {
                            Text(option)
                                .font(.system(.subheadline, design: .monospaced))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedOption == option ? braunColors[1] : braunColors[0])
                                .foregroundColor(selectedOption == option ? braunColors[0] : braunColors[1])
                                .cornerRadius(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(braunColors[1], lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
} 