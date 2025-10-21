import Foundation

enum GameRole: String, CaseIterable {
    case villico = "Villico"
    case lupo = "Lupo Mannaro"
    case veggente = "Veggente"
    case medium = "Medium"
    case indemoniato = "Indemoniato"
    case guardia = "Guardia del Corpo"
    case gufo = "Gufo"
    case massone = "Massone"
    case criceto = "Criceto Mannaro"
    case mitomane = "Mitomane"
}

struct GameSetup {
    /// Restituisce il mazzo di ruoli in base al numero di giocatori
    static func roles(for players: Int) -> [GameRole] {
        var roles: [GameRole] = []

        switch players {
        case 8:
            // Regola base: 5 villici, 2 lupi, 1 veggente
            roles += Array(repeating: .villico, count: 5)
            roles += Array(repeating: .lupo, count: 2)
            roles.append(.veggente)

        case 9...15:
            // Regola: 5 villici, 2 lupi, 1 veggente + ruoli speciali casuali
            roles += Array(repeating: .villico, count: 5)
            roles += Array(repeating: .lupo, count: 2)
            roles.append(.veggente)

            // Aggiungi carte extra (specificando tipo)
            let extraRoles: [GameRole] = [
                .medium, .indemoniato, .guardia, .gufo,
                .massone, .massone, .criceto, .mitomane
            ].shuffled()

            let extraCount = players - 8
            roles += Array(extraRoles.prefix(extraCount))

        default:
            // 16 o più giocatori → 3 lupi
            roles += Array(repeating: .villico, count: 5)
            roles += Array(repeating: .lupo, count: 3)
            roles.append(.veggente)

            let extraRoles: [GameRole] = [
                .medium, .indemoniato, .guardia, .gufo,
                .massone, .massone, .criceto, .mitomane
            ].shuffled()

            let extraCount = players - 9
            roles += Array(extraRoles.prefix(extraCount))
        }

        return roles.shuffled()
    }
}
