//
//  Completions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 11.05.2022.
//

import Foundation

typealias UserModelCompletion = (Result<UserModel, Error>) -> Void
typealias UrlCompletion = (Result<[URL], Error>) -> Void
typealias VoidCompletion = (Result<Void, Error>) -> Void
typealias StringsCompletion = (Result<[String], Error>) -> Void

