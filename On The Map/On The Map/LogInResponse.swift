//
//  LogInResponse.swift
//  On The Map
//
//  Created by Mouhamed  on 7/27/20.
//  Copyright © 2020 Mouhamed . All rights reserved.
//

import Foundation

struct LoginResponse: Codable{
    let account: Account
    let session: Session
}
