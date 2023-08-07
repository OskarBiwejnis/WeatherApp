import Foundation
import RealmSwift

protocol StorageServiceType {
    func getRecentCities() -> [City]
    func addRecentCity(_ city: City)
}


class StorageService: StorageServiceType {

    let realm = try? Realm()

    enum Constants {
        static let maxNumberOfRecentCities = 3
        static let recentCitiesKey = "recentCities"
    }

    func getRecentCities() -> [City] {
        var recentCities: [City] = []
        guard let persistedCities = realm?.objects(PersistedCity.self) else { return [] }

        for persistedCity in persistedCities {
            recentCities.append(City(from: persistedCity))
        }

        print(recentCities)
        return recentCities.reversed()
    }

    func addRecentCity(_ recentCity: City) {
        guard let persistedCities = realm?.objects(PersistedCity.self) else { return }

        for persistedCity in persistedCities {
            let city = City(from: persistedCity)
            if city == recentCity {
                try? realm?.write {
                    realm?.delete(persistedCity)
                }
            }
        }

        try? realm?.write {
            realm?.add(PersistedCity(from: recentCity))
        }

        if persistedCities.count > Constants.maxNumberOfRecentCities {
            let firstPersistedCity: PersistedCity! = persistedCities.first
            try? realm?.write {
                realm?.delete(firstPersistedCity)
            }
        }
    }

}


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
