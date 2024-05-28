import Foundation

enum APIServiceError: Error {
    case unsuccessful
    case invalidURL
}

enum DataError: Error {
    case decodingError
}

struct APIClient {

    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func executeGetRequest(request: URLRequest) async throws -> Data {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw APIServiceError.unsuccessful
              }
        
        return data
    }
}
