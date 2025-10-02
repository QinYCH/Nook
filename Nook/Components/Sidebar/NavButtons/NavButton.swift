//
//  NavButton.swift
//  Nook
//
//  Created by Maciek Bagiński on 30/07/2025.
//

import SwiftUI

struct NavButton: View {
    var iconName: String
    var disabled: Bool
    var action: (() -> Void)?
    var onLongPress: (() -> Void)?
    @State private var isHovering: Bool = false
    @State private var isPressing: Bool = false
    @State private var longPressTimer: Timer?

    init(iconName: String, disabled: Bool = false, action: (() -> Void)? = nil, onLongPress: (() -> Void)? = nil) {
        self.iconName = iconName
        self.action = action
        self.disabled = disabled
        self.onLongPress = onLongPress
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            Image(systemName: iconName)
                .font(.system(size: 16))
                .foregroundStyle(disabled ? AppColors.textQuaternary : AppColors.textSecondary)
                .padding(4)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer, options: .nonRepeating))
                .scaleEffect(isPressing && !disabled ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressing)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill((isHovering || isPressing) && !disabled ? AppColors.controlBackgroundHover : Color.clear)
                .frame(width: 24, height: 24) // Fixed 20x20 square
                .animation(.easeInOut(duration: 0.15), value: isHovering)
        )
        .onHover { hovering in
            isHovering = hovering
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !disabled && !isPressing {
                        isPressing = true
                        startLongPressTimer()
                    }
                }
                .onEnded { _ in
                    if isPressing {
                        isPressing = false
                        cancelLongPressTimer()
                    }
                }
        )
    }

    private func startLongPressTimer() {
        longPressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if isPressing {
                onLongPress?()
                isPressing = false
            }
        }
    }

    private func cancelLongPressTimer() {
        longPressTimer?.invalidate()
        longPressTimer = nil
    }
}
