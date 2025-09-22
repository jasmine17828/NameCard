import SwiftUI
import CoreImage.CIFilterBuiltins

/// A rounded, cute QR code view with a tiny heart badge in the middle.
struct KawaiiQRCodeView: View {
    let data: String
    var cornerRadius: CGFloat = 16

    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)

            if let img = makeQRCode(from: data) {
                Image(uiImage: img)
                    .interpolation(.none)      // keep sharp
                    .resizable()
                    .scaledToFit()
                    .padding(14)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius - 2, style: .continuous))
            } else {
                // Fallback
                Image(systemName: "qrcode")
                    .font(.system(size: 34))
                    .foregroundStyle(.secondary)
                    .padding(24)
            }

            // Cute heart badge overlay
            Circle()
                .fill(.white)
                .frame(width: 28, height: 28)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.pink)
                )
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
        }
        .accessibilityLabel("QR code")
    }

    private func makeQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.correctionLevel = "Q" // good balance

        guard let outputImage = qrFilter.outputImage else { return nil }
        // scale up for clarity
        let transform = CGAffineTransform(scaleX: 8, y: 8)
        let scaled = outputImage.transformed(by: transform)

        if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}

#Preview {
    KawaiiQRCodeView(data: "BEGIN:VCARD\nN:Chat;GPT;;;\nTEL;CELL:+886-900-000-000\nEMAIL:hi@example.com\nURL:https://example.com\nEND:VCARD")
        .frame(width: 180, height: 180)
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
}
