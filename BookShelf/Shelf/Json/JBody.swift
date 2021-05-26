//
//  JBody.swift
//  BookShelf
//
//  Created by steve on 2021/05/23.
//

import UIKit

struct JBody : Codable
{
    let error     : String?
    let title     : String?
    let subtitle  : String?
    let authors   : String?
    let publisher : String?
    let language  : String?
    let isbn10    : String?
    let isbn13    : String?
    let pages     : String?
    let year      : String?
    let rating    : String?
    let desc      : String?
    let price     : String?
    let image     : String?
    let url       : String?
    let pdf       : [String:String]?

    enum CodingKeys: String, CodingKey {

        case error     = "error"
        case title     = "title"
        case subtitle  = "subtitle"
        case authors   = "authors"
        case publisher = "publisher"
        case language  = "language"
        case isbn10    = "isbn10"
        case isbn13    = "isbn13"
        case pages     = "pages"
        case year      = "year"
        case rating    = "rating"
        case desc      = "desc"
        case price     = "price"
        case image     = "image"
        case url       = "url"
        case pdf       = "pdf"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        error     = try values.decodeIfPresent(String.self, forKey: .error)
        title     = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle  = try values.decodeIfPresent(String.self, forKey: .subtitle)
        authors   = try values.decodeIfPresent(String.self, forKey: .authors)
        publisher = try values.decodeIfPresent(String.self, forKey: .publisher)
        language  = try values.decodeIfPresent(String.self, forKey: .language)
        isbn10    = try values.decodeIfPresent(String.self, forKey: .isbn10)
        isbn13    = try values.decodeIfPresent(String.self, forKey: .isbn13)
        pages     = try values.decodeIfPresent(String.self, forKey: .pages)
        year      = try values.decodeIfPresent(String.self, forKey: .year)
        rating    = try values.decodeIfPresent(String.self, forKey: .rating)
        desc      = try values.decodeIfPresent(String.self, forKey: .desc)
        price     = try values.decodeIfPresent(String.self, forKey: .price)
        image     = try values.decodeIfPresent(String.self, forKey: .image)
        url       = try values.decodeIfPresent(String.self, forKey: .url)

        pdf       = try values.decodeIfPresent([String:String].self, forKey: .pdf)
    }

}
