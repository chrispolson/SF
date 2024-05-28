import Foundation

struct ArticlesService {
    
    let apiService: APIClient
    let session: URLSession
    let baseURL = "https://test-example-uri.com/api/articles/"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
        self.apiService = APIClient(session: session)
    }
    
    private func dataForEndpoint(endPoint: String) async throws -> Data {
        guard let url = URL(string: endPoint) else {
            throw APIServiceError.invalidURL
        }
        let request = URLRequest(url: url)
        
        let data = try await apiService.executeGetRequest(request: request)
        return data
    }
    
    func fetchArticles() async throws -> [Article] {
        let endPoint = baseURL
        let data = try await dataForEndpoint(endPoint: endPoint)
        
        do {
            let articles: [Article] = try JSONDecoder().decode([Article].self, from: data)
            return articles
        } catch {
            throw DataError.decodingError
        }
    }
}
