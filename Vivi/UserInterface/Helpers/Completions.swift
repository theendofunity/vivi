//
//  Completions.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 11.05.2022.
//

import Foundation
import FirebaseFirestore

typealias UserModelCompletion = (Result<UserModel, Error>) -> Void
typealias UrlsCompletion = (Result<[URL], Error>) -> Void
typealias UrlCompletion = (Result<URL, Error>) -> Void
typealias OptionalUrlCompletion = (String?) -> Void

typealias VoidCompletion = (Result<Void, Error>) -> Void
typealias StringsCompletion = (Result<[String], Error>) -> Void

typealias DocumentsCompletion = (Result<[FirestoreSavable], Error>) -> Void
typealias ProjectsCompletion = (Result<[ProjectModel], Error>) -> Void

typealias ChatsCompletion = (Result<[ChatModel], Error>) -> Void
typealias ChatCompletion = (Result<ChatModel, Error>) -> Void

typealias MessagesCompletion = (Result<[MessageModel], Error>) -> Void




