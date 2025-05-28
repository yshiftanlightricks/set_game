//
//  ContentView.swift
//  SetGame
//
//  Created by Yonatan Shiftan on 27/05/2025.
//

import SwiftUI

extension SetGameModel.CardColor {
  var color: Color {
    switch self {
    case .red: return .red
    case .green: return .green
    case .yellow: return .yellow
    }
  }
}

struct CardView: View {
  let card: SetGameModel.Card
  var isSelected: Bool
  var chosenSetNotificationState: ChosenSetNotificationState

  var body: some View {
    let foregroundColor: Color = {
      let defaultColor = Color.black
      if !isSelected {
        return defaultColor
      }
      else {
        switch chosenSetNotificationState {
        case .none:
          return .black
        case .correct:
          return .green
        case .incorrect:
          return .red
        }
      }
    }()

    GeometryReader { geometry in
      ZStack {
        RoundedRectangle(cornerRadius: 10)
          .stroke(lineWidth: 3)
          .foregroundColor(foregroundColor)
          .background(RoundedRectangle(cornerRadius: 10).fill(isSelected ? .orange : .white))

        VStack(spacing: 5) {
          ForEach(0..<card.numberOfShapes, id: \.self) { _ in
            shapeView()
              .aspectRatio(2/1, contentMode: .fit) // maintain shape aspect ratio
              .frame(width: geometry.size.width * 0.6)
          }
        }
        .padding()
      }
    }
    .aspectRatio(2/3, contentMode: .fit)
    .frame(minWidth: 50)
   }

  @ViewBuilder
  private func shapeView() -> some View {
    let color = card.color.color

    if card.shape == .diamond {
      filledShape(Diamond(), color: color)
    }
    else if card.shape == .squiggle {
      filledShape(Squiggle(), color: color)
    }
    else if card.shape == .oval {
      filledShape(Capsule(), color: color)
    }
  }

  func filledShape<S: Shape>(_ shape: S, color: Color) -> some View {
    switch card.fill {
    case .solid:
      AnyView(shape.fill(color))
    case .empty:
      AnyView(shape.stroke(color, lineWidth: 2))
    case .striped:
      AnyView(shape.stroke(color, lineWidth: 2)
        .background(Stripes().foregroundColor(color).mask(shape)))
    }
  }
}

struct Diamond: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.midX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
      path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
      path.closeSubpath()
    }
  }
}

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Start point (left side, middle)
        let startPoint = CGPoint(x: 0, y: height * 0.5)
        path.move(to: startPoint)

        // Create the squiggle using cubic Bezier curves
        // Top curve - swoops up and right
        path.addCurve(
            to: CGPoint(x: width * 0.4, y: height * 0.1),
            control1: CGPoint(x: width * 0.1, y: height * 0.2),
            control2: CGPoint(x: width * 0.25, y: height * 0.05)
        )

        // Top-right curve - continues right with slight dip
        path.addCurve(
            to: CGPoint(x: width * 0.8, y: height * 0.3),
            control1: CGPoint(x: width * 0.55, y: height * 0.15),
            control2: CGPoint(x: width * 0.7, y: height * 0.2)
        )

        // Right end curve - swoops down to the right end
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.5),
            control1: CGPoint(x: width * 0.9, y: height * 0.4),
            control2: CGPoint(x: width * 0.95, y: height * 0.45)
        )

        // Bottom-right curve - starts the return journey
        path.addCurve(
            to: CGPoint(x: width * 0.6, y: height * 0.9),
            control1: CGPoint(x: width * 0.9, y: height * 0.8),
            control2: CGPoint(x: width * 0.75, y: height * 0.95)
        )

        // Bottom curve - continues left with upward bump
        path.addCurve(
            to: CGPoint(x: width * 0.2, y: height * 0.7),
            control1: CGPoint(x: width * 0.45, y: height * 0.85),
            control2: CGPoint(x: width * 0.3, y: height * 0.8)
        )

        // Left end curve - completes the shape back to start
        path.addCurve(
            to: startPoint,
            control1: CGPoint(x: width * 0.1, y: height * 0.6),
            control2: CGPoint(x: width * 0.05, y: height * 0.55)
        )

        return path
    }
}

struct Stripes: View {
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        for x in stride(from: 0, to: geometry.size.width, by: 4) {
          path.move(to: CGPoint(x: x, y: 0))
          path.addLine(to: CGPoint(x: x, y: geometry.size.height))
        }
      }
      .stroke(lineWidth: 1)
    }
  }
}

#Preview {
  VStack {
    CardView(card: SetGameModel.Card(shape: .diamond, color: .green, fill: .solid, numberOfShapes: 3), isSelected: false, chosenSetNotificationState: .none)
  }
}
