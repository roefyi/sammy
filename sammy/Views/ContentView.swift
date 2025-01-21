import SwiftUI

struct ContentView: View {
    @State private var selectedProtein = ""
    @State private var selectedSecondProtein: String?
    @State private var selectedSauce = ""
    @State private var selectedAcid = ""
    @State private var selectedVehicle = ""
    @State private var showingShareSheet = false
    @State private var isAnimatingProtein = false
    @State private var isAnimatingSecondProtein = false
    @State private var isAnimatingSauce = false
    @State private var isAnimatingAcid = false
    @State private var isAnimatingVehicle = false
    @State private var showSecondProtein = false
    
    private let backgroundColor = Color(red: 0.13, green: 0.13, blue: 0.13)  // Dark background
    private let textColor = Color(red: 0.95, green: 0.95, blue: 0.95)       // Light text
    private let accentColor = Color(red: 0.7, green: 0.7, blue: 0.7)        // Mid gray for secondary text
    
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
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 32) {
                        // First Protein with Plus Button
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("PROTEIN")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(accentColor)
                                
                                if !showSecondProtein {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            showSecondProtein = true
                                            selectedSecondProtein = ""
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(textColor)
                                            .font(.caption)
                                    }
                                }
                                Spacer()
                            }
                            
                            TappableFlipView(action: generateProtein) {
                                FlipClockDigit(text: selectedProtein, isAnimating: isAnimatingProtein)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(textColor)
                        }
                        
                        // Second Protein (if enabled)
                        if showSecondProtein {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("PROTEIN_2")
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(accentColor)
                                    
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            showSecondProtein = false
                                            selectedSecondProtein = nil
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(textColor)
                                            .font(.caption)
                                    }
                                    Spacer()
                                }
                                
                                TappableFlipView(action: generateSecondProtein) {
                                    FlipClockDigit(text: selectedSecondProtein ?? "", isAnimating: isAnimatingSecondProtein)
                                }
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(textColor)
                            }
                        }
                        
                        // Sauce
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SAUCE")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(accentColor)
                            
                            TappableFlipView(action: generateSauce) {
                                FlipClockDigit(text: selectedSauce, isAnimating: isAnimatingSauce)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(textColor)
                        }
                        
                        // Acid
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ACID")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(accentColor)
                            
                            TappableFlipView(action: generateAcid) {
                                FlipClockDigit(text: selectedAcid, isAnimating: isAnimatingAcid)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(textColor)
                        }
                        
                        // Vehicle
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BREAD")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(accentColor)
                            
                            TappableFlipView(action: generateVehicle) {
                                FlipClockDigit(text: selectedVehicle, isAnimating: isAnimatingVehicle)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(textColor)
                        }
                    }
                    .padding(.horizontal, 20)  // Extended padding to 20px
                    
                    Spacer()
                    
                    Button(action: generateAll) {
                        Text("GENERATE")
                            .font(.system(.headline, design: .monospaced))
                            .foregroundColor(backgroundColor)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(textColor)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)  // Extended padding to 20px
                    .padding(.bottom)
                    .disabled(isAnimatingAny)
                }
            }
            .navigationTitle("Sammy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(textColor)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: [recipe.shareText])
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var isAnimatingAny: Bool {
        isAnimatingProtein || isAnimatingSecondProtein || isAnimatingSauce || 
        isAnimatingAcid || isAnimatingVehicle
    }
    
    private func generateProtein() {
        selectedProtein = " " // Add a space to prevent empty string
        isAnimatingProtein = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            selectedProtein = IngredientData.proteins.randomElement() ?? ""
            isAnimatingProtein = false
        }
    }
    
    private func generateSecondProtein() {
        selectedSecondProtein = " "
        isAnimatingSecondProtein = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            var protein: String
            repeat {
                protein = IngredientData.proteins.randomElement() ?? ""
            } while protein == selectedProtein
            selectedSecondProtein = protein
            isAnimatingSecondProtein = false
        }
    }
    
    private func generateSauce() {
        selectedSauce = " " // Add a space to prevent empty string
        isAnimatingSauce = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            selectedSauce = IngredientData.sauces.randomElement() ?? ""
            isAnimatingSauce = false
        }
    }
    
    private func generateAcid() {
        selectedAcid = " " // Add a space to prevent empty string
        isAnimatingAcid = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            selectedAcid = IngredientData.acids.randomElement() ?? ""
            isAnimatingAcid = false
        }
    }
    
    private func generateVehicle() {
        selectedVehicle = " " // Add a space to prevent empty string
        isAnimatingVehicle = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            selectedVehicle = IngredientData.vehicles.randomElement() ?? ""
            isAnimatingVehicle = false
        }
    }
    
    private func generateAll() {
        generateProtein()
        if showSecondProtein {
            generateSecondProtein()
        }
        generateSauce()
        generateAcid()
        generateVehicle()
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

struct TappableFlipView<Content: View>: View {
    let action: () -> Void
    let content: Content
    @State private var isPressed = false
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            action()
        }) {
            content
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .opacity(isPressed ? 0.6 : 1.0)
        }
    }
} 
