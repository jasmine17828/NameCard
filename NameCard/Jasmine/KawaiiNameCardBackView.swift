import SwiftUI

/// Cute back of the name card with friendly messaging and QR.
struct KawaiiNameCardBackView: View {
    let vcard: String
    var tagline: String = "Let's be friends!"
    var note: String = "Scan the QR to connect ✨"

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    RadialGradient(colors: [Color.white, Color.pink.opacity(0.25), Color.purple.opacity(0.15)],
                                   center: .topLeading, startRadius: 20, endRadius: 400)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(Color.pink.opacity(0.25), style: StrokeStyle(lineWidth: 2, dash: [4, 6]))
                )

            VStack(spacing: 16) {
                Text(tagline)
                    .font(.system(.title3, design: .rounded)).bold()
                    .foregroundStyle(.primary)

                KawaiiQRCodeView(data: vcard)
                    .frame(width: 160, height: 160)

                Text(note)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                    Image(systemName: "sparkles")
                    Image(systemName: "hand.wave.fill")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.pink)
            }
            .padding(24)
        }
        .frame(minHeight: 240)
    }
}

#Preview {
    KawaiiNameCardBackView(
        vcard: "BEGIN:VCARD\nN:Jasmine;;;;\nEMAIL:hi@example.com\nEND:VCARD"
    )
    .frame(height: 280)
    .padding()
    .background(Color(UIColor.systemGroupedBackground))
}
