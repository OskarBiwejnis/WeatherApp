import Foundation

struct User: Decodable {
    var login: String
    var id: Int
    var siteAdmin: Bool
}
