//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by ssg on 7/4/24.
//

import SwiftUI

// https://nuli.navercorp.com/community/article/1133220
/// 커스텀 슬라이더 (제어센터 UI)
struct CustomSlider: View {
    enum Orientation { case vertical, horizontal }
    @Binding var value: Double
    @State private var percentRate: Double = 0
    var label: String = ""
    var min: Double = 0
    var max: Double = 100
    var orientation: Orientation = .horizontal
    var trackColor: Color?
    var sliderColor: Color?
    /// 간격
    var step: Double = 1
    
    private var labelIsHidden: Bool {
        label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        let layout = orientation == .horizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        layout {
            if orientation == .horizontal && !labelIsHidden {
                Text("**\(label)**").dynamicTypeSize(.large) // ** markdown 볼드체, dynamicTypeSize 시스템 설정에 따라 글꼴 크기 자동 조절
            }
            GeometryReader { reader in
                ZStack (alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(trackColor ?? Color.primary)
                    
                    if orientation == .horizontal {
                        Rectangle().frame(width: reader.size.width * percentRate)
                            .foregroundStyle(sliderColor ?? Color.accentColor)
                    } else {
                        Rectangle().frame(height: reader.size.height * percentRate)
                            .foregroundStyle(sliderColor ?? Color.accentColor)
                    }
                }.gesture(DragGesture(minimumDistance: 0).onChanged { act in
                    if orientation == .horizontal {
                        let tr = act.location.x > reader.size.width ? reader.size.width : (
                            act.location.x < 0 ? 0 : act.location.x)
                        let rawValue = max * (tr / reader.size.width)
                        value = round(rawValue / step) * step // 값을 step 간격으로 반올림
                    } else if orientation == .vertical {
                        let tr = act.location.y > reader.size.height ? reader.size.height : (
                            act.location.y < 0 ? 0 : act.location.y)
                        let rawValue = max * (1.0 - tr / reader.size.height)
                        value = round(rawValue / step) * step // 값을 step 간격으로 반올림
                    }
                })
            }.clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(width: orientation == .horizontal ? 120 : 40, height: orientation == .horizontal ? 40 : 120)
                .onChange(of: value) { _, new in
                    percentRate = new / max
                    let gen = UINotificationFeedbackGenerator()
                    if new == max || new == min {
                        gen.notificationOccurred(.success)
                    }
                }.onAppear { percentRate = value / max }
            if orientation == .vertical && !labelIsHidden {
                Text("**\(label)**").dynamicTypeSize(.large) // ** markdown 볼드체, dynamicTypeSize 시스템 설정에 따라 글꼴 크기 자동 조절
            }
        }
    }
}

// https://www.reddit.com/r/SwiftUI/comments/17aruvw/comment/k5enzge/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
// 프리뷰에서 @Binding 뷰 보기
#Preview {
    struct Preview: View {
        @State var value: Double = 0
        @State var value2: Double = 0
        
        var body: some View {
            VStack {
                CustomSlider(value: $value)
                CustomSlider(
                    value: $value2,
                    label: "제어센터UI",
                    orientation: .vertical,
                    trackColor: .black.opacity(0.9),
                    sliderColor: .gray
                )
            }
        }
    }
    return Preview()
}
