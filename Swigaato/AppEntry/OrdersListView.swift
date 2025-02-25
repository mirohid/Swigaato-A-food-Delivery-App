import SwiftUI

struct OrdersListView: View {
    @StateObject private var viewModel = OrderViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedOrder: OrderModel? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                    
                    Text("My Orders")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Empty spacer for visual balance
                    Circle()
                        .frame(width: 40, height: 40)
                        .opacity(0)
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                if viewModel.isLoading {
                    // Loading indicator
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    Text("Loading your orders...")
                        .foregroundColor(.gray)
                    Spacer()
                } else if viewModel.orders.isEmpty {
                    // Empty orders view
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "bag")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)
                        
                        Text("No Orders Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your order history will appear here")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: HomeView()) {
                            Text("Browse Food")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    Spacer()
                } else {
                    // Orders list
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.orders) { order in
                                OrderCard(order: order)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        self.selectedOrder = order
                                    }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.fetchOrders()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(item: $selectedOrder) { order in
                OrderDetailView(order: order, viewModel: viewModel)
            }
        }
    }
}

// Card view for each order in the list
struct OrderCard: View {
    let order: OrderModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Order header
            HStack {
                Text("Order #\(order.id.prefix(6))")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Status badge
                Text(order.status.description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(for: order.status).opacity(0.2))
                    .foregroundColor(statusColor(for: order.status))
                    .cornerRadius(8)
            }
            
            // Restaurant name
            Text(order.restaurantName)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
            
            // Order items (showing up to 2 items + count of remaining)
            VStack(alignment: .leading, spacing: 5) {
                let displayItems = Array(order.items.prefix(2))
                
                ForEach(displayItems) { item in
                    HStack {
                        Text("\(item.quantity)x")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(item.name)
                            .font(.subheadline)
                    }
                }
                
                if order.items.count > 2 {
                    Text("+ \(order.items.count - 2) more items")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            // Order details
            HStack {
                // Order date
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(formatDate(order.createdAt.dateValue()))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Order total
                Text("Total: ₹\(String(format: "%.2f", order.total))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    // Helper function to format date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Helper function for status colors
    private func statusColor(for status: OrderStatus) -> Color {
        switch status {
        case .placed: return .blue
        case .preparing: return .orange
        case .readyForPickup: return .yellow
        case .outForDelivery: return .purple
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}

// Detailed view of a specific order
struct OrderDetailView: View {
    let order: OrderModel
    @ObservedObject var viewModel: OrderViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showCancelConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Order status section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Order Status")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        StatusTracker(currentStatus: order.status)
                            .padding(.horizontal)
                    }
                    
                    // Order items section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Order")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(order.items) { item in
                                HStack(spacing: 15) {
                                    // Item image placeholder
                                    if !item.image.isEmpty {
                                        Image(item.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(item.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text("\(item.price) × \(item.quantity)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Item total
                                    let priceValue = Double(item.price.replacingOccurrences(of: "Rs.", with: "")) ?? 0
                                    Text("₹\(String(format: "%.2f", priceValue * Double(item.quantity)))")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // Order summary section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Order Summary")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 10) {
                            // Subtotal
                            HStack {
                                Text("Subtotal")
                                    .font(.subheadline)
                                Spacer()
                                Text("₹\(String(format: "%.2f", order.subtotal))")
                                    .font(.subheadline)
                            }
                            
                            // Delivery fee
                            HStack {
                                Text("Delivery Fee")
                                    .font(.subheadline)
                                Spacer()
                                Text("₹\(String(format: "%.2f", order.deliveryFee))")
                                    .font(.subheadline)
                            }
                            
                            // Tax
                            HStack {
                                Text("Tax")
                                    .font(.subheadline)
                                Spacer()
                                Text("₹\(String(format: "%.2f", order.tax))")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            // Total
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                Text("₹\(String(format: "%.2f", order.total))")
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // Delivery address section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Delivery Address")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(order.deliveryAddress.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(order.deliveryAddress.street)
                                .font(.subheadline)
                            
                            Text("\(order.deliveryAddress.city), \(order.deliveryAddress.state) \(order.deliveryAddress.zipCode)")
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // Cancel order button (only shown for orders that can be cancelled)
                    if order.status == .placed || order.status == .preparing {
                        Button(action: {
                            showCancelConfirmation = true
                        }) {
                            Text("Cancel Order")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Order #\(order.id.prefix(6))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Cancel Order", isPresented: $showCancelConfirmation) {
                Button("Yes, Cancel", role: .destructive) {
                    viewModel.cancelOrder(orderId: order.id)
                    dismiss()
                }
                Button("No, Keep Order", role: .cancel) {
                    showCancelConfirmation = false
                }
            } message: {
                Text("Are you sure you want to cancel this order?")
            }
        }
    }
}

// Status tracker component
struct StatusTracker: View {
    let currentStatus: OrderStatus
    
    private let allStatuses: [OrderStatus] = [
        .placed, .preparing, .readyForPickup, .outForDelivery, .delivered
    ]
    
    private func statusIndex(_ status: OrderStatus) -> Int {
        allStatuses.firstIndex(of: status) ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if currentStatus == .cancelled {
                // Special view for cancelled orders
                HStack(spacing: 15) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Order Cancelled")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        Text("This order has been cancelled")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            } else {
                // Normal status tracker for active orders
                ForEach(allStatuses, id: \.self) { status in
                    let isActive = statusIndex(currentStatus) >= statusIndex(status)
                    let isCurrent = currentStatus == status
                    
                    HStack(spacing: 15) {
                        // Status indicator
                        ZStack {
                            Circle()
                                .fill(isActive ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30)
                            
                            if isActive {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Status details
                        VStack(alignment: .leading, spacing: 4) {
                            Text(status.description)
                                .font(.subheadline)
                                .fontWeight(isCurrent ? .semibold : .regular)
                                .foregroundColor(isCurrent ? .primary : .gray)
                            
                            if isCurrent {
                                Text(statusMessage(for: status))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Connector line between status points (except for the last one)
                    if status != .delivered {
                        Rectangle()
                            .fill(statusIndex(currentStatus) > statusIndex(status) ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 2, height: 20)
                            .padding(.leading, 14) // Center with the circles
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }
        }
    }
    
    // Helper function for status messages
    private func statusMessage(for status: OrderStatus) -> String {
        switch status {
        case .placed:
            return "We've received your order"
        case .preparing:
            return "Your food is being prepared"
        case .readyForPickup:
            return "Your order is ready for pickup"
        case .outForDelivery:
            return "Your order is on the way!"
        case .delivered:
            return "Enjoy your meal!"
        case .cancelled:
            return "This order has been cancelled"
        }
    }
}

struct OrdersListView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersListView()
    }
}
