//
//  Errors.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 13/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation


enum Errors : Error {
    case NoError
    case BadWSReturn
    case MissingDecodingParameter
    case NoNetwork
}
