//
//  PostModel.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import Foundation
import RealmSwift

// MARK: - Welcome
class Welcome: Object, Codable {
    @Persisted var status: String
    @Persisted var totalResults: Int
    @Persisted var articles = List<Article>()
    
    override init() {
        super.init()
    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.articles = try container.decode(List<Article>.self, forKey: .articles)
    }
    
    enum CodingKeys: String, CodingKey {
        case status, totalResults, articles
    }
}

// MARK: - Article
class Article: Object, Codable {
    @Persisted var source: Source?
    @Persisted var author: String
    @Persisted var title: String
//    let descriptionText: String?
    @Persisted var url: String
//    let urlToImage: String?
    @Persisted var publishedAt: String
    
    override init() {
        super.init()
    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)

    }
    
    enum CodingKeys: String, CodingKey {
        case author, title, url, publishedAt
    }
//    let content: String?
}

// MARK: - Source
class Source: Object, Codable {
    @Persisted var id: String
    @Persisted var name: String
    override init() {
        super.init()
    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)

    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

//enum ID: String, Codable {
//    case googleNews = "google-news"
//}
//
//enum Name: String, Codable {
//    case googleNews = "Google News"
//}
