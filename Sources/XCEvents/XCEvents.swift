import Foundation
#if os(iOS)
import GameAnalytics
#endif
import Firebase

public enum Events: Sendable {
    case connect_session_start_before
    case connect_session_start
    case connect_session_success
    case connect_session_failed
    case connect_failed // 当单次配置连接失败时触发（连通性测试失败）
    case disconnect
    case review_pop
    case error_domain
    case error_config
    case error_city_api
    case error_city
    case error_node_api
    case error_node_git
    case launch_city_nil
    
    case ad(String)
}

extension Events {
    public var event: String {
        switch self {
        case .connect_session_start_before:
            "connect_session_start_before"
        case .connect_session_start:
            "connect_session_start"
        case .connect_session_success:
        "connect_session_success"
        case .connect_session_failed:
            "connect_session_failed"
        case .connect_failed:
            "connect_failed"
        case .disconnect:
            "disconnect"
        case .review_pop:
            "review_pop"
        case .error_domain:
            "error_domain"
        case .error_config:
            "error_config"
        case .error_city_api:
            "error_city_api"
        case .error_city:
            "error_city"
        case .error_node_api:
            "error_node_api"
        case .error_node_git:
            "error_node_git"
        case .launch_city_nil:
            "launch_city_nil"
        case .ad(let string):
            string
        }
    }
}

extension Events {
    public func fire(_ parameters: (Codable & Sendable)? = nil) {
        Task.detached {
            let json: Dictionary<String, AnyHashable>? = if let parameters = parameters {
                self.encoder(parameters)
            } else {
                nil
            }
            let event = self.event
            await self.fireEvent(event, parameters: json)
        }
    }
    
    private func fireEvent(_ event: String, parameters: Dictionary<String, AnyHashable>? = nil) async {
        await self.firebase(event, parameters: parameters)
        await self.game(event, parameters: parameters)
    }
}

private extension Events {
    func firebase(_ event: String, parameters: Dictionary<String, AnyHashable>? = nil) async {
        Analytics.logEvent(event, parameters: parameters)
    }
}

private extension Events {
    func game(_ event: String, parameters: Dictionary<String, AnyHashable>? = nil) async {
        GameAnalytics.addDesignEvent(withEventId: event, customFields: parameters)
    }
}

private extension Events {
    func encoder<P: Codable>(_ parameters: P) -> Dictionary<String, AnyHashable>? {
        do {
            let data = try JSONEncoder().encode(parameters)
            let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, AnyHashable>
            return json
        } catch {
            return nil
        }
    }
}
