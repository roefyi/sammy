struct SandwichRecipe: Codable {
    let protein: String
    let secondProtein: String?
    let sauce: String
    let acid: String
    let vehicle: String
    
    var shareText: String {
        var text = """
        🥪 My FlipDot Sandwich Recipe:
        
        Protein: \(protein)
        """
        
        if let secondProtein = secondProtein {
            text += "\nProtein 2: \(secondProtein)"
        }
        
        text += """
        
        Sauce: \(sauce)
        Acid: \(acid)
        Bread: \(vehicle)
        """
        
        return text
    }
} 