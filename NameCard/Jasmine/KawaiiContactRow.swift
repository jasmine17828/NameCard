import SwiftUI

/// A cute, pastel pill-style contact row (non-conflicting with existing ContactRowMinimal)
struct KawaiiContactRow: View {
    let icon: String
    let text: String
    var accent: Color = Color.pink.opacity(0.8)

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.18))
                    .overlay(
                        Circle().stroke(accent.opacity(0.35), lineWidth: 1.2)
                    )
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(accent)
            }

            Text(text)
                .font(.system(.callout, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .lineLimit(1)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    Capsule().strokeBorder(accent.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: accent.opacity(0.15), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        KawaiiContactRow(icon: "envelope.fill", text: "hi@example.com")
        KawaiiContactRow(icon: "phone.fill", text: "+886 900 000 000", accent: .purple)
        KawaiiContactRow(icon: "globe", text: "example.com", accent: .teal)
    }
    .padding()
    .background(Color(UIColor.systemGroupedBackground))
}
