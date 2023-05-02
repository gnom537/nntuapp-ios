//
//  TaskRequest.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 26.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import Foundation

enum TaskRequest {
    case get(group: String)
    case add(task: Task, groupName: String)
    case delete(id: Int)
}

extension TaskRequest {
    private var queryItems: [URLQueryItem] {
        switch self {
        case let .get(group):
            return [URLQueryItem(name: "method", value: "get"),
                URLQueryItem(name: "groupName", value: group)]
        case let .add(task, groupName):
            // TODO: task.json
            return [
                URLQueryItem(name: "method", value: "add"),
                URLQueryItem(name: "task", value: NetworkTask(from: task).jsonString),
                URLQueryItem(name: "groupName", value: groupName)
            ]
        case let .delete(id):
            return [URLQueryItem(name: "method", value: "delete"),
                URLQueryItem(name: "id", value: "\(id)")]
        }
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "194.58.97.17"
        components.port = 3002
        components.queryItems = queryItems
        return components.url
    }
}
