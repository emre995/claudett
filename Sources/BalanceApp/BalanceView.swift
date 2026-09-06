import SwiftUI
import UserNotifications

// MARK: - Colors
extension Color {
    static let brandAccent = Color(red: 254/255, green: 44/255, blue: 85/255)
    static let adaptiveCard = Color(.secondarySystemBackground)
    static let adaptiveBackground = Color(.systemBackground)
}

// MARK: - SVG TikTok Coin Icon
struct TikTokCoinIcon: View {
    var size: CGFloat = 18

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 255/255, green: 184/255, blue: 77/255))
            Circle()
                .fill(Color(red: 255/255, green: 222/255, blue: 85/255))
                .padding(size * 0.02)
            Circle()
                .fill(Color(red: 247/255, green: 163/255, blue: 0/255))
                .padding(size * 0.08)
            Circle()
                .fill(Color(red: 240/255, green: 146/255, blue: 7/255))
                .padding(size * 0.08)
            
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.723, y: w * 0.37))
                path.addCurve(
                    to: CGPoint(x: w * 0.602, y: w * 0.49),
                    control1: CGPoint(x: w * 0.723, y: w * 0.49),
                    control2: CGPoint(x: w * 0.675, y: w * 0.49)
                )
                path.addCurve(
                    to: CGPoint(x: w * 0.502, y: w * 0.41),
                    control1: CGPoint(x: w * 0.552, y: w * 0.49),
                    control2: CGPoint(x: w * 0.502, y: w * 0.45)
                )
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round))

            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.72, y: w * 0.37))
                path.addCurve(to: CGPoint(x: w * 0.60, y: w * 0.49), control1: CGPoint(x: w * 0.72, y: w * 0.45), control2: CGPoint(x: w * 0.65, y: w * 0.49))
                path.addCurve(to: CGPoint(x: w * 0.48, y: w * 0.38), control1: CGPoint(x: w * 0.54, y: w * 0.49), control2: CGPoint(x: w * 0.48, y: w * 0.44))
                path.addLines([
                    CGPoint(x: w * 0.48, y: w * 0.71),
                    CGPoint(x: w * 0.33, y: w * 0.71),
                    CGPoint(x: w * 0.33, y: w * 0.28),
                    CGPoint(x: w * 0.43, y: w * 0.28),
                    CGPoint(x: w * 0.43, y: w * 0.35),
                    CGPoint(x: w * 0.48, y: w * 0.35)
                ])
            }
            .fill(Color.white)
            .scaleEffect(0.65)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Notifications
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .list])
    }
}

func sendExchangeNotification(amount: Int, username: String) {
    let content = UNMutableNotificationContent()
    content.title = "Exchange completed"
    content.body = "You exchanged \(amount) credits with @\(username)"
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

// MARK: - Custom Numeric Keypad Sheet
struct CustomKeypadView: View {
    @Binding var amountText: String
    let maxCoins: Int
    var onDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Credit amount")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                Spacer()
                Button("All") {
                    amountText = "\(maxCoins)"
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.brandAccent)
                
                Button {
                    onDone()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .padding(.leading, 12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)

            HStack(spacing: 8) {
                TikTokCoinIcon(size: 24)
                Text(amountText.isEmpty ? "0" : amountText)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.adaptiveCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.brandAccent.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 16)

            HStack {
                let currentVal = Int(amountText) ?? 0
                let usdVal = Double(currentVal) * 0.014
                Text("Available to exchange: \(maxCoins) credits • $\(String(format: "%.2f", usdVal))")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)

            VStack(spacing: 10) {
                keypadRow(keys: ["1", "2", "3", "delete"])
                keypadRow(keys: ["4", "5", "6", "000"])
                keypadRow(keys: ["7", "8", "9", "0"])
            }
            .padding(.horizontal, 16)

            Button {
                onDone()
            } label: {
                Text("Done")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.brandAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color.adaptiveBackground)
    }

    private func keypadRow(keys: [String]) -> some View {
        HStack(spacing: 10) {
            ForEach(keys, id: \.self) { key in
                Button {
                    handleKeyPress(key)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.adaptiveCard)
                        
                        if key == "delete" {
                            Image(systemName: "delete.left.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.primary)
                        } else {
                            Text(key)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                    }
                    .frame(height: 52)
                }
            }
        }
    }

    private func handleKeyPress(_ key: String) {
        if key == "delete" {
            if !amountText.isEmpty {
                amountText.removeLast()
            }
        } else if key == "000" {
            if !amountText.isEmpty && amountText != "0" {
                let newVal = (Int(amountText) ?? 0) * 1000
                if newVal <= maxCoins {
                    amountText = "\(newVal)"
                }
            }
        } else {
            if amountText == "0" {
                amountText = key
            } else {
                let potentialText = amountText + key
                if let val = Int(potentialText), val <= maxCoins {
                    amountText = potentialText
                } else if Int(potentialText) == nil && potentialText.count <= 10 {
                    amountText = potentialText
                }
            }
        }
    }
}

// MARK: - Main Screen
struct BalanceView: View {
    @AppStorage("prefersDarkMode") private var prefersDarkMode: Bool = false

    @State private var balance: Double = 0.10
    @State private var coins: Int = 2888
    @State private var rewardsReceived: Double = 87598.45
    @State private var showSettings: Bool = false
    @State private var showExchangeSheet: Bool = false
    @State private var notificationDelegate = NotificationDelegate()

    var body: some View {
        ZStack {
            Color.adaptiveBackground.ignoresSafeArea()

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
        }
        .preferredColorScheme(prefersDarkMode ? .dark : .light)
        .onAppear {
            UNUserNotificationCenter.current().delegate = notificationDelegate
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                balance: $balance,
                coins: $coins,
                rewardsReceived: $rewardsReceived,
                prefersDarkMode: $prefersDarkMode
            )
            .preferredColorScheme(prefersDarkMode ? .dark : .light)
        }
        .sheet(isPresented: $showExchangeSheet) {
            ExchangeView(availableCoins: coins) { amount, username in
                coins -= amount
                sendExchangeNotification(amount: amount, username: username)
            }
            .preferredColorScheme(prefersDarkMode ? .dark : .light)
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.primary)

            Spacer()

            VStack(spacing: 2) {
                Text("Balance")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
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
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    private var balanceSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text("Estimated balance")
                    .foregroundStyle(.secondary)
                Text("USD")
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                Image(systemName: "eye")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 4)
            }
            .font(.system(size: 12))

            HStack(spacing: 6) {
                Text(String(format: "%.2f", balance))
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.primary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
            }

            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    TikTokCoinIcon(size: 18)
                    Text("Coins")
                        .foregroundStyle(.secondary)
                    Text("\(coins)")
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
                .font(.system(size: 12))

                Text("|").foregroundStyle(.secondary.opacity(0.4))

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
            .background(Color.adaptiveCard)
            .clipShape(Capsule())
            .padding(.top, 4)
        }
        .padding(.vertical, 16)
    }

    private var transactionsCard: some View {
        HStack {
            Text("Transactions")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Rewards received")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text("$\(String(format: "%.2f", rewardsReceived))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.brandAccent)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .padding(.leading, 6)
        }
        .padding(16)
        .background(Color.adaptiveCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(Color.brandAccent.opacity(0.2), lineWidth: 1)
        )
        .padding(.top, 4)
        .padding(.bottom, 10)
    }

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
                .background(Color.adaptiveCard)
                .foregroundStyle(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom, 20)
    }

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
                        .fill(Color.adaptiveCard)
                        .frame(width: 62, height: 62)
                        .overlay(
                            Image(systemName: item.0)
                                .foregroundStyle(.primary.opacity(0.8))
                                .font(.system(size: 24))
                        )
                    Text(item.1)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary.opacity(0.8))
                }
            }
        }
        .padding(16)
        .padding(.vertical, 8)
        .background(Color.adaptiveCard.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.bottom, 24)
    }
}

// MARK: - Exchange Screen
struct ExchangeView: View {
    let availableCoins: Int
    var onSent: (Int, String) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var searchText: String = "hadise"
    @State private var foundUsername: String? = "hadise"
    @State private var amountText: String = "2888"
    @State private var showConfirm: Bool = false
    @State private var didSend: Bool = false
    @State private var showCustomKeypad: Bool = false

    private let coinToUSDRate: Double = 0.014
    private let feeRate: Double = 0.009

    private var amountValue: Int { Int(amountText) ?? 0 }
    private var exchangeValue: Double { Double(amountValue) * coinToUSDRate }
    private var fee: Double { exchangeValue * feeRate }
    private var total: Double { exchangeValue + fee }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.adaptiveBackground.ignoresSafeArea()

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
                        Button("Cancel") { dismiss() }
                    }
                }
            }
            .alert("Complete exchange for \(amountValue) credits?", isPresented: $showConfirm) {
                Button("Go back", role: .cancel) {}
                Button("Complete") {
                    onSent(amountValue, foundUsername ?? "")
                    withAnimation { didSend = true }
                }
            } message: {
                Text("$\(String(format: "%.2f", total)) will be deducted from your available USD balance.")
            }
            .sheet(isPresented: $showCustomKeypad) {
                CustomKeypadView(amountText: $amountText, maxCoins: availableCoins) {
                    showCustomKeypad = false
                }
                .presentationDetents([.height(380)])
            }
        }
    }

    private var formView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Creator account")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    Text("@")
                        .foregroundStyle(.secondary)
                    TextField("username", text: $searchText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .foregroundStyle(.primary)
                }
                .padding(14)
                .background(Color.adaptiveCard)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Button {
                    if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                        foundUsername = searchText
                    }
                } label: {
                    Text("Search")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.brandAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if let foundUsername {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.brandAccent.opacity(0.15))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text(String(foundUsername.prefix(2)).uppercased())
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.brandAccent)
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text(foundUsername.capitalized)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.primary)
                            Text("@\(foundUsername)")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color.adaptiveCard)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Text("Credits to exchange")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.top, 6)

                    Button {
                        showCustomKeypad = true
                    } label: {
                        HStack {
                            TikTokCoinIcon(size: 22)
                            Text(amountText.isEmpty ? "0" : amountText)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("Max: \(availableCoins)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.brandAccent)
                        }
                        .padding(14)
                        .background(Color.adaptiveCard)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    if amountValue > 0 {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Exchange value")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("$\(String(format: "%.2f", exchangeValue))")
                                    .foregroundStyle(.primary)
                            }
                            HStack {
                                Text("Service fee (0.9%)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("$\(String(format: "%.2f", fee))")
                                    .foregroundStyle(.primary)
                            }
                            Divider()
                            HStack {
                                Text("Total")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("$\(String(format: "%.2f", total))")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.primary)
                        }
                        .font(.system(size: 13))
                        .padding(14)
                        .background(Color.adaptiveCard)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button {
                        guard amountValue > 0, amountValue <= availableCoins else { return }
                        showConfirm = true
                    } label: {
                        Text("Review exchange")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(amountValue > 0 && amountValue <= availableCoins ? Color.brandAccent : Color.gray.opacity(0.3))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(!(amountValue > 0 && amountValue <= availableCoins))
                    .padding(.top, 6)
                }
            }
            .padding(20)
        }
    }

    private var successView: some View {
        VStack(spacing: 18) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 96, height: 96)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.green)
            }

            Text("Exchange submitted")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.primary)

            VStack(spacing: 6) {
                Text("Transferred to")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Text("@\(foundUsername ?? "")")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                HStack(spacing: 6) {
                    TikTokCoinIcon(size: 14)
                    Text("\(amountValue) credits")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 2)
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.adaptiveCard)
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Settings Screen
struct SettingsView: View {
    @Binding var balance: Double
    @Binding var coins: Int
    @Binding var rewardsReceived: Double
    @Binding var prefersDarkMode: Bool

    @Environment(\.dismiss) private var dismiss

    @State private var balanceText: String = ""
    @State private var coinsText: String = ""
    @State private var rewardsText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $prefersDarkMode) {
                        Text("Light").tag(false)
                        Text("Dark").tag(true)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Balance") {
                    HStack {
                        Text("USD")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $balanceText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.primary)
                    }
                }

                Section("Coins") {
                    TextField("0", text: $coinsText)
                        .keyboardType(.numberPad)
                        .foregroundStyle(.primary)
                }

                Section("Rewards") {
                    HStack {
                        Text("Rewards received")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("0.00", text: $rewardsText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
