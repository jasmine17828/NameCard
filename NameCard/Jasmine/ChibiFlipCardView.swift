import SwiftUI

/// A flipping card container (cute style) that can host front/back content.
struct ChibiFlipCardView<Front: View, Back: View>: View {
    @State private var flipped = false
    var front: Front
    var back: Back

    init(@ViewBuilder front: () -> Front,
         @ViewBuilder back: () -> Back) {
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            front
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            back
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(.degrees(flipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 18, x: 0, y: 8)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.55, blendDuration: 0.2)) {
                flipped.toggle()
            }
        }
    }
}

#Preview {
    ChibiFlipCardView {
        KawaiiNameCardFrontView(
            name: "Jasmine Hsieh", role: "Ops", company: "Alibaba",
            website: URL(string: "https://example.com"),
            email: "hi@example.com", phone: "+886 900 000 000"
        )
    } back: {
        KawaiiNameCardBackView(vcard: KawaiiNameCardFrontView.buildVCard(
            name: "Jasmine Hsieh",
            company: "Alibaba",
            role: "Ops",
            email: "hi@example.com",
            phone: "+886 900 000 000",
            website: URL(string: "https://example.com")
        ))
    }
    .frame(height: 300)
    .padding()
    .background(Color(UIColor.systemGroupedBackground))
}
