import SwiftUI

struct KnownWordsView: View {
    let knownWords: [SATWord]
    var onRemove: (SATWord) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if knownWords.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No known words yet")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(knownWords, id: \.word) { word in
                            VStack(spacing: 8) {
                                Text(word.word)
                                    .font(.headline)
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.accentColor)
                                Text(word.definition)
                                    .font(.subheadline)
                                    .foregroundColor(.accent2)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(4)
                                    .minimumScaleFactor(0.5)
                                Button(role: .destructive) {
                                    onRemove(word)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                                .font(.caption)
                                .padding(.top, 4)
                            }
                            .padding()
                            .background(.accent3.opacity(0.5))
                            .cornerRadius(12)
                            .shadow(radius: 3)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Known Words")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
