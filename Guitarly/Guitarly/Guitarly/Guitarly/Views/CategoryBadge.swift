import SwiftUI

struct CategoryBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Theme.accentPurple.opacity(0.18))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
    }
}

#Preview {
    CategoryBadge(text: "Technique")
        .padding()
        .background(Theme.background)
        .preferredColorScheme(.dark)
}
