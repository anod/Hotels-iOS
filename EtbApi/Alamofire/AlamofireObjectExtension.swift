//
// Created by Alex Gavrishev on 7/8/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import Alamofire

@objc public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

@objc public protocol ResponseCollectionSerializable {
    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<T> { request, response, data in
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON, serializationError) = JSONResponseSerializer.serializeResponse(request, response, data)
            
            if let response = response, JSON: AnyObject = JSON {
                return (T(response: response, representation: JSON), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<[T]> { request, response, data in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON, serializationError) = JSONSerializer.serializeResponse(request, response, data)
            
            if let response = response, JSON: AnyObject = JSON {
                return (T.collection(response, representation: JSON), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}