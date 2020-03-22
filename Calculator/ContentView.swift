//
//  ContentView.swift
//  Calculator
//
//  Created by 汤小军 on 2020/3/21.
//  Copyright © 2020 汤小军. All rights reserved.
//

import SwiftUI

let scale: CGFloat = UIScreen.main.bounds.width / 414
struct ContentView: View {
        
//    @State private var brain: CalculatorBrain = .left("0")
    @State private var editingHistory = false
    @State  var showingResult: Bool = false
    @EnvironmentObject var model:  CalculatorModel
    var body: some View {
        
        VStack(spacing: 12) {
            Spacer()
            Button("操作记录: \(self.model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.model)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.red)
                .padding(.trailing, 24)
                .lineLimit(1)
                .onTapGesture {
                    print("点击了文本")
                    self.showingResult = true
            }
            .alert(isPresented: $showingResult) { () -> Alert in
                Alert(title: Text(self.model.historyDetail), message: Text(self.model.brain.output), dismissButton: .default(Text("取消")))
            }
           
//            CalculatorButtonPad(model:  model)
                CalculatorButtonPad()
                .padding(.bottom)

        }
    .scaleEffect(scale)
//        print(self.usd_cny)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.colorScheme, .dark).environmentObject(CalculatorModel())
//            ContentView().previewDevice("iPad Air 2")
        }
        
    }
}

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        }
    }
}




struct CalculatorButtonRow: View {
//    @Binding var brain: CalculatorBrain
    @EnvironmentObject var model: CalculatorModel
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(self.row, id: \.self) { item in
                CalculatorButton(title: item.title , size: item.size, backgroundColorName: item.backgroundColorName) {
                    print(item.title)
//                    self.brain = self.brain.apply(item: item)
                    self.model.apply(item)
                }
            }
        }
    }
}


struct CalculatorButtonPad: View {
//    @Binding var brain: CalculatorBrain
//    var model: CalculatorModel


    let pad: [[CalculatorButtonItem]] = [
    [.command(.clear), .command(.flip),
    .command(.percent), .op(.divide)],
    [.digit(7), .digit(8), .digit(9), .op(.multiply)],
    [.digit(4), .digit(5), .digit(6), .op(.minus)],
    [.digit(1), .digit(2), .digit(3), .op(.plus)],
    [.digit(0), .dot, .op(.equal)]
    ]

      var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { row in
//                CalculatorButtonRow(model: self.model, row: row)
                CalculatorButtonRow(row: row)
            }
        }
     }
}



struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有记录")
            } else {
                HStack {
                    Text("记录").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brain.output)")
                }
                
                Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount), step: 1)
            }
        }.padding()
    }
}
