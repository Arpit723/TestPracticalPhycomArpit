import Foundation


class NewsViewModel {
    
    var newsArray = [Article]()


    //MARK: API Call
    func getNewsArticles(completion: @escaping (Result<Welcome, Error>) -> Void) {
        let endpoint = ServerParam.baseURL + "sources=google-news&apiKey=\(News_API_Key)"
        APIManager.shared.request(endpoint: endpoint, method: "GET", parameters: nil) { [weak self] (result: Result<Welcome, Error>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let welcome):
                self.newsArray = Array(welcome.articles)
//                if pageStart == 0 {
                    RealmDBManager.shared.deleteObjectsFromDatabse()
                    RealmDBManager.shared.addObjectsToDatabse(data: self.newsArray )
//                } else {
//                    RealmDBManager.shared.addObjectsToDatabse(data: posts)
//                }
//                self.postsArray =  RealmDBManager.shared.getObjectsFromDatabse()
//                self.computeExistingStartAndEnd()
                completion(.success( welcome))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
