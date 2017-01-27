//
//  Scanner.swift
//  flox1
//
//  Created by Jim Truher on 1/24/17.
//  Copyright © 2017 James Truher. All rights reserved.
//

import Foundation

class Scanner {
    var source: String
    var tokens: [Token]
    
    var start: Int
    var current: Int
    var line: Int
    
    var keywords: [String: TokenType]
    
    init(source: String) {
        self.source = source
        self.start = 0
        self.current = 0
        self.line = 1
        self.tokens = []
        self.keywords = [:]
        self.keywords["and"] = TokenType.AND
        self.keywords["class"] = TokenType.CLASS
        self.keywords["else"] = TokenType.ELSE
        self.keywords["false"] = TokenType.FALSE
        self.keywords["for"] = TokenType.FOR
        self.keywords["fun"] = TokenType.FUN
        self.keywords["if"] = TokenType.IF
        self.keywords["nil"] = TokenType.NIL
        self.keywords["or"] = TokenType.OR
        self.keywords["print"] = TokenType.PRINT
        self.keywords["return"] = TokenType.RETURN
        self.keywords["super"] = TokenType.SUPER
        self.keywords["this"] = TokenType.THIS
        self.keywords["true"] = TokenType.TRUE
        self.keywords["var"] = TokenType.VAR
        self.keywords["while"] = TokenType.WHILE
    }
    
    func scanTokens() -> [Token] {
        while (!isAtEnd()) {
            start = current
            scanToken()
        }
    
        tokens.append(Token(type: TokenType.EOF, lexeme: "", literal: nil, line: line))
        
        return tokens
    }
    
    func scanToken() {
        let c = advance();
        switch (c) {
            case "(": addToken(type: TokenType.LEFT_PAREN); break;
            case ")": addToken(type: TokenType.RIGHT_PAREN); break;
            case "{": addToken(type: TokenType.LEFT_BRACE); break;
            case "}": addToken(type: TokenType.RIGHT_BRACE); break;
            case ",": addToken(type: TokenType.COMMA); break;
            case ".": addToken(type: TokenType.DOT); break;
            case "-": addToken(type: TokenType.MINUS); break;
            case "+": addToken(type: TokenType.PLUS); break;
            case ";": addToken(type: TokenType.SEMICOLON); break;
            case "*": addToken(type: TokenType.STAR); break;
            case "!": addToken(type: match(expected: "=") ? TokenType.BANG_EQUAL : TokenType.BANG); break;
            case "=": addToken(type: match(expected: "=") ? TokenType.EQUAL_EQUAL : TokenType.EQUAL); break;
            case "<": addToken(type: match(expected: "=") ? TokenType.LESS_EQUAL : TokenType.LESS); break;
            case ">": addToken(type: match(expected: "=") ? TokenType.GREATER_EQUAL : TokenType.GREATER); break;
            case "/":
                if (match(expected: "/")) {
                    // A comment goes until the end of the line.
                    while (peek() != "\n" && !isAtEnd()) {
                        let _ = advance();
                    }
                } else {
                    addToken(type: TokenType.SLASH);
                }
                break;
            // Ignore whitespace.
            case " ": break;
            case "\r": break;
            case "\t": break;
            
            case "\n":
                line += 1
                break;

            case "\"": string(); break;
            default:
                if (isDigit(c: c)) {
                    number();
                } else if (isAlpha(c: c)) {
                    identifier();
                } else {
                    Lox.error(line: line, message: "Unexpected character.")
                }
            break;
        }
    }

    func identifier() {
        while (isAlphaNumeric(c: peek())) {
            let _ = advance()
        }
        
        let text = source[start ..< current];
        
        if let type = self.keywords[text] {
            addToken(type: type)
        } else {
            addToken(type: TokenType.IDENTIFIER)
        }

    }
    
    func isAlpha(c : String) -> Bool {
        // TODO: this can't be right.
        let letters = CharacterSet.letters
        
        for uni in c.unicodeScalars {
            return letters.contains(uni) || uni == "_"
        }
        return false
    }
    
    func isAlphaNumeric(c : String) -> Bool {
        return isAlpha(c: c) || isDigit(c: c)
    }

    func isDigit(c: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        
        for uni in c.unicodeScalars {
            return digits.contains(uni)
        }
        return false
    }
    
    func number() {
        while (isDigit(c: peek())) {
            let _ = advance();
        }
        
        // Look for a fractional part.
        if (peek() == "." && isDigit(c: peekNext())) {
            // Consume the "."
            let _ = advance();
        
            while (isDigit(c: peek())) {
                let _ = advance();
            }
        }
        
        addToken(type: TokenType.NUMBER, literal: Double(source[start ..< current]) as AnyObject?)
    }

    
    func string() {
        while (peek() != "\"" && !isAtEnd()) {
            if (peek() == "\n") {
                line += 1;
            }
            let _ = advance();
        }
        
        // Unterminated string.
        if (isAtEnd()) {
            Lox.error(line: line, message: "Unterminated string.")
            return;
        }
        
        // The closing ".
        let _ = advance();
        
        // Trim the surrounding quotes.
//        let value = source.substring(start + 1, current - 1);
        let value = source[start + 1 ..< current - 1]
        addToken(type: TokenType.STRING, literal: value as AnyObject?)
    }

    
    func peek() -> String {
        if (current >= source.characters.count) {
            return "\0";
        }
        return source[current];
    }
    
    func peekNext() -> String {
        if (current + 1 >= source.characters.count) {
            return "\0";
        }
        return source[current + 1];
    }


    func advance() -> String {
        current += 1
        return "\(source[source.index(source.startIndex, offsetBy: current - 1)])"
    }
    
    func addToken(type: TokenType) {
        addToken(type: type, literal: nil)
    }
    
    func addToken(type: TokenType, literal: AnyObject?) {
//        let text = source[ start ..<  start + current ]
        let text = source[ start ..<  current ]
        tokens.append(Token(type: type, lexeme: text, literal: literal, line: line));
    }

    func match(expected: String) -> Bool {
        if (isAtEnd()) {
           return false;
        }
        
        if (source[current] != expected) {
            return false;
        }
        
        current += 1;
        return true;
    }

    
    func isAtEnd() -> Bool {
        return current >= source.characters.count
    }
}
