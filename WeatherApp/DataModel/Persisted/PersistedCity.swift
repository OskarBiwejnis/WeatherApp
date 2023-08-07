import Foundation
import RealmSwift

class PersistedCity: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var country: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double

    convenience init(from city: City) {
        self.init()
        self.name = city.name
        self.country = city.country
        self.latitude = city.latitude
        self.longitude = city.longitude
    }
}

