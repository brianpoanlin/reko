//
//  reko+String.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import Foundation

extension String {
    func type() -> CardType {
        let map: [String : CardType] = [
            "WE"    :   CardType.WorkExperience,
            "PI"    :   CardType.PersonalInfo,
            "SK"    :   CardType.Skills,
            "ED"    :   CardType.Education,
            "AW"    :   CardType.Awards,
            "VL"    :   CardType.Volunteering,
            "CW"    :   CardType.Coursework
        ]
        
        return map[self] ?? CardType.WorkExperience
    }
}
