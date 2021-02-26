import Foundation

// MARK: - Wildcard

/// Converter from wildcard pattern
/// to regular expression
public struct Wildcard {

    // MARK: - Properties

    /// Pattern value
    let pattern: String

    // MARK: - Initializers

    /// Default initializer
    /// - Parameter pattern: pattern value
    public init(pattern: String) {
        self.pattern = pattern
    }

    // MARK: - Public
    
    /// Translate wildcard pattern to regular expression pattern
    ///
    /// - Returns: Regular expression pattern string
    public func regexPattern() -> String {
        let patternChars = [Character](pattern)
        var result = ""
        var index = 0
        var inGroup = false
        while index < patternChars.count {
            let char = patternChars[index]
            switch char {
            case "*":
                while(index + 1 < patternChars.count && patternChars[index + 1] == "*") {
                    index += 1
                }
                result.append(".*")
            case "/", "$", "^", "+", ".", "(", ")", "=", "!", "|":
                result.append("\\\(char)")
            case "[", "]":
                result.append(char)
            case "\\":
                if index + 1 < patternChars.count {
                    result.append("\\")
                    result.append(patternChars[index + 1])
                    index += 1
                } else {
                    result.append("\\\\")
                }
            case "?":
                result.append(".")
            case "{":
                inGroup = true
                result.append("(")
            case "}":
                inGroup = false
                result.append(")")
            case ",":
                if inGroup {
                    result.append("|")
                } else {
                    result.append("\\\(char)")
                }
            default:
                result.append(char)
            }
            index += 1
        }
        
        return "^\(result)$"
    }
    
    /// Obtain regular expression object from wildcard pattern
    ///
    /// - Returns: An instance of NSRegularExpression
    public func regex(caseInsensitive: Bool = true) throws -> NSRegularExpression {
        var options: NSRegularExpression.Options = [.anchorsMatchLines]
        if caseInsensitive {
            options = options.union([.caseInsensitive])
        }
        return try NSRegularExpression(pattern: regexPattern(), options: options)
    }
    
    /// Checks that given string match to wildcard pattern
    public func check(_ string: String, caseInsensitive: Bool = true) -> Bool {
        var options: String.CompareOptions = [.regularExpression]
        if caseInsensitive {
            options = options.union([.caseInsensitive])
        }
        return string.range(of: regexPattern() , options: options) != nil
    }
}
