import Foundation

protocol StorageServiceType {
    func getRecentCities() -> [City]
    func addRecentCity(_ city: City)
}


class StorageService: StorageServiceType {

    enum Constants {
        static let maxNumberOfRecentCities = 3
        static let recentCitiesKey = "recentCities"
    }

    func getRecentCities() -> [City] {
        guard let fetchedData = UserDefaults.standard.data(forKey: Constants.recentCitiesKey) else { return [] }
        guard let decodedData = try? JSONDecoder().decode([City].self, from: fetchedData) else { return [] }
        return decodedData
    }

    func addRecentCity(_ city: City) {
        var recentCities = getRecentCities()

        if let index = recentCities.firstIndex(of: city) { recentCities.remove(at: index) }
        recentCities.insert(city, at: recentCities.startIndex)
        if recentCities.count > Constants.maxNumberOfRecentCities { recentCities.removeLast() }

        guard let encodedData = try? JSONEncoder().encode(recentCities) else { return }
        UserDefaults.standard.set(encodedData, forKey: Constants.recentCitiesKey)
    }

}
