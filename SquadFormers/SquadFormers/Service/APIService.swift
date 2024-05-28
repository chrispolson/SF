import Foundation

class APIClient {
    static func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let sampleArticles = [Article(title: "iOS Development"), Article(title: "SwiftUI Essentials")]
        completion(.success(sampleArticles))
    }
}
