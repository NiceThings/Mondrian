//
//  CLI.swift
//  MondrianCLI
//
//  Created by Matthew Buckley on 8/22/17.
//  Copyright © 2017 Nice Things. All rights reserved.
//

import Foundation

public final class CLI {

    typealias ArgumentPair = (String, String)
    private var width: Int?
    private var height: Int?
    private var minBlockWidth: Int?
    private var minBlockHeight: Int?

    public init(arguments: [String] = CommandLine.arguments) {

        (1..<arguments.count).forEach { idx in
            let argument = CommandLine.arguments[idx]
            if argument.optionType != .unknown {
                setOption(option: argument, value: arguments[idx + 1])
            }
        }
    }

    public func run() throws {

        guard let width = width,
            let height = height,
            let minBlockHeight = minBlockHeight,
            let minBlockWidth = minBlockWidth else {
            throw MondrianCLIError.args
        }

        let rootRect = RectType(origin: CoordinateType.zero, width: width, height: height)

        let tableau1 = RectType.partitioned(withRootValue: rootRect,
                                            minValue: RectType(origin: CoordinateType.zero, width: minBlockWidth, height: minBlockHeight)) { (parent) -> (RectType, RectType) in

                                                            var c1 = RectType.zero
                                                            var c2 = RectType.zero
                                                            var bisectPt = 0

                                                            if arc4random() % 2 == 0 {
                                                                bisectPt = parent.height / Int(arc4random_uniform(4) + 2)
                                                                c1 = RectType(origin: parent.origin, width: parent.width, height: parent.height - bisectPt)
                                                                c2 = RectType(origin: CoordinateType(x: 0, y: Int(c1.height)), width: parent.width, height: bisectPt)
                                                            } else {
                                                                bisectPt = parent.width / Int(arc4random_uniform(4) + 2)
                                                                c1 = RectType(origin: parent.origin, width: parent.width - bisectPt, height: parent.height)
                                                                c2 = RectType(origin: CoordinateType(x: Int(c1.width), y: 0), width: bisectPt, height: parent.height)
                                                            }


                                                            return (c1, c2)
        }
        print(tableau1)
        print(tableau1.count)

    }

    func setOption(option: String, value: String) {
        switch option.optionType {
        case .width:
            self.width = Int(value)
        case .height:
            self.height = Int(value)
        case .minBlockWidth:
            self.minBlockWidth = Int(value)
        case .minBlockHeight:
            self.minBlockHeight = Int(value)
        default:
            break
        }
    }

}

enum MondrianCLIError: Error {
    case args
}

private extension String {

    var optionType: OptionType {
        switch self {
        case "-w":
            return .width
        case "-h":
            return .height
        case "-minBlockWidth":
            return .minBlockWidth
        case "-minBlockHeight":
            return .minBlockHeight
        default:
            return .unknown
        }
    }

}

enum OptionType: String {
    case width, height, minBlockWidth, minBlockHeight, unknown
}
