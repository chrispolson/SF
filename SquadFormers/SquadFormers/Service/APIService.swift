import Foundation

struct APIClient {
    func fetchArticles() async throws -> [Article] {
        let sampleArticles = [Article(title: "iOS Development"), Article(title: "SwiftUI Essentials")]
        
        return sampleArticles
    }
}
