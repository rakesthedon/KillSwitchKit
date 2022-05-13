//
//  KSConfig.swift
//
//  Created by Yannick Jacques on 2022-05-13.
//

import Foundation

public final class KSKitConfig {

    public var host: String?
    public var port: Int?
    public var scheme: String?

    static let shared: KSKitConfig = .init()

    private init() {}
}
