//
//  Task.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 25.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import Foundation
import CoreData

enum Priority: Int {
    case low = 1
    case medium = 2
    case high = 3
}

struct Task {
    let id: Int
    let title: String
    let description: String?
    let subject: String?
    let priority: Priority?
    let deadline: Date
    var done: Bool
}

struct NetworkTask: Codable {
    let id: Int
    let title: String
    let description: String
    let subject: String
    let priority: Int
    let deadline: TimeInterval
}

struct NetworkTasks: Codable {
    let tasks: [NetworkTask]
}

extension Task {
    init(from nt: NetworkTask) {
        self.id = nt.id
        self.title = nt.title
        self.description = nt.description
        self.subject = nt.subject
        self.priority = Priority(rawValue: nt.priority) ?? .low
        self.deadline = Date.init(timeIntervalSince1970: nt.deadline)
        self.done = false
    }
}

// Core Data things
extension Task {
    init(from cd: TaskData) {
        self.id = Int(cd.id)
        self.title = cd.title ?? ""
        self.description = cd.desc
        self.subject = cd.subject
        self.priority = Priority(rawValue: Int(cd.priority)) ?? .low
        self.deadline = cd.deadline ?? Date()
        self.done = cd.done
    }
}

extension Task: Equatable, Hashable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.subject == rhs.subject &&
        lhs.priority == rhs.priority &&
        lhs.deadline == rhs.deadline
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(subject)
        hasher.combine(priority?.rawValue ?? 0)
        hasher.combine(deadline)
    }
}

extension Task: Comparable {
    static func < (lhs: Task, rhs: Task) -> Bool {
        lhs.deadline < rhs.deadline
    }
}

// Network and JSON things
extension NetworkTask {
    init(from t: Task) {
        self.id = t.id
        self.title = t.title
        self.description = t.description ?? ""
        self.subject = t.subject ?? ""
        self.priority = t.priority?.rawValue ?? 0
        self.deadline = t.deadline.timeIntervalSince1970
    }

    var jsonString: String? {
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(self) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension Date {
    var dayInEra: Int {
        let cal = Calendar.init(identifier: .gregorian)
        let day = cal.ordinality(of: .day, in: .era, for: self)!
        return day
    }
    var shortString: String {
        let df = DateFormatter()
        df.dateFormat = "d MMMM, EEE"
        return df.string(from: self)
    }
}

extension Priority {
    var description: String {
        switch self {
        case .low: return "низкий"
        case .medium: return "средний"
        case .high: return "высокий"
        }
    }
}
