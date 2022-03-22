//
//  CreditCard.swift
//  CreditCardList
//
//  Created by 구희정 on 2022/03/20.
//

import Foundation

struct CreditCard : Codable {
    let id : Int
    let rank : Int
    let name : String
    let cardImageURL : String
    let promotionDetail : PromotionDetail
    let isSelected : Bool?
}

struct PromotionDetail : Codable {
    let companyName : String
    let amount : Int
    let period : String
    let benefitDate : String
    let benefitDetail : String
    let benefitCondition : String
    let condition : String
}
