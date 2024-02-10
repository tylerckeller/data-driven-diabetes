//
//  DexcomService.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//
import Foundation
import OAuthSwift


class DexcomService {
    private let apiUrl = "https://sandbox-api.dexcom.com"
    private let clientId = "dub6uFaRhftPedGRuNt2AeB7iECDpnVM"
    private let clientSecret = "zWCSnPB7bJON41IN"
    private let redirectUri = "https://www.tylerkeller.dev/oauth-callback"
    private let authorizationEndpoint = "https://sandbox-api.dexcom.com/v2/oauth2/login"
    
    var oauthswift: OAuth2Swift?

    func connectToDexcomPressed() {
        
        let oauthswift = OAuth2Swift(
            consumerKey: clientId,
            consumerSecret: clientSecret,
            authorizeUrl: authorizationEndpoint,
            responseType: "code"
        )
        
        oauthswift.authorize(
            withCallbackURL: URL(string: redirectUri)!,
            scope: "offline_access", state: "DEXCOM") { (result: Result<(credential: OAuthSwiftCredential, response: OAuthSwiftResponse?, parameters: [String: Any]), OAuthSwiftError>) in
                switch result {
                case .success(let credential):
                    print(credential)

                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
        self.oauthswift = oauthswift
    }

    func fetchEGVs(startDate: String, endDate: String, completion: @escaping (Result<EGV, Error>) -> Void) {
        guard let oauthClient = self.oauthswift?.client else {
            completion(.failure(NSError(domain: "DexcomService", code: -1, userInfo: [NSLocalizedDescriptionKey: "OAuth client not available"])))
            return
        }
        
        let _ = oauthswift?.client.get(
            "\(apiUrl)/v3/users/self/evgs") { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        // Assuming the JSON root is an array of EGV records
                        let egv = try decoder.decode(EGV.self, from: response.data)
                        completion(.success(egv))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
