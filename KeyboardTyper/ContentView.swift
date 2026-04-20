//
//  ContentView.swift
//  KeyboardTyper
//
//  Created by LiYanDong on 2026-04-17.
//
import SwiftUI

struct ContentView: View {
    // 逐行加载文本
    @State private var lines: [String] = []
    @State private var currentLineIndex: Int = 0
    @State private var text: String = ""
    // 只保留字母用于比对
    var filteredText: String {
        text.filter { $0.isLetter }
    }
    @State private var userInput: String = ""
    @State private var correctCount: Int = 0
    @FocusState private var isTextFieldFocused: Bool

    // 只保留用户输入的字母
    var filteredUserInput: String {
        userInput.filter { $0.isLetter }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 右上角统计
            HStack {
                Spacer()
                    Text("\(filteredUserInput.count)/\(correctCount)")
                    .font(.headline)
                    .padding(.trailing)
            }

            // 滚动文本窗口
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 8) {
                        // 显示窗口内的多行文本
                        let windowSize = 5
                        let start = max(0, currentLineIndex - windowSize + 1)
                        let end = currentLineIndex
                        ForEach(start...end, id: \ .self) { idx in
                            let line = lines.indices.contains(idx) ? lines[idx] : ""
                            HStack(spacing: 0) {
                                if idx == currentLineIndex {
                                    // 当前输入行高亮并带颜色
                                    ForEach(Array(line.enumerated()), id: \ .offset) { (index, char) in
                                        let color: Color = {
                                            if index < userInput.count {
                                                let inputChar = userInput[userInput.index(userInput.startIndex, offsetBy: index)]
                                                if inputChar == char {
                                                    return .orange
                                                } else {
                                                    return .red
                                                }
                                            } else if index == userInput.count {
                                                return .black
                                            } else {
                                                return .primary
                                            }
                                        }()
                                        Text(String(char))
                                            .foregroundColor(color)
                                    }
                                } else {
                                    Text(line)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .id(idx)
                        }
                    }
                    .font(.title2)
                    .padding()
                }
                .onChange(of: currentLineIndex) { idx in
                    // 自动滚动到最新一行
                    withAnimation {
                        proxy.scrollTo(idx, anchor: .bottom)
                    }
                }
            }

            // 隐藏的TextField用于输入
            TextField("Type here", text: $userInput)
                .opacity(0.01)
                .accentColor(.clear)
                .focused($isTextFieldFocused)
                .onChange(of: userInput) { newValue in
                    // 限制输入长度
                    if newValue.count > text.count {
                        userInput = String(newValue.prefix(text.count))
                    }
                    // 统计正确数量
                    correctCount = 0
                    for (i, c) in userInput.enumerated() {
                        let targetChar = text[text.index(text.startIndex, offsetBy: i)]
                        if c == targetChar {
                            correctCount += 1
                        }
                    }
                }
                .onSubmit {
                    // 按下回车，切换到下一行
                    if currentLineIndex + 1 < lines.count {
                        currentLineIndex += 1
                        text = lines[currentLineIndex]
                        userInput = ""
                        correctCount = 0
                    } else {
                        // 最后一行，清空输入
                        userInput = ""
                    }
                }
                .padding()
                .background(Color.clear)
                .onAppear {
                    // 自动聚焦
                    isTextFieldFocused = true
                    // 加载文本文件
                    if lines.isEmpty {
                        if let url = Bundle.main.url(forResource: "Unit01", withExtension: "txt"),
                           let content = try? String(contentsOf: url) {
                            let allLines = content.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                            lines = allLines
                            currentLineIndex = 0
                            text = allLines.first ?? ""
                        } else {
                            lines = ["File not found or empty."]
                            text = "File not found or empty."
                        }
                    }
                }
        }
        .padding()
        .onTapGesture {
            // 点击界面聚焦输入
            isTextFieldFocused = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
