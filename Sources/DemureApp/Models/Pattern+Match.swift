import struct DemureAPI.Pattern

// MARK: - Pattern

extension Pattern {
    
    func match(_ string: String) -> Bool {
        let pattern = value
        switch kind {
        case .equal:
            return pattern == string
        case .wildcard:
            return Wildcard(pattern: pattern).check(string)
        case .regexp:
            return string.range(
                of: pattern,
                options: [
                    .regularExpression,
                    .caseInsensitive
                ]
            ) != nil
        }
    }
}
