//
//  DBService.swift
//
//  Created by Alex Paul on 2/17/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct ReviewersCollectionKeys {
  static let CollectionKey = "reviewers"
  static let ReviewerIdKey = "reviewerId"
  static let DisplayNameKey = "displayName"
  static let FirstNameKey = "firstName"
  static let LastNameKey = "lastName"
  static let EmailKey = "email"
  static let PhotoURLKey = "photoURL"
  static let JoinedDateKey = "joinedDate"
}

struct ReviewsCollectionKeys {
  static let CollectionKey = "reviews"
  static let ReviewDescritionKey = "ReviewDescription"
  static let ReviewerIdKey = "reviewerId"
  static let CreatedDateKey = "createdDate"
  static let DocumentIdKey = "documentId"
  static let ImageURLKey = "imageURL"
}

final class DBService {
  private init() {}
  
  public static var firestoreDB: Firestore = {
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
  }()
  
  static public var generateDocumentId: String {
    return firestoreDB.collection(ReviewersCollectionKeys.CollectionKey).document().documentID
  }
  
  static public func createReviewer(reviewer: Reviewer, completion: @escaping (Error?) -> Void) {
    firestoreDB.collection(ReviewersCollectionKeys.CollectionKey)
      .document(reviewer.reviewerId)
      .setData([ ReviewsCollectionKeys.ReviewerIdKey : reviewer.reviewerId,
                                            ReviewersCollectionKeys.DisplayNameKey : reviewer.displayName,
                                            ReviewersCollectionKeys.EmailKey       : reviewer.email,
                                            ReviewersCollectionKeys.PhotoURLKey    : reviewer.photoURL ?? "",
                                            ReviewersCollectionKeys.JoinedDateKey  : reviewer.joinedDate
    ]) { (error) in
      if let error = error {
        completion(error)
      } else {
        completion(nil)
      }
    }
  }
  
  static public func postReview(review: Review) {
    firestoreDB.collection(ReviewsCollectionKeys.CollectionKey)
      .document(review.documentId).setData([
                                          ReviewsCollectionKeys.CreatedDateKey     : review.createdDate,
                                          ReviewsCollectionKeys.ReviwerId          : review.reviewerId,
                                          ReviewsCollectionKeys.ReviewDescritionKey: review.reviewDescription,
                                          ReviewsCollectionKeys.ImageURLKey        : review.imageURL,
                                          ReviewsCollectionKeys.DocumentIdKey      : review.documentId
      ])
    { (error) in
      if let error = error {
        print("posting reviewe error: \(error)")
      } else {
        print("review posted successfully to ref: \(review.documentId)")
      }
    }
  }
}
