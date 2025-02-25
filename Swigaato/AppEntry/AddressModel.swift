import Foundation

struct AddressModel: Identifiable, Codable {
    var id: String
    let userId: String
    var name: String
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case street
        case city
        case state
        case zipCode = "zip_code"
        case isDefault = "is_default"
    }
}
