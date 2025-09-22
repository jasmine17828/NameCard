import SwiftUI
import SafariServices

/// A cute rounded button that opens an in-app Safari view in a sheet.
struct CuteSafariButton: View {
    let title: String
    let url: URL
    var tint: Color = .pink

    @State private var show = false

    var body: some View {
        Button {
            show = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "safari.fill")
                Text(title)
            }
            .font(.system(.callout, design: .rounded).weight(.semibold))
            .padding(.horizontal, 14).padding(.vertical, 10)
            .background(
                Capsule().fill(tint.opacity(0.15))
            )
            .overlay(
                Capsule().strokeBorder(tint.opacity(0.35), lineWidth: 1.2)
            )
        }
        .tint(tint)
        .sheet(isPresented: $show) {
            CuteSafariView(url: url)
                .ignoresSafeArea()
        }
    }
}

// UIKit bridge (renamed to avoid colliding with other SafariView definitions)
struct CuteSafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController { SFSafariViewController(url: url) }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

#Preview {
    CuteSafariButton(title: "Open Website", url: URL(string: "https://example.com")!)
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
}
