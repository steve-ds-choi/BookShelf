//
//  JList.swift
//  BookShelf
//
//  Created by steve on 2021/05/23.
//

import UIKit
import Foundation

struct JBook : Codable
{
    let title    : String?
    let subtitle : String?
    let isbn13   : String?
    let price    : String?
    let image    : String?
    let url      : String?

    enum CodingKeys: String, CodingKey
    {
        case title    = "title"
        case subtitle = "subtitle"
        case isbn13   = "isbn13"
        case price    = "price"
        case image    = "image"
        case url      = "url"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        title      = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle   = try values.decodeIfPresent(String.self, forKey: .subtitle)
        isbn13     = try values.decodeIfPresent(String.self, forKey: .isbn13)
        price      = try values.decodeIfPresent(String.self, forKey: .price)
        image      = try values.decodeIfPresent(String.self, forKey: .image)
        url        = try values.decodeIfPresent(String.self, forKey: .url)
    }
}

struct JList : Codable
{
    let error : String?
    let total : String?
    let page  : String?
    let books : [JBook]?

    enum CodingKeys: String, CodingKey
    {
        case error = "error"
        case total = "total"
        case page  = "page"
        case books = "books"
    }

    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        error = try values.decodeIfPresent(String.self, forKey: .error)
        total = try values.decodeIfPresent(String.self, forKey: .total)
        page  = try values.decodeIfPresent(String.self, forKey: .page)
        books = try values.decodeIfPresent([JBook].self, forKey: .books)
    }

}
