import SwiftUI

// MARK: - Renkler (HTML tasarımıyla uyumlu)
extension Color {
    static let brandAccent = Color(red: 254/255, green: 44/255, blue: 85/255) // #FE2C55
    static let cardGradientStart = Color(red: 235/255, green: 243/255, blue: 255/255) // #EBF3FF
    static let cardGradientMid = Color(red: 248/255, green: 249/255, blue: 250/255)   // #F8F9FA
    static let cardGradientEnd = Color(red: 255/255, green: 239/255, blue: 241/255)   // #FFEFF1
    static let gridBackground = Color(red: 249/255, green: 250/255, blue: 251/255)    // gray-50
    static let softButtonGray = Color(red: 241/255, green: 241/255, blue: 242/255)    // #F1F1F2
}

// MARK: - Ana Ekran
struct BalanceView: View {
    @State private var balance: Double = 0.10
    @State private var coins: Int = 0
    @State private var rewardsReceived: Double = 87598.45
    @State private var showToast: Bool = false
    @State private var toastText: String = ""
    @State private var showSettings: Bool = false

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
                    Text(toastText)
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.black.opacity(0.8))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .padding(.bottom, 40)
                }
                .transition(.opacity)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                balance: $balance,
                coins: $coins,
                rewardsReceived: $rewardsReceived
            )
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
                    ZStack {
                        Circle()
                            .fill(Color(red: 247/255, green: 168/255, blue: 15/255))
                            .frame(width: 18, height: 18)
                        Text("¢")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Text("Coins")
                        .foregroundStyle(.gray)
                    Text("\(coins)")
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .font(.system(size: 12))

                Text("|").foregroundStyle(.gray.opacity(0.4))

                Button {
                    withAnimation { coins += 50 }
                    pulseToast("+50 coin eklendi")
                } label: {
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
        .onTapGesture {
            balance += Double.random(in: 0.01...0.05)
        }
    }

    // MARK: Transactions kartı (tutarlı gradient)
    private var transactionsCard: some View {
        HStack {
            Text("Transactions")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)

            Spacer()

            HStack(spacing: 5) {
                Text("Rewards received:")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                Text("$\(String(format: "%.2f", rewardsReceived))")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.black.opacity(0.75))
                Circle()
                    .fill(Color.brandAccent)
                    .frame(width: 6, height: 6)
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color.cardGradientStart, Color.cardGradientMid, Color.cardGradientEnd],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.08), lineWidth: 1)
        )
        .padding(.top, 4)
        .padding(.bottom, 10)
        .onTapGesture {
            rewardsReceived += 1.5
            pulseToast("Yeni ödül eklendi")
        }
    }

    // MARK: Exchange / Withdraw
    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button {
                pulseToast("Exchange açıldı (demo)")
            } label: {
                Text("Exchange")
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.brandAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                pulseToast("Withdraw açıldı (demo)")
            } label: {
                Text("Withdraw")
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.softButtonGray)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
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

        return LazyVGrid(columns: columns, spacing: 22) {
            ForEach(items, id: \.1) { item in
                Button {
                    pulseToast("\(item.1.replacingOccurrences(of: "\n", with: " ")) açıldı (demo)")
                } label: {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: item.0)
                                    .foregroundStyle(.black.opacity(0.75))
                                    .font(.system(size: 16))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.04), radius: 3, y: 2)
                        Text(item.1)
                            .font(.system(size: 11))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black.opacity(0.75))
                    }
                }
            }
        }
        .padding(16)
        .padding(.vertical, 8)
        .background(Color.gridBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.bottom, 24)
    }

    private func pulseToast(_ text: String) {
        toastText = text
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation { showToast = false }
        }
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
