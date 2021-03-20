//
//  JobModel.swift
//  GithubJobs
//
//  Created by Oscar Odon on 20/03/2021.
//

import Foundation

struct Job: Codable {
    var type: String?
    var url: String?
    var createdAt: String?
    var company: String
    var companyUrl: String?
    var location: String?
    var title: String
    var description: String?
    var howToApply: String?
    var companyLogo: String?
}
