//
//  NetworkManager.swift
//  Test
//
//  Created by bdankovych on 06.10.2022.
//

import Alamofire
import Moya

typealias RequestSuccess = (Response) -> Void
typealias RequestFailure = (DefaultError) -> Void

protocol MockableTargetType {
    static var sampleResponseClosure: ((TargetType) -> (Endpoint.SampleResponseClosure))? { get set }
}

extension TargetType {
    
    fileprivate static func castToMockable() -> MockableTargetType.Type? {
        return Self.self as? MockableTargetType.Type
    }
    
    fileprivate static func getManager(for endpoint: Self) -> NetworkManager<Self> {
        if ProcessInfo.processInfo.environment["TESTING"] == "1" {
            return NetworkManager<Self>(sampleResponseClosure: Self.castToMockable()?.sampleResponseClosure)
        } else {
            return NetworkManager<Self>()
        }
    }
}

class NetworkManager<T> where T: TargetType {
    
    private var sessionConfig: URLSessionConfiguration {
        let configs = URLSessionConfiguration.default
        configs.requestCachePolicy = .reloadIgnoringLocalCacheData
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        configs.urlCache = nil
        return configs
    }
    
    private func createSession() -> Session {
        return Session(configuration: sessionConfig)
    }
        
    // Stub results if we're testing, otherwise return a provider with our custom manager
    private func createProvider(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping) -> MoyaProvider<T> {
        if ProcessInfo.processInfo.environment["TESTING"] == "1" {
            return MoyaProvider<T>.init(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub, callbackQueue: DispatchQueue.main, session: session)
        } else {
            return MoyaProvider<T>(session: session, plugins: [])
        }
    }
    
    private var session: Session!
    
    internal var provider: MoyaProvider<T> {
        if let sampleResponseClosure = sampleResponseClosure {
            let customEndpointClosure = { (target: T) -> Endpoint in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: sampleResponseClosure(target),
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            }
            return createProvider(endpointClosure: customEndpointClosure)
        } else {
            return createProvider()
        }
    }
    
    private var sampleResponseClosure: ((TargetType) -> (Endpoint.SampleResponseClosure))?
    
    init(sampleResponseClosure: ((TargetType) -> (Endpoint.SampleResponseClosure))? = nil) {
        session = createSession()
        self.sampleResponseClosure = sampleResponseClosure
    }
    
    /// Basic request handler for handling network requests and responses
    ///
    /// - Parameters:
    ///   - endpoint: `TargetType` endpoint
    ///   - success: `RequestSuccess` closure
    ///   - failure: `RequestFailure` closure
    func request(endpoint: T, success: @escaping RequestSuccess, failure: @escaping RequestFailure) {
        URLCache.shared.removeAllCachedResponses()
        print("Request: ", endpoint.baseURL, "/", endpoint.path)
        provider.request(endpoint) { result in
            print("Result: ", result)
            switch result {
            case let .success(response):
                success(response)
            case let .failure(error):
                print("Error: ", error)
                failure(.networkError(error))
            }
        }
    }
}

extension TargetType {
    
    static func request<T: Decodable>(_ endpoint: Self, codable: T.Type, success: @escaping (T) -> Void, failure: @escaping RequestFailure) {
        getManager(for: endpoint).request(endpoint: endpoint, success: { response in
            let result = T.decodeObject(T.self, data: response.data)
            switch result {
            case .success(let decodable):
                print("Decoded: ", decodable)
                success(decodable)
            case .failure(let error):
                failure(.apiError(message: error.localizedDescription))
            }
        }) { error in
            failure(error)
        }
    }
    
    /// Generic `PUT` request for a `TargetType` endpoint
    ///
    /// - Parameters:
    ///   - endpoint: `TargetType` endpoint
    ///   - success: success closure
    ///   - failure: failure closure
    static func request(_ endpoint: Self, success: @escaping () -> Void, failure: @escaping RequestFailure) {
        getManager(for: endpoint).request(endpoint: endpoint, success: { _ in
            success()
        }) { error in
            failure(error)
        }
    }
    
    static func request(_ endpoint: Self, success: @escaping RequestSuccess, failure: @escaping RequestFailure) {
        getManager(for: endpoint).request(endpoint: endpoint, success: { response in
            success(response)
        }) { error in
            failure(error)
        }
    }
}
