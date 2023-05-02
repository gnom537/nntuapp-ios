//
//  TaskProvider.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 25.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import Foundation

enum TaskError: Error {
    case noData
    case parsingError
    case other(_ err: Error)
}

final class TaskProvider {
    typealias DataCompletion = (Result<Data, TaskError>) -> Void
    typealias TaskArrayCompletion = (Result<[Task], TaskError>) -> Void
    typealias EmptyCompletion = (Result<Void, Error>) -> Void

    func combine(local: [Task], net: [Task]) -> [Task] {
        let localDict = local.dictionary
        var netDict = net.dictionary
        for key in netDict.keys {
            if let localTask = localDict[key] {
                netDict[key]!.done = localTask.done
            }
        }
        return Array(netDict.values)
    }

    func get(group: String, local: [Task], completion: @escaping TaskArrayCompletion) {
        download(group: group) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(netTasks):
                let combined = self.combine(local: local, net: netTasks)
                completion(.success(combined))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func download(group: String, completion: @escaping TaskArrayCompletion) {
        let req = TaskRequest.get(group: group)
        request(url: req.url, completion: { result in
            switch result {
            case let .success(data):
                print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(NetworkTasks.self, from: data) else {return}
                let tasks = result.tasks.map {Task(from: $0)}
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
    }

    func upload(task: Task, group: String, completion: @escaping EmptyCompletion) {
        let req = TaskRequest.add(task: task, groupName: group)
        request(url: req.url, completion: { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
    }

    func delete(id: Int, completion: @escaping EmptyCompletion) {
        let req = TaskRequest.delete(id: id)
        request(url: req.url) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func request(url: URL?, completion: @escaping DataCompletion) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(.other(error!)))
                return
            }
            guard let data = data else {return}
            completion(.success(data))
        }.resume()
    }
}

extension Array where Element == Task {
    var dictionary: [Int: Task] {
        var dict = [Int: Task]()
        for element in self {
            dict[element.id] = element
        }
        return dict
    }
}
