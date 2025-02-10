import Foundation

struct UserModel: Codable {
    let fullName: String
    let email: String
    let uid: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email
        case uid
    }
} 