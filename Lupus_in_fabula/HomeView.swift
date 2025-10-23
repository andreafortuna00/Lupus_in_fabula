//
//  HomeView.swift
//  Lupus_in_fabula
//
//  Created by Andrea Fortuna on 20/10/25.
//

import SwiftUI

struct HomeView: View {
    @State private var roomCode: String = ""
    @State private var isHost: Bool = false
    @State private var goToLobby: Bool = false
    @State private var showParticipantsSheet: Bool = false
    @State private var showJoinRoomSheet: Bool = false
    @State private var participantsCount: Int = 10
    @State private var generatedRoomCode: String = ""
    @State private var enteredCode: [String] = ["", "", "", "", "", ""]
    @State private var showErrorAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    // Titolo in alto
                    HStack {
                        Text("Lupus in Fabula")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 80)

                    Spacer()

                    VStack(spacing: 15) {
                        // Pulsante "Crea stanza"
                        Button {
                            showParticipantsSheet = true
                        } label: {
                            Text("Crea stanza")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: 250, alignment: .center)
                                .padding()
                                .background(Color.brandBlue)
                                .cornerRadius(30)
                        }

                        // Pulsante "Inserisci codice stanza"
                        Button {
                            showJoinRoomSheet = true
                        } label: {
                            Text("Inserisci codice stanza")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 250, alignment: .center)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 60)
                }
            }
            .ignoresSafeArea(.keyboard)

            // Navigazione verso Lobby
            .navigationDestination(isPresented: $goToLobby) {
                LobbyView(
                    isHost: isHost,
                    roomCode: generatedRoomCode,
                    participantsCount: participantsCount
                )
            }

            // Sheet per inserimento codice
            .sheet(isPresented: $showJoinRoomSheet) {
                JoinRoomView(
                    enteredCode: $enteredCode,
                    showErrorAlert: $showErrorAlert,
                    onJoin: {
                        let code = enteredCode.joined()
                        if code.count == 6 && !code.contains("") {
                            generatedRoomCode = code
                            isHost = false
                            goToLobby = true
                            showJoinRoomSheet = false
                            enteredCode = ["", "", "", "", "", ""]
                        } else {
                            showErrorAlert = true
                        }
                    }
                )
            }

            // Sheet selezione giocatori (altezza massima 500 pt)
            .sheet(isPresented: $showParticipantsSheet) {
                SelectPlayersView(
                    participantsCount: $participantsCount,
                    onStart: {
                        generatedRoomCode = generateRoomCode()
                        isHost = true
                        goToLobby = true
                        showParticipantsSheet = false
                    }
                )
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
            }
        }
    }
}

// MARK: - JoinRoomView
struct JoinRoomView: View {
    @Binding var enteredCode: [String]
    @Binding var showErrorAlert: Bool
    @FocusState private var focusedField: Int?
    @Environment(\.dismiss) private var dismiss
    var onJoin: () -> Void
    
    var body: some View {
        ZStack {
            Image("JoinRoomBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 80)
                
                VStack(spacing: 30) {
                    VStack(spacing: 12) {
                        Text("Inserisci il codice")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Inserisci il codice della stanza per entrare\nnella partita e iniziare a giocare.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(0..<6, id: \.self) { index in
                            CodeInputField(
                                text: $enteredCode[index],
                                focusedField: $focusedField,
                                index: index,
                                totalFields: 6,
                                allFields: $enteredCode
                            )
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 40)
                
                Spacer()
                
                Button(action: onJoin) {
                    Text("Inizia a giocare")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 25/255, green: 45/255, blue: 85/255))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(28)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedField = 0
            }
        }
        .alert("Codice non valido", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Inserisci un codice di 6 caratteri per continuare.")
        }
    }
}

// MARK: - SelectPlayersView
struct SelectPlayersView: View {
    @Binding var participantsCount: Int
    @Environment(\.dismiss) private var dismiss
    var onStart: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 13/255, green: 32/255, blue: 65/255),   // 0D2041
                    Color(red: 32/255, green: 88/255, blue: 171/255)   // 2058AB
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 40)

                VStack(spacing: 12) {
                    Text("Quanti giocatori parteciperanno\nalla partita?")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .lineLimit(nil) // nessun limite di righe
                        .fixedSize(horizontal: false, vertical: true) // evita il troncamento
                }

                .padding(.top, 30)

                VStack(spacing: 24) {
                    HStack(spacing: 50) {
                        Button {
                            if participantsCount > 6 { participantsCount -= 1 }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(participantsCount > 6 ? .white : .gray)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .strokeBorder(participantsCount > 6 ? .white : Color.white.opacity(0.3), lineWidth: 2)
                                )
                        }
                        .disabled(participantsCount <= 6)

                        Text("\(participantsCount)")
                            .font(.system(size: 130, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(minWidth: 90)

                        Button {
                            if participantsCount < 24 { participantsCount += 1 }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(participantsCount < 24 ? .white : .gray)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .strokeBorder(participantsCount < 24 ? .white : Color.white.opacity(0.3), lineWidth: 2)
                                )
                        }
                        .disabled(participantsCount >= 24)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 30)

                Spacer()

                Button(action: onStart) {
                    Text("Inizia a giocare")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 25/255, green: 45/255, blue: 85/255))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(28)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
                .padding(.top, 20)
            }
        }
        .frame(maxHeight: 400) // <-- finestra massimo 500 pt
    }
}

// MARK: - CodeInputField
struct CodeInputField: View {
    @Binding var text: String
    @FocusState.Binding var focusedField: Int?
    let index: Int
    let totalFields: Int
    @Binding var allFields: [String]
    
    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(width: 50, height: 64)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == index ? Color.white : Color.clear, lineWidth: 2)
                    )
            )
            .focused($focusedField, equals: index)
            .keyboardType(.asciiCapable)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > 1 { text = String(newValue.prefix(1)) }
                if newValue.count == 1 && index < totalFields - 1 { focusedField = index + 1 }
                if newValue.isEmpty && !oldValue.isEmpty && index > 0 { focusedField = index - 1 }
            }
    }
}

// MARK: - LobbyView
struct LobbyView: View {
    let isHost: Bool
    let roomCode: String
    let participantsCount: Int

    @Environment(\.dismiss) private var dismiss
    @State private var showRulesSheet: Bool = false
    @State private var elapsedTime: Int = 0
    @State private var timerActive = false
    @State private var timer: Timer?
    @State private var showEndAlert = false
    @State private var gameRoles: [GameRole] = []
    @State private var showCopiedToast = false

    var formattedTime: String {
        let hours = elapsedTime / 3600
        let minutes = (elapsedTime % 3600) / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Codice stanza + icona copia
                HStack(spacing: 8) {
                    Text("Codice stanza:")
                        .font(.headline)

                    Text(roomCode)
                        .font(.title2)
                        .bold()

                    Button(action: copyRoomCode) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                }

                if showCopiedToast {
                    Text("✅ Copiato negli appunti")
                        .font(.caption)
                        .foregroundColor(.green)
                        .transition(.opacity)
                }

                Text("\(participantsCount) giocatori")
                    .foregroundColor(.secondary)

                Divider()

                if isHost {
                    Text("Sei il Narratore")
                        .font(.headline)

                    Text("⏱️ Tempo partita: \(formattedTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .onAppear {
                            startTimer()
                            generateRoles()
                        }
                        .onDisappear {
                            stopTimer()
                        }

                    // Riassunto carte usate
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Carte usate in questa partita:")
                            .font(.headline)
                            .padding(.top, 8)

                        ForEach(roleSummary(), id: \.0) { (role, count) in
                            Text("• \(role): \(count)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)

                    Spacer()

                    // Pulsante Termina partita
                    Button(role: .destructive) {
                        showEndAlert = true
                    } label: {
                        Text("Termina partita")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                } else {
                    Text("In attesa che il Narratore avvii la partita")
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Lobby")
            .navigationBarBackButtonHidden(true)
            .alert("Termina partita?", isPresented: $showEndAlert) {
                Button("Annulla", role: .cancel) { }
                Button("Termina", role: .destructive) {
                    endGame()
                }
            } message: {
                Text("Sei sicuro di voler terminare la partita?")
            }

            // Pulsante Regole (solo per narratore)
            if isHost {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showRulesSheet = true }) {
                            Text("📖 Regole")
                                .font(.headline)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $showRulesSheet) {
            GameRulesView()
        }
    }

    // MARK: - COPY CODE
    func copyRoomCode() {
        UIPasteboard.general.string = roomCode
        withAnimation {
            showCopiedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedToast = false
            }
        }
    }

    // MARK: - TIMER
    func startTimer() {
        guard !timerActive else { return }
        timerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerActive = false
    }

    // MARK: - ROLES
    func generateRoles() {
        gameRoles = GameSetup.roles(for: participantsCount)
    }

    func roleSummary() -> [(String, Int)] {
        let counts = Dictionary(grouping: gameRoles, by: { $0.rawValue })
            .mapValues { $0.count }
        return counts.sorted { $0.key < $1.key }
    }

    // MARK: - END GAME
    func endGame() {
        stopTimer()
        dismiss()
    }
}

// MARK: - Utility per codice stanza
func generateRoomCode() -> String {
    let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<6).compactMap { _ in characters.randomElement() })
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: - Local Color extension
extension Color {
    static let brandBlue = Color(red: 47/255, green: 85/255, blue: 158/255)
}
