//
//  LaTeXView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI
import WebKit

struct LaTeXView: UIViewRepresentable {
    let latex: String
    let fontSize: CGFloat
    
    init(latex: String, fontSize: CGFloat = 18) {
        self.latex = latex
        self.fontSize = fontSize
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
            <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
            <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
            <script>
                window.MathJax = {
                    tex: {
                        inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
                        displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']]
                    },
                    svg: {
                        fontCache: 'global'
                    }
                };
            </script>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    font-size: \(fontSize)px;
                    line-height: 1.6;
                    padding: 8px;
                    margin: 0;
                    background-color: transparent;
                    color: #000000;
                }
                @media (prefers-color-scheme: dark) {
                    body {
                        color: #ffffff;
                    }
                }
            </style>
        </head>
        <body>
            <div id="math">\\[\(latex)\\]</div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}

#Preview {
    LaTeXView(latex: "a^3 \\times a^{\\frac{1}{2}} = a^n")
        .frame(height: 100)
}
