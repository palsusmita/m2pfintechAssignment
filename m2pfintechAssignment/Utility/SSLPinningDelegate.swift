//
//  SSLPinningDelegate.swift
//  m2pfintechAssignment
//
//  Created by susmita on 12/07/24.
//

import Foundation
import Security
import CommonCrypto

class SSLPinningDelegate: NSObject, URLSessionDelegate {
    weak var viewModel: MusicVideoViewModel?

    private static let serverPublicKeysHashes = ["o36MT1FCmuBhdR9Oe3ngoK0/b4/iuNo+P9uOXahjeAs="]
    private static let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        SSLPinningDelegate.validateChallenge(challenge, viewModel: viewModel, completionHandler: completionHandler)
    }

    static func validateChallenge(_ challenge: URLAuthenticationChallenge, viewModel: MusicVideoViewModel?, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult: CFError? = nil
                let certTrusted = SecTrustEvaluateWithError(serverTrust, &secresult)
                let certCount = SecTrustGetCertificateCount(serverTrust)

                if certTrusted && certCount > 0 {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0), // 0 is the leaf certificate
                       let publicKey = SecCertificateCopyKey(serverCertificate),
                       let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? {
                        
                        var keyWithHeader = Data(rsa2048Asn1Header)
                        keyWithHeader.append(publicKeyData)
                        let digest = sha256(data: keyWithHeader)
                        let digestString = digest.base64EncodedString()
                        
                        if serverPublicKeysHashes.contains(digestString) {
                            // Pinning successful
                            print(String(format: "Pinning successful: %@ %@", challenge.protectionSpace.host, digestString))
                            completionHandler(.useCredential, URLCredential(trust: serverTrust))
                            return
                        } else {
                            print(String(format: "Pinning failed: %@ %@", challenge.protectionSpace.host, digestString))
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        DispatchQueue.main.async {
            viewModel?.delegate?.showAlert(message: "SSL Pinning failed. Do you want to continue?")
        }
        print(String(format: "Challenge failed: %@", challenge.protectionSpace.host))
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    private static func sha256(data: Data) -> Data {
        var hash = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = hash.withUnsafeMutableBytes { digestBytes in
            data.withUnsafeBytes { messageBytes in
                CC_SHA256(messageBytes.baseAddress, CC_LONG(data.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        return hash
    }
}
