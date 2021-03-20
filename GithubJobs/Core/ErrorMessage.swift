//
//  ErrorMessage.swift
//  GithubJobs
//
//  Created by Oscar Odon on 20/03/2021.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidData = "Sorry. Somthing went wrong, try again"
    case invalidResponse = "Server error. Please modify your search and try again"
}
