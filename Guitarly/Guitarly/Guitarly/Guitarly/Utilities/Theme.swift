import SwiftUI

enum Theme {
    // Dark base like Quranly
    static let background = Color(red: 0.05, green: 0.05, blue: 0.07)
    static let surface = Color(red: 0.10, green: 0.10, blue: 0.13)

    // Accent Quranly (purple) + Guitrly logo
    static let accentPurple = Color(red: 0.45, green: 0.32, blue: 0.98)
    static let accentBlue = Color(red: 0.28, green: 0.72, blue: 0.98)
    static let accentWarm = Color(red: 0.98, green: 0.55, blue: 0.26)

    static let cardCorner: CGFloat = 18
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Theme.background,
                Theme.background.opacity(0.95),
                Theme.accentPurple.opacity(0.15),
                Theme.accentWarm.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

extension View {
    func appCard(border: Color = .white.opacity(0.10)) -> some View {
        self
            .padding(14)
            .background(Theme.surface.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCorner, style: .continuous)
                    .stroke(border, lineWidth: 1)
            )
    }
}
