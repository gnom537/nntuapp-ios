//
//  teacherStorage.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 26.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation

struct teacher : Hashable, Codable {
    let name: String
    let position : String
    
    let disciplines: String?
    let educationLevel : String?
    let qualification: String?
    let academicDegree: String?
    let academicRank: String?
    let specialty: String?
    let moreEducation: String?
    let experience: String?
    let specExperience: String?
    
    let phone: String?
    let email: String?
    let branch: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: teacher, rhs: teacher) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Set where Element == teacher {
    func findTeacher(_ name: String) -> [teacher] {
        return self.filter({$0.name.uppercased().contains(name.uppercased())})
    }
}

func loadTeachers() -> Set<teacher>{
    let teacherString = try? String(contentsOf: teacherURL)
    if (teacherString == nil) {return Set<teacher>()}
    let teacherData = Data(teacherString!.utf8)
    
    let decoder = JSONDecoder()
    
    if let teachers = try? decoder.decode(Set<teacher>.self, from: teacherData){
        return teachers
    }
    return Set<teacher>()
}

func getTeachersForTableView(_ input: Set<teacher>) -> [teacher] {
    return Array(input).sorted(by: {$0.name < $1.name})
}

func getPairs(_ tchr: teacher) -> [(String, String)]{
    var result = [(String, String)]()
    if (tchr.branch != nil) {result.append(("Филиал", tchr.branch!))}
    if (tchr.disciplines != nil) {result.append(("Преподаваемые дисциплины", tchr.disciplines!))}
    if (tchr.educationLevel != nil) {result.append(("Уровень образования", tchr.educationLevel!))}
    if (tchr.qualification != nil) {result.append(("Квалификация", tchr.qualification!))}
    if (tchr.academicDegree != nil) {result.append(("Учёная степень", tchr.academicDegree!))}
    if (tchr.academicRank != nil) {result.append(("Учёное звание", tchr.academicRank!))}
    if (tchr.specialty != nil) {result.append(("Направление подготовки и (или) специальности", tchr.specialty!))}
    if (tchr.moreEducation != nil) {result.append(("Повышение квалификации и (или) профессиональная переподготовка", tchr.moreEducation!))}
    return result
}

func getContacts(_ tchr: teacher) -> [(String, String)] {
    var result = [(String, String)]()
    if (tchr.phone != nil) {result.append(("Контактный телефон", tchr.phone!))}
    if (tchr.email != nil) {result.append(("Электронная почта", tchr.email!))}
    return result
}

func getExperience(_ tchr: teacher) -> (String, String)? {
    if let stage = tchr.experience {
        if let specStage = tchr.specExperience {
            return (stage, specStage)
        }
    }
    return nil
}

func getNameNPosition(_ tchr: teacher) -> (String, String) {
    return (tchr.name, tchr.position)
}
