//
//  Token.swift
//  flox1
//
//  Created by Jim Truher on 1/24/17.
//  Copyright © 2017 James Truher. All rights reserved.
//

import Foundation

enum TokenType {
    // Single-character tokens.
    case LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE,
    COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,
    
    // One or two character tokens.
    BANG, BANG_EQUAL,
    EQUAL, EQUAL_EQUAL,
    GREATER, GREATER_EQUAL,
    LESS, LESS_EQUAL,
    
    // Literals.
    IDENTIFIER, STRING, NUMBER,
    
    // Keywords.
    AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
    PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,
    
    EOF
}

class Token: CustomStringConvertible, CustomDebugStringConvertible {
    var type: TokenType;
    var lexeme: String;
    var literal: AnyObject?;
    var line: Int;
    
    init(type: TokenType, lexeme: String, literal: AnyObject?, line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }
    
    var description: String {
        return "\(type) \(lexeme) \(String(describing: literal))"
    }
    
    var debugDescription: String {
        return "\(type) \(lexeme) \(String(describing: literal))"
    }
    
}
