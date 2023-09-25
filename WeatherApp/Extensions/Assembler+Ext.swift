import Foundation
import Swinject

extension Assembler {
    static let shared = Assembler([WelcomeAssembly(),
                                  SearchAssembly(),
                                  ForecastAssembly(),
                                  ServicesAssembly()])
}
