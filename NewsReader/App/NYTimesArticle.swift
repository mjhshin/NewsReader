//
//  NYTimesArticle.swift
//  NewsReader
//
//  Created by Michael Shin on 5/18/16.
//
//

import Foundation

class NYTimesArticle: NSObject {
    
    var _objectId: String?
    var _abstract: String?
    var _byline: String?
    var _publishDate: String?
    var _section: String?
    var _subsection: String?
    var _title: String?
    var _url: String?
    
    class func dynamoDBTableName() -> String {
        return "newsreader-mobilehub-429622615-NewYorkTimesArticle"
    }
    
    class func hashKeyAttribute() -> String {
        return "_objectId"
    }
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
            "_objectId" : "objectId",
            "_abstract" : "abstract",
            "_byline" : "byline",
            "_publishDate" : "publish_date",
            "_section" : "section",
            "_subsection" : "subsection",
            "_title" : "title",
            "_url" : "url",
        ]
    }
}
