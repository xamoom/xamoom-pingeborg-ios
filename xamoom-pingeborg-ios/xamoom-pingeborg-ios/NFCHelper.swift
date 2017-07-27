//
//  NFCHelper.swift
//  pingeb.org
//
//  Created by Raphael Seher on 27/07/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

import Foundation
import CoreNFC

class NFCHelper : NSObject {
  var session: NFCNDEFReaderSession!
  var onNFCResult: ((Bool, String) -> ())?

  override init() {
    super.init()
    session = NFCNDEFReaderSession(delegate: self, queue: nil,
                                   invalidateAfterFirstRead: true)
  }
  
  func startNFCScanning() {
    if (!session.isReady) {
      recreateSession()
    }
    session?.begin()
  }
  
  func recreateSession() {
    session = NFCNDEFReaderSession(delegate: self, queue: nil,
                                  invalidateAfterFirstRead: true)
  }
}

extension NFCHelper : NFCNDEFReaderSessionDelegate {
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    guard let onNFCResult = onNFCResult else {
      return
    }
    onNFCResult(false, error.localizedDescription)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
      print(" - \(message.records.count) Records:")
      for record in message.records {
        print("\t- TNF (TypeNameFormat): \(record.typeNameFormat))")
        print("\t- Payload: \(String(data: record.payload, encoding: .utf8)!)")
        print("\t- Type: \(record.type)")
        print("\t- Identifier: \(record.identifier)\n")
      }
    }
    
    guard let onNFCResult = onNFCResult else {
      return
    }
    for message in messages {
      for record in message.records {
        if(record.payload.count > 0) {
          if let payloadString = String.init(data: record.payload, encoding: .utf8) {
            let index = payloadString.index(payloadString.startIndex, offsetBy: 1)
            onNFCResult(true, payloadString.substring(from: index))
          }
        }
      }
    }
  }
}
