//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import AFNetworking
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

protocol Cancelable {
    func cancel()
}

class BlockCancelable: Cancelable {
    private let block: () -> ()

    init(withCancelBlock cancelBlock: @escaping () -> ()) {
        block = cancelBlock
    }

    func cancel() {
        block()
    }
}

class MarvelAPIAdapter {
    enum APIMethod: String {
        case characters = "/v1/public/characters"
    }

    enum RequestParameter: String {
        case apiKey = "apikey"
        case timestamp = "ts"
        case hash = "hash"
        case offset = "offset"
        case limit = "limit"
    }

    enum APIResponse<T> {
        case success(result: T)
        case error(message: String)
    }

    static let shared = MarvelAPIAdapter()

    private let manager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager(baseURL: URL(string: "https://gateway.marvel.com/"))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        return manager
    }()

    private init() {

    }

    func loadCharacters(offset: Int = 0, limit: Int = 20, completion: @escaping (APIResponse<CharacterListResponse>) -> ()) -> Cancelable {
        let params: [String: Any] = [
            RequestParameter.offset.rawValue: offset,
            RequestParameter.limit.rawValue: limit
        ]
        let task = manager.get(APIMethod.characters.rawValue,
                parameters: defaultParameters().merged(withDict: params),
                progress: nil,
                success: { task, response in
                    let dataDict = (response as! [AnyHashable: AnyHashable])["data"]
                    let JSONData = try! JSONSerialization.data(withJSONObject: dataDict as Any, options: .prettyPrinted)
                    let listResponse = try! JSONDecoder().decode(CharacterListResponse.self, from: JSONData)
                    completion(.success(result: listResponse))
                },
                failure: { task, error in
                    completion(.error(message: "\(error)"))
                }
        )
        return BlockCancelable {
            task?.cancel()
        }
    }

    private func defaultParameters() -> [String: Any] {
        let ts = timestamp()
        return [
            RequestParameter.timestamp.rawValue: ts,
            RequestParameter.apiKey.rawValue: DebugKeyStoreManager.shared.publicKey!,
            RequestParameter.hash.rawValue: md5Digest(withTimestamp: ts)
        ]
    }

    private func timestamp() -> String {
        "\(Date().timeIntervalSince1970)"
    }

    private func md5Digest(withTimestamp timestamp: String) -> String {
        let digest = md5Digest(withString: timestamp + DebugKeyStoreManager.shared.privateKey! + DebugKeyStoreManager.shared.publicKey!)
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()

    }

    private func md5Digest(withString string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using: .utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

}
