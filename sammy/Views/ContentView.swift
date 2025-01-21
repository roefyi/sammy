import SwiftUI

struct ContentView: View {
    @State private var selectedProtein = "..."
    @State private var selectedSecondProtein: String?
    @State private var selectedSauce = "..."
    @State private var selectedAcid = "..."
    @State private var selectedVehicle = "..."
    @State private var showingShareSheet = false
    @State private var isAnimating = false
    @State private var showSecondProtein = false
    
    private let backgroundColor = Color(red: 0.98, green: 0.98, blue: 0.98)
    private let braunDark = Color(red: 0.13, green: 0.13, blue: 0.13)
    
    var recipe: SandwichRecipe {
        SandwichRecipe(
            protein: selectedProtein,
            secondProtein: selectedSecondProtein,
            sauce: selectedSauce,
            acid: selectedAcid,
            vehicle: selectedVehicle
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 24) {
                    // First Protein with Plus Button
                    VStack(spacing: 8) {
                        HStack {
                            Text("PROTEIN")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(braunDark.opacity(0.6))
                            
                            if !showSecondProtein {
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showSecondProtein = true
                                        selectedSecondProtein = "..."
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(braunDark)
                                        .font(.title2)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        FlipClockDigit(text: selectedProtein, isAnimating: isAnimating)
                    }
                    
                    // Second Protein (if enabled)
                    if showSecondProtein {
                        VStack(spacing: 8) {
                            HStack {
                                Text("PROTEIN 2")
                                    .font(.system(.subheadline, design: .monospaced))
                                    .foregroundColor(braunDark.opacity(0.6))
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showSecondProtein = false
                                        selectedSecondProtein = nil
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(braunDark)
                                        .font(.title2)
                                }
                                
                                Spacer()
                            }
                            
                            FlipClockDigit(text: selectedSecondProtein ?? "...", isAnimating: isAnimating)
                        }
                    }
                    
                    RecipeFlipView(title: "SAUCE", value: selectedSauce, isAnimating: isAnimating)
                    RecipeFlipView(title: "ACID", value: selectedAcid, isAnimating: isAnimating)
                    RecipeFlipView(title: "BREAD", value: selectedVehicle, isAnimating: isAnimating)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: generateRecipe) {
                    Text("GENERATE")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(braunDark)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(isAnimating)
            }
            .background(backgroundColor)
            .navigationTitle("Sammy")
            .toolbar {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(braunDark)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: [recipe.shareText])
            }
        }
    }
    
    private func generateRecipe() {
        isAnimating = true
        
        // Delay the actual selection to allow for animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            selectedProtein = IngredientData.proteins.randomElement() ?? "..."
            if showSecondProtein {
                // Ensure second protein is different from first
                var secondProtein: String
                repeat {
                    secondProtein = IngredientData.proteins.randomElement() ?? "..."
                } while secondProtein == selectedProtein
                selectedSecondProtein = secondProtein
            }
            selectedSauce = IngredientData.sauces.randomElement() ?? "..."
            selectedAcid = IngredientData.acids.randomElement() ?? "..."
            selectedVehicle = IngredientData.vehicles.randomElement() ?? "..."
            isAnimating = false
        }
    }
}

struct RecipeFlipView: View {
    let title: String
    let value: String
    let isAnimating: Bool
    
    private let braunDark = Color(red: 0.13, green: 0.13, blue: 0.13)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(braunDark.opacity(0.6))
            
            FlipClockDigit(text: value, isAnimating: isAnimating)
        }
    }
}

struct RecipeItemView: View {
    let title: String
    let value: String
    
    private let braunDark = Color(red: 0.13, green: 0.13, blue: 0.13)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(braunDark.opacity(0.6))
            
            Text(value)
                .font(.system(.title3, design: .monospaced))
                .foregroundColor(braunDark)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(8)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 