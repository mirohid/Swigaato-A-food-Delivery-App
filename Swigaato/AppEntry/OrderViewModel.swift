import SwiftUI
import Firebase
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var currentOrder: OrderModel?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showAlert = false
    
    private let db = Firestore.firestore()
    
    func fetchOrders() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not logged in"
            self.showAlert = true
            return
        }
        
        isLoading = true
        
        db.collection("orders")
            .whereField("user_id", isEqualTo: userId)
            .order(by: "created_at", descending: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self.orders = documents.compactMap { document in
                    do {
                        var order = try document.data(as: OrderModel.self)
                        order.id = document.documentID
                        return order
                    } catch {
                        print("Error decoding order: \(error)")
                        return nil
                    }
                }
            }
    }
    
    func fetchOrderDetails(orderId: String) {
        isLoading = true
        
        db.collection("orders").document(orderId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            do {
                if let snapshot = snapshot, snapshot.exists {
                    var order = try snapshot.data(as: OrderModel.self)
                    order.id = snapshot.documentID
                    self.currentOrder = order
                } else {
                    self.errorMessage = "Order not found"
                    self.showAlert = true
                }
            } catch {
                self.errorMessage = "Error loading order: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    func createOrder(from cartItems: [FoodModel], itemCounts: [UUID: Int], deliveryAddress: AddressModel) {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not logged in"
            self.showAlert = true
            return
        }
        
        // Calculate order values
        let orderItems = cartItems.compactMap { item -> OrderItem? in
            guard let count = itemCounts[item.id], count > 0 else { return nil }
            
            // Convert price string to double
            let priceString = item.price.replacingOccurrences(of: "Rs.", with: "")
            let price = Double(priceString) ?? 0.0
            
            return OrderItem(
                id: UUID().uuidString,
                itemId: item.id.uuidString,
                name: item.title,
                price: item.price,
                quantity: count,
                image: item.image
            )
        }
        
        // Calculate financial values
        let subtotal = orderItems.reduce(0.0) { total, item in
            let priceString = item.price.replacingOccurrences(of: "Rs.", with: "")
            let price = Double(priceString) ?? 0.0
            return total + (price * Double(item.quantity))
        }
        
        let deliveryFee = 50.0 // Fixed delivery fee
        let tax = subtotal * 0.05 // 5% tax
        let total = subtotal + deliveryFee + tax
        
        // Create estimated delivery time (current time + 45 minutes)
        let estimatedDeliveryTime = Timestamp(date: Date().addingTimeInterval(45 * 60))
        
        let order: [String: Any] = [
            "user_id": userId,
            "items": orderItems.map { item in
                return [
                    "id": item.id,
                    "item_id": item.itemId,
                    "name": item.name,
                    "price": item.price,
                    "quantity": item.quantity,
                    "image": item.image
                ]
            },
            "subtotal": subtotal,
            "delivery_fee": deliveryFee,
            "tax": tax,
            "total": total,
            "status": OrderStatus.placed.rawValue,
            "created_at": Timestamp(date: Date()),
            "delivery_address": [
                "id": deliveryAddress.id,
                "user_id": deliveryAddress.userId,
                "name": deliveryAddress.name,
                "street": deliveryAddress.street,
                "city": deliveryAddress.city,
                "state": deliveryAddress.state,
                "zip_code": deliveryAddress.zipCode,
                "is_default": deliveryAddress.isDefault
            ],
            "estimated_delivery_time": estimatedDeliveryTime,
            "delivered_at": NSNull(),
            "restaurant_name": "Swigaato Restaurant" // Replace with actual restaurant name
        ]
        
        db.collection("orders").addDocument(data: order) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            // Order successfully created
            self.fetchOrders() // Refresh orders list
        }
    }
    
    func cancelOrder(orderId: String) {
        db.collection("orders").document(orderId).updateData([
            "status": OrderStatus.cancelled.rawValue
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            // Refresh orders after cancellation
            self.fetchOrders()
            if self.currentOrder?.id == orderId {
                self.fetchOrderDetails(orderId: orderId)
            }
        }
    }
}
