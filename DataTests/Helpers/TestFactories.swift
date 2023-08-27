import Foundation

func makeInvalidData() -> Data {
    Data("invalid_data".utf8)
}

func makeValidData() -> Data {
    Data("{\"name\":\"Matheus\"}".utf8)
}

func makeUrl() -> URL {
    URL(string: "http://any-url.com")!
}
