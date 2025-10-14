#set page(numbering: "1")
#show smartquote: set text(font: "New Computer Modern") 

#set par(
    justify: true, 
    first-line-indent: (
        amount: 2em, all: true
    ),
    leading: 0.6em, spacing: 0.75em
)
#set text(
    top-edge: "ascender", 
    bottom-edge: "descender"
) 

#set text(font: (
    (name: "Libertinus Serif", covers: "latin-in-cjk"), // 西文
    "Noto Serif CJK SC" // 中文
  ), lang: "zh")

#show math.equation: set text(font: (
  (name: "Libertinus Serif", covers: "latin-in-cjk"), // 西文
  "Noto Serif CJK SC", // 中文
  "Libertinus Math", // 数学
)) 
#show raw: set text(font: (
  (name: "Maple Mono SC NF", covers: "latin-in-cjk"),
  "Noto Sans CJK SC",
))
#import "@preview/frame-it:1.2.0": *



#set heading(numbering: "一.")

#show link: it => {
  set text(fill: blue)
  text(size: 13pt, font: "Libertinus Sans")[#it.dest]
}

#let example-code(width: 100%, height: auto, body) = {
  align(center)[#rect(
      width: width,
      height: height,
      stroke: (
        paint: gradient.linear(..color.map.rainbow),
        thickness: 2pt, cap: "round",
      )
  )[
    #set align(left); #body
  ]]
}

#let example-image(width: 100%, height: auto, src) = {
    align(
        center,
        rect(
            image(width: width,src)
        )
    )
}

#align(center,text(size: 20pt)[*vscode+LaTeX Workshop+TeXLive配置指南*])

#align(right,text(size: 15pt)[Explorer])

本文将从一名萌新的角度出发, 介绍如何一步步顺利在vscode中配置LaTeX Workshop的设置, 并顺利编译出你的第一份PDF文件.

= 命令行编译

可能有的人会说, 作为萌新用户, 并不需要掌握命令行编译, 或者更有甚者看到需要在「一个黑色框中手动输入代码」就会觉得害怕. 事实上, 这种看法在我看来是较为片面的, 要想真正用好TeXLive, *必须*先掌握「命令行编译」. 

此事在*优秀的安装教程*#link("install-latex-guide-zh-cn")[https://github.com/OsbertWang/install-latex-guide-zh-cn]的第一章中亦有记载, 在顺利安装完TeXLive之后, 首要的便是掌握「命令行编译」.

首先相信每位读到本文的用户面前肯定已经打开了一个`.tex`文件, 它可能是「2077年全国大学生数学竞赛模板」、或者是「广为流传的`elegantbook`系列模板」, 如果你还没有配置好vscode的编译环境, 请先*关闭这些较为复杂的模板*, 先从下面这个「最简单」的例子开始. 

罗马不是一天建成的, 还没学走路就想飞, 只会在配置的过程中遇到更多的问题, 最终因为配置和debug极其麻烦而更容易打退堂鼓.

下面我们来欣赏这个「Hello, World!」的程序:

#example-code[
```latex
\documentclass{ctexart}
\begin{document}
Hello, World!

你好, \LaTeX{}！
\end{document}
```
]

*工欲善其事, 必先利其器.* 在这里有必要顺便强调一下「*编辑器*」和「*编译器*」的区别. 

- *编辑器*（editor） 只不过是用来「编辑文本」用的, 我们这里用到的`vscode`就是这样的工具, 他并没有任何编译的功能. 使用「`vscode`」编写程序和使用「记事本(notepad)」编写程序从其本质来看是没有任何区别的.
- *编译器*（compiler） 才是真正用来「把代码转换成PDF」的工具. 这里我们使用的编译器是`TeXLive`, 它是一个非常庞大的编译器集合, 里面包含了各种各样的编译器. 注意, 你大致可以把编译器理解为「可执行程序（e.g. "Genshin Impact.exe"）」, 这类程序执行的时候, 会按照其内部逻辑处理你的代码, 并根据程序设定好的功能执行任务.

一言以蔽之, 我们在这里要实现的, 是用「vscode」作为代码*编辑器*来编写代码, 并调用我们目标的*编译器*（这里是`TeXLive`中的`pdflatex.exe`、`luatex.exe`等）, 通过这些程序将我们编写的代码转换成目标的PDF文件.

如果你已经仔细阅读了#link("install-latex-guide-zh-cn")[https://github.com/OsbertWang/install-latex-guide-zh-cn]并且顺利安装了TeXLive, 此时在终端中输入`xelatex -v`, 理应看到类似如下的终端输出: 

#[
#set par(leading: 0.75em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
```bash
$ xelatex -v
XeTeX 3.141592653-2.6-0.999997 (TeX Live 2025)
kpathsea version 6.4.1
Copyright 2025 SIL International, Jonathan Kew and Khaled Hosny.
There is NO warranty.  Redistribution of this software is
covered by the terms of both the XeTeX copyright and
the Lesser GNU General Public License.
For more information about these matters, see the file
named COPYING and the XeTeX source.
Primary author of XeTeX: Jonathan Kew.
Compiled with ICU version 76.1; using 76.1
Compiled with zlib version 1.3.1; using 1.3.1
Compiled with FreeType2 version 2.13.3; using 2.13.3
Compiled with Graphite2 version 1.3.14; using 1.3.14
Compiled with HarfBuzz version 10.2.0; using 10.2.0
Compiled with libpng version 1.6.46; using 1.6.46
Compiled with pplib version v2.2
Compiled with fontconfig version 2.15.0; using 2.15.0
```  
]


废话有点多, 我们先来用「命令行编译」第一个`.tex`文件:

首先在系统中的某个新建文件夹下, 新建一个`.tex`文件. 注意, 虽然现在已经是2025年了, 但还是*极其不建议*用户使用「中文文件名」、「带空格的路径」. 请用「`main.tex`」而不是「`我的模板 哈哈哈.tex`」. 后者既有中文, 又有空格, 真是*坏透了*. 然后在这个`.tex`所在的文件夹内, 在空白区域处右键后点击「在终端中打开」或「通过Code打开」:

#example-image(width:100%,"open-terminal.png")

如果找不到这两项, 那么请自行通过搜索引擎检索如何把他们调出来. 这里采用「通过Code打开」作为示例, 如果你不能看到下方的「Terminal」面板, 可以通过快捷键「Ctrl+\`」呼出.

#example-image("vscode-terminal.png")

在vscode的终端中, 注意到当前所在的路径「`E:\..\..\test`」恰好是我们新建的`main.tex`所在的路径. 这就免去了切换工作路径的繁琐. 此时在「Terminal」中输入:

#example-code[
  ```bash
  xelatex main.tex
  ```
]

并回车, 我们预期可以看到这样的场景:

#example-image("compiling.png")

注意到左侧文件夹处出现了一个名为「`main.pdf`」的文件, 这便是我们第一次编译顺利完成的标志. 单击打开, 我们可以看到编译的结果.

= 使用 LaTeXWorkshop 插件辅助编译

洋洋洒洒, 我们却还没有进入主题——*L*\aTeX *W*\orkshop(*LW*) 插件. 但事实上, 我们已经手动实现了编译, 并且得到了最终的PDF文件, 这就对了！事实上, 要想编译一个`.tex`文件, 我们_并不需要_「LaTeX Workshop」！
那么为什么互联网上铺天盖地的文章都在用呢？是因为这个插件实际上只是在帮助我们*自动做*「手动打开终端-根据文件名输入`xelatex main.tex`」这件事而已（设想如果文件名很长, 每次都需要手动输入`pdflatex wileyNJDv5_AMA.tex`会显得尤为繁琐）. 同时由于配置较为复杂, 因此常常成为萌新用户的拦路虎.

首先我们要安装「LaTeX Workshop」插件.

#example-image(width:92.5%,"LW-install.png")

安装之后, 只有*当你创建并打开了一个`.tex`文件*之后, 左侧栏才会出现「TeX图标」

#align(
    center,
    rect(
        image(width: 95%,"TeX-panel.png")
    )
)

注意上图中圈出来的按钮, 分别可以实现「选择不同的编译工具」,「快速编译」,「预览PDF文件」等功能. 当然, 左侧栏中还提供了形如「文件大纲结构」、「Snippet View快捷输入」等功能, 这些留待读者自行探索.

你可能听说过需要配置一个名为`settings.json`的文件, 但这是必须的吗？并不是, LaTeX Workshop贴心地提供了一份*默认*的#link("tools")[https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#latex-tools]配置和#link("recipes")[https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#latex-recipes]配置:

#[
    #set par(leading: 0.75em, spacing: 1em)
    #set text(top-edge: "cap-height", bottom-edge: "baseline") 
```json
"latex-workshop.latex.tools": [
  {
    "name": "latexmk",
    "command": "latexmk",
    "args": [
      "-synctex=1",
      "-interaction=nonstopmode",
      "-file-line-error",
      "-pdf",
      "-outdir=%OUTDIR%",
      "%DOC%"
    ],
    "env": {}
  },
  {
    "name": "pdflatex",
    "command": "pdflatex",
    "args": [
      "-synctex=1",
      "-interaction=nonstopmode",
      "-file-line-error",
      "%DOC%"
    ],
    "env": {}
  },
  {
    "name": "bibtex",
    "command": "bibtex",
    "args": [
      "%DOCFILE%"
    ],
    "env": {}
  }
```
]
以及

#[
#set par(leading: 0.75em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
```json
"latex-workshop.latex.recipes": [
  {
    "name": "latexmk",
    "tools": [
      "latexmk"
    ]
  },
  {
    "name": "pdflatex -> bibtex -> pdflatex * 2",
    "tools": [
      "pdflatex",
      "bibtex",
      "pdflatex",
      "pdflatex"
    ]
  }
]
```
]
为了让这个教程有一定的深度, 我们在这里*有必要*停下来看看这个默认配置.

别被这么多内容吓到, 实际上不过是一些键值对罢了. 例如对于`tools`, 
上面的配置一共提供了三个可用的工具（`tool`）:他们分别名为`latexmk`, `pdflatex`和 `bibtex`. 其对应的`command`, `args`和`env`属性分别以类似「Python」中的字典列出.

这里不加解释的指出, 这些tool实际上就是在控制*LW*如何自动地帮你在终端输入上一节中手动输入过的编译命令. 例如对于`pdflatex`的配置:
#[
#set par(leading: 0.75em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
```json
{
  "name": "pdflatex",
  "command": "pdflatex",
  "args": [
    "-synctex=1",
    "-interaction=nonstopmode",
    "-file-line-error",
    "%DOC%"
  ],
  "env": {}
},
```
]
当*LW*替你执行`pdflatex`这一工具时, 它实际上会执行的是:
```bash
pdflatex -synctex=1 -interaction=nonstopmode -file-line-error <filename>
```
这里的`<filename>`, 在*LW*中使用`%DOC%`来指代, 更多替换规则详见这个#link("关于placeholder的wiki")[https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#placeholders].

而所谓的*配方*(recipes),我更喜欢翻译为*编译链路*, 实际上只是多个tool的组合而已, 同样举个例子:
#[
#set par(leading: 0.75em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
    ```json
    {
    "name": "pdflatex -> bibtex -> pdflatex * 2",
    "tools": [
        "pdflatex",
        "bibtex",
        "pdflatex",
        "pdflatex"
        ]
    }
    ```  
]

这定义了一个名为「`pdflatex -> bibtex -> pdflatex * 2`」的*编译链路*（recipes）, 当你选择它时, *LW*会*先后*在终端帮助你自动依次执行四个工具「`pdflatex`」-「`bibtex`」-「`pdflatex`」-「`pdflatex`」, 也即分别是:
#[
#set par(leading: 0.6em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
```bash
pdflatex -synctex=1 -interaction=nonstopmode -file-line-error <filename>
bibtex <filename>.<extension>
pdflatex -synctex=1 -interaction=nonstopmode -file-line-error <filename>
pdflatex -synctex=1 -interaction=nonstopmode -file-line-error <filename>
```
]

在这里, 我想*邪恶地*留一个习题, 如果能顺利做出来, 那么以上的内容应该是完全掌握了.

在#link("MusixTeX宏包")[https://ctan.org/pkg/musixtex]中, 需要使用一种名为"three pass system"的编译方式:

#let (example, feature, variant, syntax) = frames(
  feature: ("Feature",),
  // For each frame kind, you have to provide its supplement title to be displayed
  variant: ("Variant",),
  // You can provide a color or leave it out and it will be generated
  example: ("Example", gray),
  // You can add as many as you want
  syntax: ("Syntax",),
)
// This is necessary. Don't forget this!
#show: frame-style(styles.hint)
#feature[
  To this end a three pass system was developed. To start the ﬁrst pass on the ﬁle `jobname.tex`, you would enter `etex jobname`. Information about each bar is written to an external ﬁle named `jobname.mx1`. This ﬁle begins with a header containing parameters such as line width and paragraph indentation. Then the hard and scalable space is listed for each bar.

  The second pass, which is started with `musixflx jobname`, determines optimal values of the basic 
  spacing unit `\elemskipfor` each line, so as to properly ﬁll each line, and to spread the piece nicely over an 
  integral number of full lines. This routine was originally written in fortran rather than `TeX`, the main 
  reason being the lack of an array handling capability in `TeX`; the current version of musixflxis a lua script, which may be executed without compilation in any standard `TeX` system.

  `musixflx` reads in the ﬁle `jobname.mx1`, and writes its output to `jobname.mx2`. The latter ﬁle contains a single entry for each line of music in the reformatted output. The key piece of information is  the revised value of `\elemskipfor` each line.

  Next, the ﬁle is `TeX`-ed again, by entering `etex jobname`. On this third pass, the `jobname.mx2` ﬁle is read in, and the information is used to physically deﬁne the ﬁnal score and embed the page descriptions into a dviﬁle.
]

如果读者感兴趣, 读到这里, 应该可以*满怀激情*地写出类似如下的配置(doge):
#[
#set par(leading: 0.6em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
    ```json
    "latex-workshop.latex.tools": [
        ...,
        {
            "name": "musixflx",
            "command": "musixflx",
            "args": [
                "%DOCFILE%.mx1"
            ]
        },
        ...,
    ]
    "latex-workshop.latex.recipes": [
        ...,
        {
            "name": "musixtex",
            "tools": [
                "pdflatex",
                "musixflx",
                "pdflatex"
            ]
        },
        ...,
    ]
    ```
]

下面我们来看如何配置这些编译链路, 首先要按如下步骤打开「`settings.json`」的配置文件:
+ 点击左下角的「齿轮状」按钮
+ 在弹出的菜单栏中选择「Settings」进入「设置」页面
+ 在「设置」页面的右上角, 点击「Open Settings(JSON)」按钮

#example-image("settings-json.png")

打开之后我们可以看到一个可能是空白（对于第一次使用vscode的用户这个文件是空白的，而对于已经使用过vscode编辑其他语言的代码的用户，此时其中往往已有一些其他语言的配置）的`settings.json`配置文件. 我们需要做的配置就是按照`json`的语法往其中填写配置.

#example-image(width: 94.5%,"settings-panel.png")

仔细观察我们还可以发现, 在`settings.json`中的键值对和左侧「TeX面板」中的按钮是*一一对应*的！既然如此, 那么我们便可以心安理得的copy一些成熟的配置了（因为如果你已经理解了*LW*中的默认配置的含义, 那么下面的这份配置也无非是换汤不换药罢了）, 在这里我比较推荐使用OsbertWang在#link("install-latex-guide-zh-cn")[https://github.com/OsbertWang/install-latex-guide-zh-cn]的附录B.4中提供的配置:

#example-code[
#set par(leading: 0.75em, spacing: 1em)
#set text(top-edge: "cap-height", bottom-edge: "baseline") 
#set par()
```json
  "latex-workshop.latex.tools": [ 
    {
      "name": "latexmkpdf",
      "command": "latexmk",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode", 
        "-halt-on-error",
        "-file-line-error", 
        "-pdf",
        "%DOCFILE%"
      ]
    },
    {
      "name": "latexmkxe", 
      "command": "latexmk", 
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode", 
        "-halt-on-error",
        "-file-line-error",
        "-xelatex",
        "%DOCFILE%"
      ]
    },
  ],
  "latex-workshop.latex.recipes": [ 
    {
      "name": "latexmkxe", 
      "tools": [
        "latexmkxe"
      ]
    },
    {
      "name": "latexmkpdf",
      "tools": [
        "latexmkpdf"
      ]
    }, 
  ],
  "latex-workshop.latex.autoBuild.run": "never",
  "latex-workshop.view.pdf.viewer": "tab",
```
]

可能有仔细对照配置的读者会发现我把`latexmkxe`的编译链路移动到了`latexmkpdf`之前, 这样做的原因是界面右上角的「绿色三角」按钮*默认*通过键值对`latex-workshop.latex.recipe.default="first"` (check #link("this wiki")[https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#latex-workshoplatexrecipedefault])配置其行为执行在`latex-workshop.latex.recipes`列表的*第一个*编译链路, 这样的设置对中文用户更加友好. 注意这里用户*需要严格按照`json`格式的语法要求*, 把上述配置*以合适的结构*添加到`settings.json`中.

如果按上面的配置, 左侧的编译链路将会变为:

#example-image("settings-config.png")

*永远要牢记*: 点击LaTeX Workshop提供的「绿色三角」按钮, 其背后的行为等价于: *按照`settings.json`中的配置, 自动在命令行帮你执行相应的编译命令*. 这也可以解释第一部分中为什么说「要想真正用好TeXLive, *必须先掌握命令行编译*」, 如果用户只会机械地点击「绿色三角」, 而不懂得其背后真实的编译命令, 那么用户在使用和debug时只会花更多的时间检索和提问, 这是将是事倍功半的, 也容易劝退更多萌新用户.

那么我们如何编译呢？答案是显然的. 这个时候我们只需要点击「左侧面板中的"Recipe: latexmkxe"」或者「右上角的绿色三角」按钮, 按照上面介绍的内部执行逻辑, *LW*都会帮我们在终端自动输入`latexmkxe main`, 这个时候通过「预览PDF」功能便可顺利编译, 并且在vscode的右侧看到相应的PDF预览. 同时如果有报错, 下方的「Problems」面板将会提示相关的报错信息, 此时读者应该分析报错信息进行debug, 改正错误.

#example-image("error-panel.png")

= 一些杂谈（Miscellaneous）

- 遇到编译错误「Recipe Terminated with error.」如何排查?

- 遇到编译不成功，左下角出现「红色的×符号」但「Problems」面板*没有任何报错信息*，如何排查错误原因?

- 如何看待`-interaction=nonstopmode `编译选项?

- 

To Be Continued.
