struct PrivateKey {
    let keyID: String
    let issuerID: String
    let rawKey: String

    var extractedKey: String {
        rawKey
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty && !$0.contains("-----") }
            .joined()
    }
}
