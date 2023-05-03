//
//  encryptFile.swift
//  nntu
//
//  переносим в отдельный файл чтобы игнорить его в гитхабе
//  Created by Алексей Шерстнёв on 12.04.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation

//MARK: - keys()
let postKey = "Vc4hdHaPxfYXUBwk"
let receiveKey = "C9h9UPcqMGUbrc3X"

let teacherURL = URL(string: "http://194.58.97.17/teachers.json")!
let lastIdURL = URL(string: "http://194.58.97.17/events/lastID.json")!

//MARK: - encrypt()
func encrypt (input: String?) -> String? {
    guard let input, !input.isEmpty else { return nil }
    var output = [Character](input)
    let ABC = "-1234567890СДЧЖИЭЫЬВТЕЁЪЦКЩФЗАГЯЛЙОШУБПМРХНЮСДЧЖИЭЫЬВТЕЁЪЦКЩФЗАГЯЛЙОШУБПМРХНЮ"
    let ABCarray = [Character](ABC)
    let smallABC = "-1234567890сдчжиэыьвтеёъцкщфзагялйошубпмрхнюсдчжиэыьвтеёъцкщфзагялйошубпмрню"
    let smallABCarray = [Character](smallABC)
    let now = Date()
    let today = Calendar.current
    let codeNumber = today.component(.day, from: now)
    var j = 0
    
    for i in 0...output.count - 1 {
        if ABC.contains(output[i]) {
            while (j < ABCarray.count){
                if (output[i] == ABCarray[j]){
                    output[i] = ABCarray[j+codeNumber]
                    break
                } else {
                    j += 1
                }
            }
            
        } else {
            if smallABC.contains(output[i]) {
                while j < ABCarray.count {
                    if (output[i] == smallABCarray[j]) {
                        output[i] = smallABCarray[j + codeNumber]
                        break
                    } else {
                        j += 1
                    }
                }
            }
        }
    }
    return String(output)
}
