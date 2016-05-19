//
//  NewYorkTimesArticleTable.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.2
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileHubHelper
class NewYorkTimesArticleTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var sortKeyName: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {
        return "NewYorkTimesArticle"
    }
    
    override init() {
        model = NewYorkTimesArticle()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        indexes = [
        ]
        if (model.classForCoder.respondsToSelector("rangeKeyAttribute")) {
            sortKeyName = model.classForCoder.rangeKeyAttribute!()
        }
        super.init()
    }
    
    /**
     * Converts the attribute name from data object format to table format.
     *
     * - parameter dataObjectAttributeName: data object attribute name
     * - returns: table attribute name
     */

    func tableAttributeName(dataObjectAttributeName: String) -> String {
        return NewYorkTimesArticle.JSONKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    func getItemDescription() -> String {
        return "Find Item with objectId = '\("demo-objectId-500000")'."
    }
    
    func getItemWithCompletionHandler(completionHandler: (response: AWSDynamoDBObjectModel?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        objectMapper.load(NewYorkTimesArticle.self, hashKey: "demo-objectId-500000", rangeKey: nil, completionHandler: {(response: AWSDynamoDBObjectModel?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func scanDescription() -> String {
        return "Show all items in the table."
    }
    
    func scanWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 5
        objectMapper.scan(NewYorkTimesArticle.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func scanWithFilterDescription() -> String {
        return "Find all items with abstract < '\("demo-abstract-500000")'."
    }
    
    func scanWithFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#abstract < :abstract"
        scanExpression.expressionAttributeNames = ["#abstract": "abstract" ,]
        scanExpression.expressionAttributeValues = [":abstract": "demo-abstract-500000" ,]
        objectMapper.scan(NewYorkTimesArticle.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func insertSampleDataWithCompletionHandler(completionHandler: (errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        var errors: [NSError] = []
        let group: dispatch_group_t = dispatch_group_create()
        let numberOfObjects = 20
        
        let itemForGet = NewYorkTimesArticle()
        
        itemForGet._objectId = "demo-objectId-500000"
        itemForGet._abstract = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("abstract")
        itemForGet._byline = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("byline")
        itemForGet._publishDate = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("publish_date")
        itemForGet._section = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("section")
        itemForGet._subsection = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("subsection")
        itemForGet._title = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("title")
        itemForGet._url = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("url")
        
        
        dispatch_group_enter(group)
        
        objectMapper.save(itemForGet, completionHandler: {(error: NSError?) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    errors.append(error!)
                })
            }
            dispatch_group_leave(group)
        })
        
        for _ in 1..<numberOfObjects {
            let item: NewYorkTimesArticle = NewYorkTimesArticle()
            item._objectId = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("objectId")
            item._abstract = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("abstract")
            item._byline = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("byline")
            item._publishDate = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("publish_date")
            item._section = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("section")
            item._subsection = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("subsection")
            item._title = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("title")
            item._url = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("url")
            
            dispatch_group_enter(group)
            
            objectMapper.save(item, completionHandler: {(error: NSError?) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        errors.append(error!)
                    })
                }
                dispatch_group_leave(group)
            })
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            if errors.count > 0 {
                completionHandler(errors: errors)
            }
            else {
                completionHandler(errors: nil)
            }
        })
    }
    
    func removeSampleDataWithCompletionHandler(completionHandler: (errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "begins_with(#objectId, :objectId)"
        scanExpression.expressionAttributeNames = ["#objectId": "objectId"]
        scanExpression.expressionAttributeValues = [":objectId": "demo-"]
        objectMapper.scan(NewYorkTimesArticle.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: NSError?) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(errors: [error]);
                    })
            } else {
                var errors: [NSError] = []
                let group: dispatch_group_t = dispatch_group_create()
                for item in response!.items {
                    dispatch_group_enter(group)
                    objectMapper.remove(item, completionHandler: {(error: NSError?) -> Void in
                        if error != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                errors.append(error!)
                            })
                        }
                        dispatch_group_leave(group)
                    })
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), {
                    if errors.count > 0 {
                        completionHandler(errors: errors)
                    }
                    else {
                        completionHandler(errors: nil)
                    }
                })
            }
        }
    }
    
    func updateItem(item: AWSDynamoDBObjectModel, completionHandler: (error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        let itemToUpdate: NewYorkTimesArticle = item as! NewYorkTimesArticle
        
        itemToUpdate._abstract = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("abstract")
        itemToUpdate._byline = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("byline")
        itemToUpdate._publishDate = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("publish_date")
        itemToUpdate._section = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("section")
        itemToUpdate._subsection = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("subsection")
        itemToUpdate._title = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("title")
        itemToUpdate._url = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("url")
        
        objectMapper.save(itemToUpdate, completionHandler: {(error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(error: error)
            })
        })
    }
    
    func removeItem(item: AWSDynamoDBObjectModel, completionHandler: (error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        objectMapper.remove(item, completionHandler: {(error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(error: error)
            })
        })
    }
}