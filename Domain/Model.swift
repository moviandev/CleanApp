import Foundation

public protocol Model: Codable {

}

public extension Model {
    func toDsta() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
