//
//  RepositoryEntity.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation

protocol JSONSerializable{
    static func from(json : Any) throws -> Self
    static func from(listJson : [Any]) throws -> [Self]
    func toJson() -> Any
}
extension JSONSerializable {
    
    static func from(listJson : [Any]) throws -> [Self] {
        return try listJson.map({ (json) -> Self in
            return try  from(json: json)
        })
    }
}

struct RepositoryEntity : JSONSerializable {


    func toJson() -> Any {
        return [:]
    }
    
    static func from(json: Any) throws -> RepositoryEntity {
        guard let json = json as? [String : Any],
            let name = json["name"] as? String,
            let urlStr = json["url"] as? String,
          //  let url = URL(string : urlStr),
            let ownerParams = json["owner"] as? [String : Any],
            let ownerName = ownerParams["login"] as? String
            else {
                throw Errors.MissingDecodingParameter
        }
        
        let description = json["description"] as? String
        let language = json["language"] as? String
        return RepositoryEntity(name: name, description: description , language: language, owner : ownerName)
        
    }
    
    let name : String
    let description : String?
  //  let url : URL
    let language : String?
    let owner : String
    
    
}
