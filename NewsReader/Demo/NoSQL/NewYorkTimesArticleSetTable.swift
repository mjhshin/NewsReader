//
//  NewYorkTimesArticleSetTable.swift
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
class NewYorkTimesArticleSetTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var sortKeyName: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {
        return "NewYorkTimesArticleSet"
    }
    
    override init() {
        model = NewYorkTimesArticleSet()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        indexes = [
            NewYorkTimesArticleSetPrimaryIndex(),
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
        return NewYorkTimesArticleSet.JSONKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    func getItemDescription() -> String {
        return "Find Item with objectId = '\("demo-objectId-3")' and acquire_date = '\("demo-acquire_date-500000")'."
    }
    
    func getItemWithCompletionHandler(completionHandler: (response: AWSDynamoDBObjectModel?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        objectMapper.load(NewYorkTimesArticleSet.self, hashKey: "demo-objectId-3", rangeKey: "demo-acquire_date-500000", completionHandler: {(response: AWSDynamoDBObjectModel?, error: NSError?) -> Void in
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
        objectMapper.scan(NewYorkTimesArticleSet.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func scanWithFilterDescription() -> String {
        return "Find all items with num_articles < '\(1111500000)'."
    }
    
    func scanWithFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#numArticles < :numArticles"
        scanExpression.expressionAttributeNames = ["#numArticles": "num_articles" ,]
        scanExpression.expressionAttributeValues = [":numArticles": 1111500000 ,]
        objectMapper.scan(NewYorkTimesArticleSet.self, expression: scanExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
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
        
        let itemForGet = NewYorkTimesArticleSet()
        
        itemForGet._objectId = "demo-objectId-3"
        itemForGet._acquireDate = "demo-acquire_date-500000"
        itemForGet._articles = NoSQLSampleDataGenerator.randomSampleStringArray()
        itemForGet._numArticles = NoSQLSampleDataGenerator.randomSampleNumber()
        
        
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
            let item: NewYorkTimesArticleSet = NewYorkTimesArticleSet()
            item._objectId = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("objectId")
            item._acquireDate = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("acquire_date")
            item._articles = NoSQLSampleDataGenerator.randomSampleStringArray()
            item._numArticles = NoSQLSampleDataGenerator.randomSampleNumber()
            
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
        objectMapper.scan(NewYorkTimesArticleSet.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: NSError?) in
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
        
        let itemToUpdate: NewYorkTimesArticleSet = item as! NewYorkTimesArticleSet
        
        itemToUpdate._articles = NoSQLSampleDataGenerator.randomSampleStringArray()
        itemToUpdate._numArticles = NoSQLSampleDataGenerator.randomSampleNumber()
        
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
class NewYorkTimesArticleSetPrimaryIndex: NSObject, Index {
    
    var indexName: String? {
        return nil
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        return "Find all items with objectId = '\("demo-objectId-3")'."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#objectId = :objectId"
        queryExpression.expressionAttributeNames = ["#objectId": "objectId",]
        queryExpression.expressionAttributeValues = [":objectId": "demo-objectId-3",]
        objectMapper.query(NewYorkTimesArticleSet.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        return "Find all items with objectId = '\("demo-objectId-3")' and num_articles > '\(1111500000)'."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#objectId = :objectId"
        queryExpression.filterExpression = "#numArticles > :numArticles"
        queryExpression.expressionAttributeNames = [
            "#objectId": "objectId",
            "#numArticles": "num_articles",
        ]
        queryExpression.expressionAttributeValues = [
            ":objectId": "demo-objectId-3",
            ":numArticles": 1111500000,
        ]
        
        objectMapper.query(NewYorkTimesArticleSet.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        return "Find all items with objectId = '\("demo-objectId-3")' and acquire_date < '\("demo-acquire_date-500000")'."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#objectId = :objectId AND #acquireDate < :acquireDate"
        queryExpression.expressionAttributeNames = [
            "#objectId": "objectId",
            "#acquireDate": "acquire_date",
        ]
        queryExpression.expressionAttributeValues = [
            ":objectId": "demo-objectId-3",
            ":acquireDate": "demo-acquire_date-500000",
        ]
        
        objectMapper.query(NewYorkTimesArticleSet.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        return "Find all items with objectId = '\("demo-objectId-3")', acquire_date < '\("demo-acquire_date-500000")', and num_articles > '\(1111500000)'."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#objectId = :objectId AND #acquireDate < :acquireDate"
        queryExpression.filterExpression = "#numArticles > :numArticles"
        queryExpression.expressionAttributeNames = [
            "#objectId": "objectId",
            "#acquireDate": "acquire_date",
            "#numArticles": "num_articles",
        ]
        queryExpression.expressionAttributeValues = [
            ":objectId": "demo-objectId-3",
            ":acquireDate": "demo-acquire_date-500000",
            ":numArticles": 1111500000,
        ]
        
        objectMapper.query(NewYorkTimesArticleSet.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
}
