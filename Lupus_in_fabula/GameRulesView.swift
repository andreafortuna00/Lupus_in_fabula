//
//  GameRulesView.swift
//  Lupus_in_fabula
//
//  Created by Andrea Fortuna on 20/10/25.
//

import SwiftUI

struct GameRulesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    RuleRow(
                        icon: "target",
                        title: "Obiettivo",
                        content: """
                        Lupi Mannari: Eliminare tutti gli umani
                        Umani: Linciare tutti i Lupi Mannari
                        """
                    )
                }
                
                Section("Personaggi") {
                    // Base
                    RuleRow(
                        icon: "person.3.fill",
                        title: "Lupi Mannari",
                        content: "Di notte scelgono chi sbranare",
                        badge: "BASE"
                    )
                    
                    RuleRow(
                        icon: "person.fill",
                        title: "Villici",
                        content: "Umani senza poteri speciali",
                        badge: "BASE"
                    )
                    
                    RuleRow(
                        icon: "eye.fill",
                        title: "Veggente",
                        content: "Ogni notte può scoprire il ruolo di un giocatore",
                        badge: "BASE"
                    )
                    
                    RuleRow(
                        icon: "person.badge.key.fill",
                        title: "Moderatore",
                        content: "Gestisce il gioco (non gioca)",
                        badge: "BASE"
                    )
                    
                    // Speciali
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "sparkles",
                        name: "Medium",
                        minPlayers: 9,
                        description: "Ogni notte (dalla 2ª), scopre se il linciato del giorno prima era un Lupo"
                    )) {
                        CharacterRow(icon: "sparkles", name: "Medium", minPlayers: 9)
                    }
                    
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "flame.fill",
                        name: "Indemoniato",
                        minPlayers: 10,
                        description: "Umano che vince con i Lupi (ma non sa chi sono)"
                    )) {
                        CharacterRow(icon: "flame.fill", name: "Indemoniato", minPlayers: 10)
                    }
                    
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "shield.fill",
                        name: "Guardia del corpo",
                        minPlayers: 11,
                        description: "Ogni notte protegge un giocatore (non se stesso) dagli attacchi dei Lupi"
                    )) {
                        CharacterRow(icon: "shield.fill", name: "Guardia del corpo", minPlayers: 11)
                    }
                    
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "bird.fill",
                        name: "Gufo",
                        minPlayers: 12,
                        description: "Ogni notte sceglie un giocatore che diventa automaticamente indiziato il giorno dopo"
                    )) {
                        CharacterRow(icon: "bird.fill", name: "Gufo", minPlayers: 12)
                    }
                    
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "building.columns.fill",
                        name: "Massoni",
                        minPlayers: 13,
                        description: "Due umani che si riconoscono nella prima notte"
                    )) {
                        CharacterRow(icon: "building.columns.fill", name: "Massoni", minPlayers: 13)
                    }
                    
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "hare.fill",
                        name: "Criceto Mannaro",
                        minPlayers: 15,
                        description: """
                        • Non può essere sbranato dai Lupi
                        • Se visto dal Veggente, muore
                        • Vince da solo se è l'ultimo sopravvissuto
                        """
                    )) {
                        CharacterRow(icon: "hare.fill", name: "Criceto Mannaro", minPlayers: 15)
                    }
                    
                    NavigationLink(destination: SpecialCharacterDetail(
                        icon: "theatermasks.fill",
                        name: "Mitomane",
                        minPlayers: 16,
                        description: "Nella 2ª notte può copiare il ruolo di un altro giocatore (Lupo o Veggente)"
                    )) {
                        CharacterRow(icon: "theatermasks.fill", name: "Mitomane", minPlayers: 16)
                    }
                }
                
                Section("Fase Notte") {
                    PhaseStep(
                        icon: "moon.fill",
                        number: 1,
                        text: "Tutti chiudono gli occhi e battono una mano sul tavolo"
                    )
                    
                    PhaseStep(
                        icon: "eye.fill",
                        number: 2,
                        text: "Il Veggente apre gli occhi e indica un giocatore. Il moderatore gli rivela se è un Lupo Mannaro"
                    )
                    
                    PhaseStep(
                        icon: "pawprint.fill",
                        number: 3,
                        text: "I Lupi Mannari aprono gli occhi, si riconoscono e scelgono silenziosamente chi sbranare"
                    )
                    
                    PhaseStep(
                        icon: "eye.slash.fill",
                        number: 4,
                        text: "Tutti riaprono gli occhi"
                    )
                }
                
                Section("Fase Giorno") {
                    PhaseStep(
                        icon: "sun.max.fill",
                        number: 1,
                        text: "Il moderatore annuncia chi è stato sbranato (diventa Fantasma)"
                    )
                    
                    PhaseStep(
                        icon: "bubble.left.and.bubble.right.fill",
                        number: 2,
                        text: "Discussione (max 3 minuti): i giocatori cercano di scoprire chi sono i Lupi"
                    )
                    
                    PhaseStep(
                        icon: "hand.raised.fill",
                        number: 3,
                        text: "Prima votazione: Tutti votano chi linciare. I 2 più votati diventano indiziati"
                    )
                    
                    PhaseStep(
                        icon: "megaphone.fill",
                        number: 4,
                        text: "I 2 indiziati si difendono con un breve discorso"
                    )
                    
                    PhaseStep(
                        icon: "checkmark.seal.fill",
                        number: 5,
                        text: "Seconda votazione: Solo i vivi (esclusi indiziati e fantasmi) votano segretamente chi linciare"
                    )
                    
                    PhaseStep(
                        icon: "xmark.circle.fill",
                        number: 6,
                        text: "Il più votato viene linciato (diventa Fantasma)"
                    )
                }
                
                Section("Vittoria") {
                    RuleRow(
                        icon: "trophy.fill",
                        title: "Umani vincono",
                        content: "Se linciano tutti i Lupi Mannari"
                    )
                    
                    RuleRow(
                        icon: "trophy.fill",
                        title: "Lupi vincono",
                        content: "Se diventano in numero pari o superiore agli umani vivi"
                    )
                }
                
                Section("Setup Consigliato") {
                    SetupRow(players: "8 giocatori", setup: "5 Villici + 2 Lupi + 1 Veggente")
                    SetupRow(players: "9+ giocatori", setup: "Aggiungi Villici o personaggi speciali")
                    SetupRow(players: "16+ giocatori", setup: "Aggiungi un 3° Lupo Mannaro")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Regole")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.callout)
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct RuleRow: View {
    let icon: String
    let title: String
    let content: String
    var badge: String? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                    
                    if let badge = badge {
                        Text(badge)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                }
                
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PhaseStep: View {
    let icon: String
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            HStack(alignment: .top, spacing: 8) {
                Text("\(number).")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(text)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PermissionRow: View {
    let allowed: Bool
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: allowed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(allowed ? .green : .red)
                .frame(width: 30)
            
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}

struct SetupRow: View {
    let players: String
    let setup: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.3.fill")
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(players)
                    .font(.headline)
                Text(setup)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CharacterRow: View {
    let icon: String
    let name: String
    let minPlayers: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name)
                        .font(.headline)
                    
                    Text("SPECIALE")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.purple.opacity(0.2))
                        .foregroundColor(.purple)
                        .cornerRadius(4)
                }
                
                Text("\(minPlayers)+ giocatori")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 30)
            
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}

struct SpecialCharacterDetail: View {
    let icon: String
    let name: String
    let minPlayers: Int
    let description: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Giocatori minimi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.accentColor)
                        Text("\(minPlayers)+")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrizione")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(description)
                        .font(.body)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct GameRulesView_Previews: PreviewProvider {
    static var previews: some View {
        GameRulesView()
    }
}
