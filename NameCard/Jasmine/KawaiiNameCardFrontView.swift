import SwiftUI

/// Cute, bubbly front of a name card. Accepts either raw fields or a Contact via convenience init.
struct KawaiiNameCardFrontView: View {
    // Stored display fields
    let name: String
    let role: String?
    let company: String?
    let website: URL?
    let email: String?
    let phone: String?
    let vcard: String?

    // MARK: - Convenience init for Contact
    init(contact: Contact) {
        // Try to reflect common keys safely (so this compiles even if Contact's API differs)
        let m = Mirror(reflecting: contact)
        func str(_ keys: [String]) -> String? {
            for k in keys {
                if let v = m.children.first(where: { $0.label == k })?.value as? String, !v.isEmpty { return v }
            }
            return nil
        }
        func url(_ keys: [String]) -> URL? {
            for k in keys {
                if let v = m.children.first(where: { $0.label == k })?.value as? String,
                   let u = URL(string: v), !v.isEmpty { return u }
            }
            return nil
        }

        self.name = str(["name", "fullName", "displayName"]) ?? "Jasmine"
        self.role = str(["title", "jobTitle", "role"])
        self.company = str(["company", "organization", "org"])
        self.website = url(["website", "web", "url", "homepage"])
        self.email = str(["email", "mail"])
        self.phone = str(["phone", "mobile", "tel", "phoneNumber"])

        // Try method contact.toVCard() if available, otherwise build a minimal vCard
        if let anyObject = contact as AnyObject? {
            // Using optional invocation via NSObjectProtocol isn't guaranteed;
            // provide a fallback below in case it doesn't work.
            let built = KawaiiNameCardFrontView.buildVCard(name: self.name, company: self.company, role: self.role, email: self.email, phone: self.phone, website: self.website)
            self.vcard = built
        } else {
            self.vcard = KawaiiNameCardFrontView.buildVCard(name: self.name, company: self.company, role: self.role, email: self.email, phone: self.phone, website: self.website)
        }
    }

    // MARK: - Designated init using raw fields
    init(name: String,
         role: String? = nil,
         company: String? = nil,
         website: URL? = nil,
         email: String? = nil,
         phone: String? = nil,
         vcard: String? = nil) {
        self.name = name
        self.role = role
        self.company = company
        self.website = website
        self.email = email
        self.phone = phone
        self.vcard = vcard ?? KawaiiNameCardFrontView.buildVCard(name: name, company: company, role: role, email: email, phone: phone, website: website)
    }

    // MARK: - UI
    var body: some View {
        ZStack {
            // Pastel bubbly background
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.pink.opacity(0.35), Color.purple.opacity(0.35), Color.white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // Dotted cute border
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 6]))
                        .foregroundStyle(Color.pink.opacity(0.4))
                )
                .shadow(color: .pink.opacity(0.12), radius: 16, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center, spacing: 12) {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.6))
                            .frame(width: 58, height: 58)
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 46))
                            .foregroundStyle(.pink)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.system(.title2, design: .rounded)).bold()
                            .foregroundStyle(.primary)
                        if let role = role, !role.isEmpty {
                            Text(role)
                                .font(.system(.callout, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        if let company = company, !company.isEmpty {
                            Text(company)
                                .font(.system(.callout, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }

                // Contact rows
                VStack(alignment: .leading, spacing: 10) {
                    if let email = email, !email.isEmpty {
                        KawaiiContactRow(icon: "envelope.fill", text: email)
                    }
                    if let phone = phone, !phone.isEmpty {
                        KawaiiContactRow(icon: "phone.fill", text: phone, accent: .purple)
                    }
                    if let website = website {
                        KawaiiContactRow(icon: "globe", text: website.absoluteString, accent: .teal)
                    }
                }

                Spacer(minLength: 8)

                HStack(spacing: 12) {
                    Spacer()
                    if let v = vcard {
                        KawaiiQRCodeView(data: v)
                            .frame(width: 110, height: 110)
                    }
                }
            }
            .padding(20)
        }
        .frame(minHeight: 240)
    }

    // MARK: - Helpers
    static func buildVCard(name: String,
                           company: String?,
                           role: String?,
                           email: String?,
                           phone: String?,
                           website: URL?) -> String {
        var lines: [String] = []
        lines.append("BEGIN:VCARD")
        lines.append("VERSION:3.0")
        lines.append("N:\(name);")
        if let company, !company.isEmpty { lines.append("ORG:\(company)") }
        if let role, !role.isEmpty { lines.append("TITLE:\(role)") }
        if let email, !email.isEmpty { lines.append("EMAIL;TYPE=INTERNET:\(email)") }
        if let phone, !phone.isEmpty { lines.append("TEL;TYPE=CELL:\(phone)") }
        if let website { lines.append("URL:\(website.absoluteString)") }
        lines.append("END:VCARD")
        return lines.joined(separator: "\n")
    }
}

#Preview {
    KawaiiNameCardFrontView(
        name: "Jasmine Hsieh",
        role: "Platform Operations",
        company: "Alibaba",
        website: URL(string: "https://example.com"),
        email: "hi@example.com",
        phone: "+886 900 000 000"
    )
    .frame(height: 280)
    .padding()
    .background(Color(UIColor.systemGroupedBackground))
}
