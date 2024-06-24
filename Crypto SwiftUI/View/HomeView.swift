import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var cryptoViewModel = CryptoViewModel()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.shadowColor = nil
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                   
                    Text("Top Earners")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                    
                    if !cryptoViewModel.crypto.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(cryptoViewModel.topEarners) { crypto in
                                    VStack {
                                        AsyncImage(url: URL(string: crypto.image)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(8)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(8)
                                            default:
                                                EmptyView()
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                        Text("\(crypto.symbol)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        if let changePercentage = crypto.priceChangePercentage24HInCurrency {
                                            let formattedPercentage = String(format: "%.2f%%", changePercentage)
                                            Text(formattedPercentage)
                                                .font(.subheadline)
                                                .foregroundColor(changePercentage >= 0 ? .green :  .red)
                                        } else {
                                            Text("N/A")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 150)
                    } else {
                        ProgressView()
                            .padding(.top, 20)
                    }
                    
                    Text("All Coins")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .foregroundColor(.blue)
                    
                    ForEach(cryptoViewModel.crypto) { crypto in
                        NavigationLink(destination: Text(crypto.name)) {
                            HStack {
                                AsyncImage(url: URL(string: crypto.image)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    default:
                                        EmptyView()
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(crypto.name)")
                                        .font(.headline)
                                    
                                    Text("\(crypto.symbol)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("$\(crypto.currentPrice, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    if let changePercentage = crypto.priceChangePercentage24HInCurrency {
                                        let formattedPercentage = String(format: "%.2f%%", changePercentage)
                                        Text(formattedPercentage)
                                            .font(.subheadline)
                                            .foregroundColor(changePercentage >= 0 ? .green : .red)
                                    } else {
                                        Text("N/A")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Live Prices")
            .onAppear {
                cryptoViewModel.fetchCryptos()
            }
        }
    }
}

#Preview {
    HomeView()
}

