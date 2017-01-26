//
//  APDUResponse.swift
//  SecurityKeyBLE
//
//  Created by Benjamin P Toews on 9/12/16.
//  Copyright © 2016 GitHub. All rights reserved.
//

import Foundation

struct APDUResponse<ResponseType:APDUResponseDataProtocol>: APDUMessageProtocol {
    typealias DataType = APDUResponseDataProtocol
    
    let data: ResponseType
    let trailer: APDUResponseTrailer
    
    var raw: Data {
        let writer = DataWriter()
        writer.writeData(data.raw)
        writer.writeData(trailer.raw)
        return writer.buffer
    }
    
    init(data d: ResponseType) {
        data = d
        trailer = APDUResponseTrailer(data: data)
    }
    
    init(raw: Data) throws {
        let reader = DataReader(data: raw)
        
        let dData = try reader.readData(reader.remaining - 2)
        data = try ResponseType(raw: dData)
        trailer = try APDUResponseTrailer(raw: reader.rest)
    }
}
