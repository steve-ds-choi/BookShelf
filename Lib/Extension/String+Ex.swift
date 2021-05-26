//
//  String+Ex.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

let _fm = FileManager.default

extension NSString {

    var plast:  String { lastPathComponent }
    var pname:  String { plast.asNSString.deletingPathExtension }
    var pextn:  String { pathExtension }

    func replace(of target: String, with replacement: String) -> String {
        replacingOccurrences(of: target, with: replacement)
    }
}

extension String {
    
    var asNSString: NSString { self as NSString }

    var asURL:  URL  { URL(string: self)! }
    var asFURL: URL  { URL(fileURLWithPath: self) }
    var asData: Data { data(using: .utf8)! }
    
    var decodedHtml: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string

        return decoded ?? self
    }
    
    func toData() -> Data?
    {
        if fexsit() == false { return nil }

        let data = try? Data(contentsOf: asFURL)
        return data
    }

    func toImage() -> UIImage?
    {
        guard let data = toData() else { return nil }

        let image = UIImage(data:data)
        return image
    }
    
    func toArray() -> Array<Any>?
    {
        if fexsit() == false { return nil }

        let a = NSArray(contentsOfFile: self)
        return a as? Array<Any>
    }
    
    func toDictionary() -> Dictionary<String, Any>?
    {
        if fexsit() == false { return nil }

        let d = NSDictionary(contentsOfFile: self)
        return d as? Dictionary<String, Any>
    }
    
    func fexsit() -> Bool {
        _fm.fileExists(atPath: self)
    }

    func fcreate(_ create: NSInteger = 1) {
        if create == 0 { return }
        if create == 2 { fremove() }

        try! _fm.createDirectory(atPath: self, withIntermediateDirectories: true, attributes: nil)
    }

    func fremove()
    {
        if fexsit() == false { return }

        try! _fm.removeItem(atPath: self)
    }

    func fwrite(text: String) {
        fwrite(data: text.asData)
    }

    func fwrite(data: Data?)
    {
        let data = data ?? Data()
        try! data.write(to: asFURL)
    }
    
    func fwrite(array: Array<Any>)
    {
        let a = array as NSArray
        a.write(toFile: self, atomically: true)
    }
    
    func fwrite(dictionary: Dictionary<String, Any>)
    {
        let d = dictionary as NSDictionary
        d.write(toFile: self, atomically: true)
    }

    func fcount() -> Int
    {
        let files = try! _fm.contentsOfDirectory(atPath: self)
        return files.count
    }
    
    var expandingTildeInPath: String { asNSString.expandingTildeInPath }
    
    var urlQuery: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

extension String {
    var plast:  String { asNSString.plast  }
    var pname:  String { asNSString.pname  }
    var pextn:  String { asNSString.pextn  }
        
    func pmake(_ comp: String) -> String {
        if comp.count == 0 { return self }

        let s = asNSString.appendingPathComponent(comp)
        return s
    }

    func pfile(_ extn: String) -> String {
        if self.count == 0 { return "" }
        if extn.count == 0 { return self }

        return self + "." + extn
    }
}

extension String {
    
    subscript (bounds: CountableClosedRange<Int>) -> String
    {
        if count == 0 { return "" }

        let s = index(startIndex, offsetBy: bounds.lowerBound)
        let e = index(startIndex, offsetBy: bounds.upperBound)

        return String(self[s...e])
    }

    subscript (bounds: CountableRange<Int>) -> String
    {
        if count == 0 { return "" }

        let s = index(startIndex, offsetBy: bounds.lowerBound)
        let e = index(startIndex, offsetBy: bounds.upperBound)

        return String(self[s..<e])
    }

    func trimSpace() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func replace(of target: String, with replacement: String) -> String {
        asNSString.replace(of: target, with: replacement)
    }

    func components(separatedBy separator: String) -> [String] {
        asNSString.components(separatedBy: separator)
    }

    func range(of str: String) -> NSRange {
        asNSString.range(of: str)
    }

    func range(of str: String, _ mask: NSString.CompareOptions = []) -> NSRange {
        asNSString.range(of: str, options: mask)
    }

    func range(of str: String, _ mask: NSString.CompareOptions = [], _ range: NSRange) -> NSRange {
        asNSString.range(of: str, options: mask, range: range)
    }
}
