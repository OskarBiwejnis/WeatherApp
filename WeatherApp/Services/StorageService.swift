import Foundation

protocol StorageServiceType {
    func getStoredCities() -> [City]
    func pushCity(_ city: City)
}


class StorageService: StorageServiceType {

    enum Constants {
        static let maxNumberOfStoredCities = 3
        static let storedCitiesKey = "storedCities"
    }

    func getStoredCities() -> [City] {
        guard let fetchedData = UserDefaults.standard.data(forKey: Constants.storedCitiesKey) else { return [] }
        guard let decodedData = try? JSONDecoder().decode([City].self, from: fetchedData) else { return [] }
        return decodedData
    }

    func pushCity(_ city: City) {
        var storedCities: [City] = getStoredCities()

        if let index = storedCities.firstIndex(of: city) { storedCities.remove(at: index) }
        storedCities.insert(city, at: storedCities.startIndex)
        if storedCities.count > Constants.maxNumberOfStoredCities { storedCities.removeLast() }

        guard let encodedData = try? JSONEncoder().encode(storedCities) else { return }
        UserDefaults.standard.set(encodedData, forKey: Constants.storedCitiesKey)
    }

}
