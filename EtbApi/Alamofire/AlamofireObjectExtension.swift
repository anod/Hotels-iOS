//
// Created by Alex Gavrishev on 7/8/15.
// Copyright (c) 2015 Alex Gavrishev. All rights reserved.
//

import Alamofire

@objc public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject)
}

@objc public protocol ResponseCollectionSerializable {
    static func collection(response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T>) -> Void) -> Self {
            let responseSerializer = GenericResponseSerializer<T> { request, response, data in

                print(response)

                let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
                let JSONResult = JSONResponseSerializer.serializeResponse(request, response, data)

            if JSONResult.isSuccess {
                return Result.Success(T(response: response!, representation: JSONResult.value!))
            } else {
                return Result.Failure(JSONResult.data, JSONResult.error!)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<[T]>) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<[T]> { request, response, data in
            print(response)
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let JSONResult = JSONSerializer.serializeResponse(request, response, data)
            
            if JSONResult.isSuccess {
                return Result.Success(T.collection(response!, representation: JSONResult.value!))
            } else {
                return Result.Failure(JSONResult.data, JSONResult.error!)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}