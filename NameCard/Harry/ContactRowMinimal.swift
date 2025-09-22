// Deprecated duplicate of ContactRowMinimal — intentionally disabled to avoid redeclaration.
// If needed, remove this file from the build target (File Inspector ▸ Target Membership) or delete it.

import SwiftUI

struct ContactRowMinimal: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .regular))
            .foregroundColor(.gray)
            .tracking(0.5)
    }
}
