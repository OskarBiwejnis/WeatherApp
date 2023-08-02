import Foundation

protocol StorageServiceType {
    func getStoredCities() -> [City]
    func pushCity(_ city: City)
    func getNumberOfStoredCities() -> Int
    func getStoredCity(index: Int) -> City?
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

    func getStoredCity(index: Int) -> City? {
        let storedCities = getStoredCities()
        if storedCities.count > index {
            return storedCities[index]
        } else {
            return nil
        }
    }

    func pushCity(_ city: City) {
        var storedCities = getStoredCities()

        if let index = storedCities.firstIndex(of: city) { storedCities.remove(at: index) }
        storedCities.insert(city, at: storedCities.startIndex)
        if storedCities.count > Constants.maxNumberOfStoredCities { storedCities.removeLast() }

        guard let encodedData = try? JSONEncoder().encode(storedCities) else { return }
        UserDefaults.standard.set(encodedData, forKey: Constants.storedCitiesKey)
    }

    func getNumberOfStoredCities() -> Int {
        return getStoredCities().count
    }
}
