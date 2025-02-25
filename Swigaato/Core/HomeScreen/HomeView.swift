////
////  HomeView.swift
////  FigmaToSwiftUI
////
////  Created by Tech Exactly iPhone 6 on 30/01/25.


import SwiftUI

// MARK: - Home View
struct HomeView: View {
    // MARK: - Properties
    @StateObject private var orderViewModel = OrderViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @State private var isMenuOpen: Bool = false
    @State private var searchText: String = ""
    @State private var selectedItems: Set<UUID> = []
    @State private var navigateToLogin: Bool = false
    @State private var showCart: Bool = false
    @State private var selectedFood: FoodModel?
    @State private var itemCounts: [UUID: Int] = [:]
    
    @StateObject private var locationManager = LocationManager()
    
    let foodItems = FoodData.foodItems
    
    // MARK: - Computed Properties
    var filteredItems: [FoodModel] {
        if searchText.isEmpty {
            return foodItems
        } else {
            return foodItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var selectedFoodItems: [FoodModel] {
        foodItems.filter { selectedItems.contains($0.id) }
    }
    
    
    
    // Add new properties
        @State private var selectedCategory: String? = nil
        @State private var showLocationPicker = false
        
        // Add reference to sample data
        let categories = CategoryData.categories
        let restaurants = RestaurantData.restaurants
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // MARK: - Header
                    HStack {
                        // Menu Button
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                                isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Orders Button
                        NavigationLink(destination: OrdersListView()) {
                            Image(systemName: "clock.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                        .padding(.trailing, 10)
                        
                        // Profile Button
                        NavigationLink(destination: ProfileManagementView()) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                        .padding(.trailing, 10)
                        
                        // Cart Button
                        Button(action: {
                            showCart = true
                        }) {
                            ZStack {
                                Image(systemName: "cart.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                                
                                if !selectedItems.isEmpty {
                                    Text("\(selectedItems.count)")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                        .padding(.trailing, 20)
                    }
                    
                    // MARK: - Location Picker
                    Button(action: { showLocationPicker = true }) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.black)
                            Text(locationManager.locationString)
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // MARK: - Search Bar
                    ZStack(alignment: .trailing) {
                        TextField("Search food...", text: $searchText)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // MARK: - Categories
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(categories) { category in
                                        CategoryCard(
                                            category: category,
                                            isSelected: selectedCategory == category.name
                                        )
                                        .onTapGesture {
                                            selectedCategory = selectedCategory == category.name ? nil : category.name
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // MARK: - Restaurants
                            VStack(alignment: .leading) {
                                Text("Popular Restaurants")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(restaurants) { restaurant in
                                            RestaurantCard(restaurant: restaurant)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // MARK: - Food Grid
                            Text("Popular Items")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(filteredItems) { item in
                                    FoodItemView(food: item, isSelected: selectedItems.contains(item.id)) {
                                        if selectedItems.contains(item.id) {
                                            selectedItems.remove(item.id)
                                            itemCounts[item.id] = nil
                                        } else {
                                            selectedItems.insert(item.id)
                                            itemCounts[item.id] = 1
                                        }
                                    }
                                    .onTapGesture {
                                        selectedFood = item
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    Spacer()
                }
                .background(Color.gray.opacity(0.1))
                .ignoresSafeArea()
                .cornerRadius(isMenuOpen ? 20 : 0)
                .offset(x: isMenuOpen ? 150 : 0, y: isMenuOpen ? 70 : 0)
                .scaleEffect(isMenuOpen ? 0.9 : 1)
                .rotationEffect(.degrees(isMenuOpen ? -10 : 0))
                .shadow(color: isMenuOpen ? Color.black.opacity(0.3) : Color.clear, radius: 10, x: 5, y: 5)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -100 {
                                withAnimation {
                                    isMenuOpen = false
                                }
                            }
                        }
                )
                
                // MARK: - Side Menu
                if isMenuOpen {
                    SideMenuView(isMenuOpen: $isMenuOpen, navigateToLogin: $navigateToLogin)
                        .transition(.move(edge: .leading))
                }
                
                // MARK: - Navigation Links
                NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
                
                NavigationLink(destination: AddItemView(itemCounts: $itemCounts, selectedItems: selectedFoodItems), isActive: $showCart) {
                    EmptyView()
                }
            }
            .ignoresSafeArea()
            .sheet(item: $selectedFood) { food in
                FoodDetailView(food: food)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView(locationManager: locationManager)
                    .presentationDetents([.medium])
            }
            .onAppear {
                orderViewModel.fetchOrders()
                profileViewModel.fetchUserProfile()
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}


struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @Binding var navigateToLogin: Bool
    
    @State private var showProfileSubmenu = false
    @State private var showSettingsSubmenu = false
    @State private var showFoodSubmenu = false
    @State private var showOrdersSubmenu = false
    
    @State private var selectedItems: Set<UUID> = []
    @State private var itemCounts: [UUID: Int] = [:]
    
    // Define menu structure
    private let menuItems: [MenuItem] = [
        MenuItem(title: "Food", icon: "square.grid.3x3", items: [
            SubMenuItem(title: "Indian", destination: .indian),
            SubMenuItem(title: "Chinese", destination: .chinese),
            SubMenuItem(title: "Italian", destination: .other("Italian")),
            SubMenuItem(title: "Mexican", destination: .other("Mexican"))
        ]),
        MenuItem(title: "Orders", icon: "clock.fill", items: [
            SubMenuItem(title: "Active Orders", destination: .orders),
            SubMenuItem(title: "Order History", destination: .other("History")),
            SubMenuItem(title: "Favorites", destination: .other("Favorites"))
        ]),
        MenuItem(title: "Profile", icon: "person", items: [
            SubMenuItem(title: "View Profile", destination: .profile),
            SubMenuItem(title: "Edit Profile", destination: .editProfile),
            SubMenuItem(title: "Addresses", destination: .other("Addresses"))
        ]),
        MenuItem(title: "Settings", icon: "gear", items: [
            SubMenuItem(title: "App Settings", destination: .appSettings),
            SubMenuItem(title: "Notifications", destination: .notifications),
            SubMenuItem(title: "Payment Methods", destination: .other("Payments"))
        ])
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background dim effect
                if isMenuOpen {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isMenuOpen = false
                            }
                        }
                }
                
                // Menu Content
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        // Profile Header
                        ProfileHeaderView()
                        
                        Divider().background(.white)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(menuItems) { menuItem in
                                    MenuItemView(item: menuItem, selectedItems: $selectedItems, itemCounts: $itemCounts)
                                }
                                
                                Divider().background(.white).padding(.vertical, 10)
                                
                                // Additional Features Section
                                AdditionalFeaturesView()
                                
                                // Logout Button
                                LogoutButton(isMenuOpen: $isMenuOpen, navigateToLogin: $navigateToLogin)
                            }
                        }
                    }
                    .padding()
                    .frame(width: 250)
                    .background(Color.black.opacity(0.90))
                    .edgesIgnoringSafeArea(.top)
                    .offset(x: isMenuOpen ? 0 : -300)
                    
                    Spacer()
                }
            }
            .animation(.spring(response: 0.3, blendDuration: 0.2), value: isMenuOpen)
        }
    }
}

// MARK: - Supporting Types
private struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let items: [SubMenuItem]
}

private struct SubMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let destination: MenuDestination
}

private enum MenuDestination {
    case indian, chinese, profile, editProfile, appSettings, notifications, orders, other(String)
}

// MARK: - Supporting Views
private struct ProfileHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 4) {
                Text("Hey, 👋")
                    .foregroundColor(.white)
                    .font(.headline)
                Text("Ohid iOS Dev")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }
        }
        .padding(.top, 50)
    }
}

private struct MenuItemView: View {
    let item: MenuItem
    @State private var isExpanded = false
    @Binding var selectedItems: Set<UUID>
    @Binding var itemCounts: [UUID: Int]
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(item.items) { subItem in
                        NavigationLink(destination: destinationView(for: subItem.destination)) {
                            Text(subItem.title)
                                .foregroundColor(.white)
                                .padding(.leading, 35)
                        }
                        .padding(.vertical, 5)
                    }
                }
            },
            label: {
                Label(item.title, systemImage: item.icon)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        )
        .accentColor(.white)
    }
    
    @ViewBuilder
    private func destinationView(for destination: MenuDestination) -> some View {
        switch destination {
        case .indian:
            IndianFoodView(selectedItems: $selectedItems, itemCounts: $itemCounts)
        case .chinese:
            ChineseFoodView()
        case .profile:
            ProfileView()
        case .editProfile:
            EditProfileView()
        case .appSettings:
            AppSettingsView()
        case .notifications:
            NotificationSettingsView()
        case .orders:
            OrdersListView()
        case .other(let title):
            Text(title)
        }
    }
}

private struct AdditionalFeaturesView: View {
    @State private var isDarkMode = false
    @State private var isNotificationsEnabled = false
    
    var body: some View {
        VStack(spacing: 15) {
            Toggle(isOn: $isDarkMode) {
                Label("Dark Mode", systemImage: "moon.fill")
            }
            .tint(.white)
            
            Toggle(isOn: $isNotificationsEnabled) {
                Label("Notifications", systemImage: "bell.fill")
            }
            .tint(.white)
        }
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}

private struct LogoutButton: View {
    @Binding var isMenuOpen: Bool
    @Binding var navigateToLogin: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isMenuOpen = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                    navigateToLogin = true
                }
            }
        }) {
            HStack {
                Image(systemName: "power")
                Text("Logout")
                    .fontWeight(.medium)
            }
            .foregroundColor(.red)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
