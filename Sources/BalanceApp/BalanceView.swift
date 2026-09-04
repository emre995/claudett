import SwiftUI

struct BalanceView: View {
    @State private var balance: Double = 0.10
    @State private var coins: Int = 0
    @State private var rewardsReceived: Double = 0.08
    @State private var balanceHidden: Bool = false
    @State private var showToast: Bool = false
    @State private var toastText: String = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.cyan.opacity(0.25), Color.pink.opacity(0.15), Color.pink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    header

                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Text("Estimated balance")
                                .foregroundStyle(.secondary)
                            Text("USD")
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Image(systemName: balanceHidden ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                                .onTapGesture {
                                    balanceHidden.toggle()
                                }
                        }
                        .font(.subheadline)

                        HStack(spacing: 8) {
                            Text(balanceHidden ? "••••" : String(format: "%.2f", balance))
                                .font(.system(size: 48, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            balance += Double.random(in: 0.01...0.05)
                        }
                    }
                    .padding(.top, 8)

                    coinsBar

                    transactionsRow

                    offerCard

                    quickActionsGrid

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
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
    }

    private var header: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.title3)
            Spacer()
            VStack(spacing: 2) {
                Text("Balance")
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text("Secure")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "gearshape")
                .font(.title3)
        }
        .padding(.top, 8)
    }

    private var coinsBar: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 22, height: 22)
                    .overlay(Text("¢").font(.caption2).bold())
                Text("Coins")
                    .foregroundStyle(.secondary)
                Text("\(coins)")
                    .fontWeight(.semibold)
            }

            Divider().frame(height: 16)

            Spacer()

            Button {
                withAnimation { coins += 50 }
                pulseToast("+50 coin eklendi")
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "gift.fill")
                    Text("Get Coins")
                    Image(systemName: "arrow.right")
                }
                .fontWeight(.medium)
            }
            .tint(.pink)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .background(.white.opacity(0.6))
        .clipShape(Capsule())
    }

    private var transactionsRow: some View {
        HStack {
            Text("Transactions")
                .fontWeight(.semibold)
            Spacer()
            Text("Rewards received: USD\(String(format: "%.2f", rewardsReceived))")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            rewardsReceived += 0.01
            pulseToast("Yeni ödül eklendi")
        }
    }

    private var offerCard: some View {
        VStack(spacing: 10) {
            HStack {
                HStack(spacing: 4) {
                    Text("First recharge offer")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 56, height: 56)
                    Image(systemName: "gift.fill")
                        .foregroundStyle(.white)
                        .font(.title3)
                }
            }
            HStack {
                Text("Get Gifts and bonus Coins")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            HStack(spacing: 4) {
                Capsule().fill(Color.black.opacity(0.6)).frame(width: 20, height: 6)
                Circle().fill(Color.gray.opacity(0.4)).frame(width: 6, height: 6)
                Spacer()
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            coins += 100
            pulseToast("Bonus: +100 coin")
        }
    }

    private var quickActionsGrid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        let items: [(String, String)] = [
            ("dollarsign.circle.fill", "LIVE rewards"),
            ("chart.bar.fill", "Monetization"),
            ("shield.fill", "Campaigns"),
            ("star.square.fill", "Subscriptions Manager")
        ]

        return LazyVGrid(columns: columns, spacing: 20) {
            ForEach(items, id: \.1) { item in
                Button {
                    pulseToast("\(item.1) açıldı (demo)")
                } label: {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.black)
                            .frame(width: 52, height: 52)
                            .overlay(
                                Image(systemName: item.0)
                                    .foregroundStyle(.white)
                                    .font(.title3)
                            )
                        Text(item.1)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func pulseToast(_ text: String) {
        toastText = text
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation { showToast = false }
        }
    }
}

#Preview {
    BalanceView()
}
