//
//  Lox.swift
//  flox1
//
//  Created by Jim Truher on 1/24/17.
//  Copyright © 2017 James Truher. All rights reserved.
//

import Foundation

class Lox {
    static var hadError = false
    
    func staticMode() {
        let argCount = CommandLine.argc
        
        if (argCount > 2) {
            print("Usage: flox1 [script]")
        } else if (argCount == 2) {
            let argument = CommandLine.arguments[1]
            runFile(path: argument)
        } else {
            runPrompt()
        }

    }
    
    
    func runFile(path: String) {
        do {
            let bytes = try String(contentsOfFile: path)
            run(source: bytes)
        } catch {
            
        }
    }
    
    func runPrompt() {
        while true {
            print("> ", separator: "", terminator: "")
            run(source: readLine()!)
        }
    }

    func run(source: String) {
        let scanner = Scanner(source: source)
        let tokens : [Token] = scanner.scanTokens()
    
        // For now, just print the tokens.
        for token in tokens {
            print(token)
        }
    }
    
    
// Error Handling
    
    class func error(line: Int, message: String) {
        Lox.report(line: line, whereAt: "", message: message);
    }

    class func report(line: Int, whereAt: String, message: String) {
        print("[line \(line)] Error \(whereAt): \(message)")
        Lox.hadError = true;
    }


    
}
