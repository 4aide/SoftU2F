//
//  DataWriterTests.swift
//  SecurityKeyBLE
//
//  Created by Benjamin P Toews on 9/12/16.
//  Copyright © 2016 GitHub. All rights reserved.
//

import XCTest

class DataWriterTests: XCTestCase {
    func testWrite() throws {
        let writer = DataWriter()
        writer.write(UInt8(0x00))
        writer.write(UInt8(0xFF), endian: .Little)
        writer.write(UInt16(0x0102))
        writer.write(UInt16(0x0102), endian: .Little)
        writer.writeData("AB".data(using: String.Encoding.utf8)!)

        XCTAssertEqual(Data(int: UInt64(0x00FF010202014142)), writer.buffer)
    }
    
    func testCappedWrite() throws {
        let writer = CappedDataWriter(max: 2)
        
        try writer.write(UInt8(0x01))
        
        do {
            try writer.writeData("AB".data(using: String.Encoding.utf8)!)
        } catch CappedDataWriterError.MaxExceeded {
            // pass
        }
        
        do {
            try writer.write(UInt16(0x0102))
        } catch CappedDataWriterError.MaxExceeded {
            // pass
        }
        
        try writer.write(UInt8(0x02))
        
        XCTAssertEqual(Data(int: UInt16(0x0102)), writer.buffer)
    }
}
