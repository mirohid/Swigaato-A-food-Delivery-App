import Foundation
import FirebaseFirestore

enum OrderStatus: String, Codable, CaseIterable {
    case placed = "PLACED"
    case preparing = "PREPARING"
    case readyForPickup = "READY_FOR_PICKUP"
    case outForDelivery = "OUT_FOR_DELIVERY"
    case delivered = "DELIVERED"
    case cancelled = "CANCELLED"
    
    var description: String {
        switch self {
        case .placed: return "Order Placed"
        case .preparing: return "Preparing Your Food"
        case .readyForPickup: return "Ready for Pickup"
        case .outForDelivery: return "Out for Delivery"
        case .delivered: return "Delivered"
        case .cancelled: return "Cancelled"
        }
    }
    
    var systemImage: String {
        switch self {
        case .placed: return "checkmark.circle"
        case .preparing: return "flame"
        case .readyForPickup: return "bag.fill"
        case .outForDelivery: return "bicycle"
        case .delivered: return "house.fill"
        case .cancelled: return "xmark.circle"
        }
    }
}

struct OrderItem: Identifiable, Codable {
    var id: String
    let itemId: String
    let name: String
    let price: String
    let quantity: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemId = "item_id"
        case name
        case price
        case quantity
        case image
    }
}

struct OrderModel: Identifiable, Codable {
    var id: String
    let userId: String
    let items: [OrderItem]
    let subtotal: Double
    let deliveryFee: Double
    let tax: Double
    let total: Double
    let status: OrderStatus
    let createdAt: Timestamp
    let deliveryAddress: AddressModel
    let estimatedDeliveryTime: Timestamp?
    let deliveredAt: Timestamp?
    let restaurantName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case items
        case subtotal
        case deliveryFee = "delivery_fee"
        case tax
        case total
        case status
        case createdAt = "created_at"
        case deliveryAddress = "delivery_address"
        case estimatedDeliveryTime = "estimated_delivery_time"
        case deliveredAt = "delivered_at"
        case restaurantName = "restaurant_name"
    }
}
