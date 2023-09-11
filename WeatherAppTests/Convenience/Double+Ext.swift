import Combine
import Foundation

extension Double: SchedulerTimeIntervalConvertible {
    public static func seconds(_ s: Int) -> Double {
        return 0
    }

    public static func seconds(_ s: Double) -> Double {
        return 0
    }

    public static func milliseconds(_ ms: Int) -> Double {
        return 0
    }

    public static func microseconds(_ us: Int) -> Double {
        return 0
    }

    public static func nanoseconds(_ ns: Int) -> Double {
        return 0
    }
}
