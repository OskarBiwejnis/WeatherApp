import Foundation
import RealmSwift

protocol StorageServiceType {
    func getRecentCities() -> [City]
    func addRecentCity(_ city: City)
}


class StorageService: StorageServiceType {

    private let realm = try! Realm()

    enum Constants {
        static let maxNumberOfRecentCities = 3
        static let recentCitiesKey = "recentCities"
    }

    func getRecentCities() -> [City] {
        var recentCities: [City] = realm.objects(PersistedCity.self).compactMap { persistedCity -> City in
            return City(from: persistedCity)
        }

        return recentCities.reversed()
    }

    func addRecentCity(_ recentCity: City) {
        let persistedCities = realm.objects(PersistedCity.self) 

        for persistedCity in persistedCities {
            let city = City(from: persistedCity)
            if city == recentCity {
                try? realm.write {
                    realm.delete(persistedCity)
                }
            }
        }

        try? realm.write {
            realm.add(PersistedCity(from: recentCity))
        }

        if persistedCities.count > Constants.maxNumberOfRecentCities {
            let firstPersistedCity: PersistedCity! = persistedCities.first
            try? realm.write {
                realm.delete(firstPersistedCity)
            }
        }
    }

}
