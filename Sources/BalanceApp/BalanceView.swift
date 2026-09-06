import SwiftUI

// MARK: - Renkler
extension Color {
    static let brandAccent = Color(red: 254/255, green: 44/255, blue: 85/255) // #FE2C55
    static let gridBackground = Color(red: 249/255, green: 250/255, blue: 251/255)
    static let softButtonGray = Color(red: 241/255, green: 241/255, blue: 242/255)
    static let cardBackground = Color(red: 250/255, green: 246/255, blue: 247/255)
}

// MARK: - Özgün Coin İkonu
struct CoinIcon: View {
    var size: CGFloat = 18

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 255/255, green: 200/255, blue: 87/255),
                                 Color(red: 247/255, green: 148/255, blue: 15/255)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            Circle()
                .stroke(Color.white.opacity(0.6), lineWidth: size * 0.04)
                .padding(size * 0.08)
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.32, y: w * 0.28))
                path.addCurve(
                    to: CGPoint(x: w * 0.68, y: w * 0.42),
                    control1: CGPoint(x: w * 0.5, y: w * 0.18),
                    control2: CGPoint(x: w * 0.68, y: w * 0.3)
                )
                path.addCurve(
                    to: CGPoint(x: w * 0.32, y: w * 0.72),
                    control1: CGPoint(x: w * 0.68, y: w * 0.62),
                    control2: CGPoint(x: w * 0.5, y: w * 0.8)
                )
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: size * 0.11, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Ana Ekran
struct BalanceView: View {
    @State private var balance: Double = 0.10
    @State private var coins: Int = 0
    @State private var rewardsReceived: Double = 87598.45
    @State private var showSettings: Bool = false
    @State private var showExchangeSheet: Bool = false
    @State private var showToast: Bool = false
    @State private var toastText: String = ""

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(spacing: 0) {
                        balanceSection
                        transactionsCard
                        actionButtons
                        quickActionsGrid
                    }
                    .padding(.horizontal, 16)
                }
            }

            if showToast {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                        Text(toastText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.85))
                    .clipShape(Capsule())
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                balance: $balance,
                coins: $coins,
                rewardsReceived: $rewardsReceived
            )
        }
        .sheet(isPresented: $showExchangeSheet) {
            ExchangeView(availableCoins: coins) { amount, username in
                coins -= amount
                showExchangeSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    toastText = "Exchanged \(amount) coins to @\(username)"
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        withAnimation { showToast = false }
                    }
                }
            }
        }
    }

    // MARK: Header
    private var header: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.black)

            Spacer()

            VStack(spacing: 2) {
                Text("Balance")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 10))
                    Text("Secure")
                        .font(.system(size: 11))
                }
                .foregroundStyle(Color(red: 5/255, green: 150/255, blue: 105/255))
            }

            Spacer()

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    // MARK: Bakiye alanı
    private var balanceSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("Estimated balance")
                    .foregroundStyle(.gray)
                Text("USD")
                    .foregroundStyle(.gray.opacity(0.8))
                Image(systemName: "chevron.down")
                    .font(.system(size: 9))
                    .foregroundStyle(.gray)
                Image(systemName: "eye")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .padding(.leading, 4)
            }
            .font(.system(size: 12))

            HStack(spacing: 6) {
                Text(String(format: "%.2f", balance))
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.black)
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
            }

            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    CoinIcon(size: 18)
                    Text("Coins")
                        .foregroundStyle(.gray)
                    Text("\(coins)")
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .font(.system(size: 12))

                Text("|").foregroundStyle(.gray.opacity(0.4))

                HStack(spacing: 4) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 11))
                    Text("Get Coins")
                    Image(systemName: "chevron.right")
                        .font(.system(size: 8))
                }
                .font(.system(size: 12))
                .foregroundStyle(Color.brandAccent)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.gridBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .padding(.top, 4)
        }
        .padding(.vertical, 16)
    }

    // MARK: Transactions kartı
    private var transactionsCard: some View {
        HStack {
            Text("Transactions")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.black)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Rewards received")
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                Text("$\(String(format: "%.2f", rewardsReceived))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandAccent)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.leading, 6)
        }
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(Color.brandAccent.opacity(0.15), lineWidth: 1)
        )
        .padding(.top, 4)
        .padding(.bottom, 10)
    }

    // MARK: Exchange / Withdraw
    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button {
                showExchangeSheet = true
            } label: {
                Text("Exchange")
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.brandAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Text("Withdraw")
                .font(.system(size: 14))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Color.softButtonGray)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom, 20)
    }

    // MARK: Grid menü
    private var quickActionsGrid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        let items: [(String, String)] = [
            ("dollarsign.circle.fill", "LIVE rewards"),
            ("chart.bar.fill", "Monetization"),
            ("star.fill", "Campaigns"),
            ("calendar.badge.checkmark", "Subscriptions\nManager")
        ]

        return LazyVGrid(columns: columns, spacing: 24) {
            ForEach(items, id: \.1) { item in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .frame(width: 62, height: 62)
                        .overlay(
                            Image(systemName: item.0)
                                .foregroundStyle(.black.opacity(0.75))
                                .font(.system(size: 24))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.04), radius: 3, y: 2)
                    Text(item.1)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black.opacity(0.75))
                }
            }
        }
        .padding(16)
        .padding(.vertical, 8)
        .background(Color.gridBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.bottom, 24)
    }
}

// MARK: - Exchange Ekranı
struct ExchangeView: View {
    let availableCoins: Int
    var onSent: (Int, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var amountText: String = ""
    @State private var username: String = ""
    @State private var errorText: String? = nil
    @State private var didSend: Bool = false
    @FocusState private var focusedField: Field?

    enum Field { case amount, username }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                if didSend {
                    successView
                } else {
                    formView
                }
            }
            .navigationTitle("Exchange")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !didSend {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("İptal") { dismiss() }
                    }
                }
            }
        }
    }

    private var formView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                CoinIcon(size: 40)
                Text("\(availableCoins) coin mevcut")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }
            .padding(.top, 16)

            VStack(alignment: .leading, spacing: 10) {
                Text("Miktar (coin)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.gray)

                HStack {
                    CoinIcon(size: 20)
                    TextField("0", text: $amountText)
                        .keyboardType(.numberPad)
                        .font(.system(size: 20, weight: .semibold))
                        .focused($focusedField, equals: .amount)
                }
                .padding(14)
                .background(Color.gridBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(focusedField == .amount ? Color.brandAccent : Color.gray.opacity(0.15), lineWidth: 1.5)
                )

                Text("Kullanıcı adı")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.gray)
                    .padding(.top, 6)

                HStack(spacing: 4) {
                    Text("@")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.gray)
                    TextField("kullaniciadi", text: $username)
                        .font(.system(size: 16))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .username)
                }
                .padding(14)
                .background(Color.gridBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(focusedField == .username ? Color.brandAccent : Color.gray.opacity(0.15), lineWidth: 1.5)
                )

                if let errorText {
                    Text(errorText)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.brandAccent)
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            Button {
                send()
            } label: {
                Text("Gönder")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.brandAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    private var successView: some View {
        VStack(spacing: 18) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.brandAccent.opacity(0.12))
                    .frame(width: 88, height: 88)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.brandAccent)
            }

            Text("Gönderildi")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.black)

            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    CoinIcon(size: 16)
                    Text("\(amountText) coin")
                        .font(.system(size: 14, weight: .medium))
                }
                Text("@\(username) adresine gönderildi")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Tamam")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.softButtonGray)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    private func send() {
        guard let amount = Int(amountText), amount > 0 else {
            errorText = "Geçerli bir miktar gir"
            return
        }
        guard amount <= availableCoins else {
            errorText = "Yetersiz coin"
            return
        }
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorText = "Kullanıcı adı gir"
            return
        }
        errorText = nil
        withAnimation { didSend = true }
        onSent(amount, username)
    }
}

// MARK: - Ayarlar Ekranı
struct SettingsView: View {
    @Binding var balance: Double
    @Binding var coins: Int
    @Binding var rewardsReceived: Double

    @Environment(\.dismiss) private var dismiss

    @State private var balanceText: String = ""
    @State private var coinsText: String = ""
    @State private var rewardsText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Bakiye") {
                    HStack {
                        Text("USD")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $balanceText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Coins") {
                    TextField("0", text: $coinsText)
                        .keyboardType(.numberPad)
                }

                Section("Ödüller") {
                    HStack {
                        Text("Rewards received")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("0.00", text: $rewardsText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        balance = Double(balanceText) ?? balance
                        coins = Int(coinsText) ?? coins
                        rewardsReceived = Double(rewardsText) ?? rewardsReceived
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                balanceText = String(format: "%.2f", balance)
                coinsText = String(coins)
                rewardsText = String(format: "%.2f", rewardsReceived)
            }
        }
    }
}

#Preview {
    BalanceView()
}
