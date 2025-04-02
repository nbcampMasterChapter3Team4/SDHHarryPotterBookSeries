import Foundation
import OSLog

class DataService {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "DataService")
    
    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }
    
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
//        guard let path = Bundle.main.path(forResource: "data_parsingErrorTest", ofType: "json") else {
//        guard let path = Bundle.main.path(forResource: "data_fileNotFound", ofType: "json") else {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            os_log("🚨 JSON 파일을 찾을 수 없음", log: self.log, type: .error)
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
            let books = bookResponse.data
            completion(.success(books))
        } catch {
            let errorString = "\(error)"
            os_log("🚨 JSON 파싱 에러 : %@", log: self.log, type: .error, errorString)
            completion(.failure(DataError.parsingFailed))
        }
    }
}
/* 사용부
 private let dataService = DataService()
 
 func loadBooks() {
     dataService.loadBooks { [weak self] result in
         guard let self = self else { return }
         
         switch result {
         case .success(let books):
             
             
         case .failure(let error):
         }
     }
 }
 */
