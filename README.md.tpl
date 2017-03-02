[![Build Status](https://travis-ci.org/davelondon/jennifer.svg?branch=master)](https://travis-ci.org/davelondon/jennifer) [![Go Report Card](https://goreportcard.com/badge/github.com/davelondon/jennifer)](https://goreportcard.com/report/github.com/davelondon/jennifer) [![codecov](https://codecov.io/gh/davelondon/jennifer/branch/master/graph/badge.svg)](https://codecov.io/gh/davelondon/jennifer)

# Jennifer
Jennifer is a code generator for Go.

```go
package main

import (
    "fmt"

    . "github.com/davelondon/jennifer/jen"
)

func main() {{ "ExampleNewFile" | code }}
```
Output:
```go
{{ "ExampleNewFile" | output }}
```

# Install
```
go get -u github.com/davelondon/jennifer/jen
```

# Examples
Jennifer has a comprehensive suite of examples - [see godoc.org](https://godoc.org/github.com/davelondon/jennifer/jen#pkg-examples) for an index.

The code that powers jennifer is generated by jennifer itself, see the 
[genjen package](https://github.com/davelondon/jennifer/tree/master/genjen) - 
it uses data in [data.go](https://github.com/davelondon/jennifer/blob/master/genjen/data.go), which is processed by [render.go](https://github.com/davelondon/jennifer/blob/master/genjen/render.go) to create [generated.go](https://github.com/davelondon/jennifer/blob/master/jen/generated.go).

A much larger implementation of jennifer [can be found in the kego project](https://github.com/kego/ke/blob/master/process/generate/structs.go).

# Rendering
For testing, a File or Statement can be rendered with the fmt package 
using the %#v verb.

{{ "ExampleCall_fmt" | example }}

This is not recommended for use in production because any error will cause a 
panic. For production use, [File.Render](#render) or [File.Save](#save) are 
preferred.

# Id
{{ "Id" | doc }}

{{ "ExampleId" | example }}

# Qual
{{ "Qual[0]" | doc }}

{{ "ExampleQual" | example }}

{{ "Qual[1:]" | doc }}

{{ "ExampleQual_file" | example }}

# Op
{{ "Op" | doc }}

{{ "ExampleOp" | example }}

{{ "ExampleOp_star" | example }}

{{ "ExampleOp_variadic" | example }}

# Summary
Many of the language constructs that jennifer emits are presented as functions 
taking zero or more items as parameters. For example, here the Append function 
takes two items and renders them appropriately:

{{ "ExampleAppend_more" | example }}

Below we summarize most of the language constructs, while examples follow.

Language constructs taking zero items:

| Construct       | Name |
| --------------- | ---- |
| Keywords        | Break, Default, Func, Select, Chan, Else, Const, Fallthrough, Type, Continue, Var, Goto, Defer, Go, Range |
| Types           | Bool, Byte, Complex64, Complex128, Error, Float32, Float64, Int, Int8, Int16, Int32, Int64, Rune, String, Uint, Uint8, Uint16, Uint32, Uint64, Uintptr |
| Constants       | True, False, Iota, Nil |
| Helpers         | Err |

Built-in functions taking one or more items:

| Construct | Name |
| --------- | ---- |
| Functions | Append, Cap, Close, Complex, Copy, Delete, Imag, Len, Make, New, Panic, Print, Println, Real, Recover |

Some keywords are always followed by another construct. These take one or more 
items and render them as follows:
 
| Keyword                          | Opening       | Separator | Closing | Usage                                   |
| -------------------------------- | ------------- | --------- | ------- | --------------------------------------- |
| [Return](#return)                |               | `,`       |         | `return a, b`                           |
| [If](#if-for)                    |               | `;`       |         | `if i, err := a(); err != nil { ... }`  |
| [For](#if-for)                   |               | `;`       |         | `for i := 0; i < 10; i++ { ... }`       |
| [Switch](#switch-case-caseblock) |               | `;`       |         | `switch a { ... }`                      |
| [Case](#switch-case-caseblock)   |               | `,`       |         | `case a, b: ...`                        |
| [Interface](#interface-struct)   | `{`           | `\n`      | `}`     | `interface { ... }`                     |
| [Struct](#interface-struct)      | `{`           | `\n`      | `}`     | `struct { ... }`                        |
| [Map](#map)                      | `[`           |           | `]`     | `map[string]`                           |

Groups accept a list of items and render them as follows:

| Group             | Opening       | Separator | Closing | Usage                             |
| ----------------- | ------------- | --------- | ------- | --------------------------------- |
| [Sel](#sel)       |               | `.`       |         | `foo.bar[0].baz()`                |
| [List](#list)     |               | `,`       |         | `a, b := c()`                     |
| [Call](#call)     | `(`           | `,`       | `)`     | `fmt.Println(b, c)`               |
| [Params](#params) | `(`           | `,`       | `)`     | `func (a *A) Foo(i int) { ... }`  |
| [Index](#index)   | `[`           | `:`       | `]`     | `a[1:2]` or `[]int{}`             |
| [Values](#values) | `{`           | `,`       | `}`     | `[]int{1, 2}`                     |
| [Block](#block)   | `{`           | `\n`      | `}`     | `func a() { ... }`                |
| [Defs](#defs)     | `(`           | `\n`      | `)`     | `const ( ... )`                   |
| [CaseBlock](#switch-case-caseblock) | `:`           | `\n`      |         | `case a: ...`                     |

These groups accept a single item:

| Group             | Opening  | Closing | Usage                        |
| ----------------- | -------- | ------- | ---------------------------- |
| [Parens](#parens) | `(`      | `)`     | `[]byte(s)` or `a / (b + c)` |
| [Assert](#assert) | `.(`     | `)`     | `s, ok := i.(string)`        |

# GroupFunc methods
All constructs that accept a variadic list of items are paired with GroupFunc 
functions that accept a func(*Group). These are used to embed logic.

{{ "ExampleBlockFunc" | example }}

# Special keywords

### Interface, Struct
Interface and Struct render the keyword followed by a statement list enclosed 
by curly braces.

{{ "ExampleInterface_empty" | example }}

{{ "ExampleInterface" | example }}

{{ "ExampleStruct_empty" | example }}

{{ "ExampleStruct" | example }}

### Switch, Case, CaseBlock
Switch, Case and CaseBlock are used to build switch statements:

{{ "ExampleSwitch" | example }}

### Map
{{ "Map" | doc }}

{{ "ExampleMap" | example }}

### Return
{{ "Return" | doc }}

{{ "ExampleReturn" | example }}

### If, For
If and For render the keyword followed by a semicolon separated list.

{{ "ExampleIf" | example }}

{{ "ExampleFor" | example }}

# Groups

### Sel
{{ "Sel" | doc }}

{{ "ExampleSel" | example }}

### List
{{ "List" | doc }}

{{ "ExampleList" | example }}

### Call
{{ "Call" | doc }}

{{ "ExampleCall" | example }}

### Params
{{ "Params" | doc }}

{{ "ExampleParams" | example }}

### Index
{{ "Index" | doc }}

{{ "ExampleIndex" | example }}

{{ "ExampleIndex_index" | example }}

{{ "ExampleIndex_empty" | example }}

### Values
{{ "Values" | doc }}

{{ "ExampleValues" | example }}

### Block
{{ "Block" | doc }}

{{ "ExampleBlock" | example }}

{{ "ExampleBlock_if" | example }}

### Defs
{{ "Defs" | doc }}

{{ "ExampleDefs" | example }}

### Parens
{{ "Parens" | doc }}

{{ "ExampleParens" | example }}

{{ "ExampleParens_order" | example }}

### Assert
{{ "Assert" | doc }}

{{ "ExampleAssert" | example }}

# Add
{{ "Add" | doc }}

{{ "ExampleAdd" | example }}

{{ "ExampleAdd_var" | example }}

# Do
{{ "Do" | doc }}

{{ "ExampleDo" | example }}

# Lit, LitFunc
{{ "Lit" | doc }}

{{ "ExampleLit" | example }}

{{ "ExampleLit_float" | example }}

{{ "LitFunc[1:]" | doc }}

{{ "ExampleLitFunc" | example }}

# Dict, DictFunc
{{ "Dict" | doc }}

{{ "ExampleDict" | example }}

{{ "DictFunc[0]" | doc }}

{{ "ExampleDictFunc" | example }}

Note: the items are ordered by key when rendered to ensure repeatable code.

# Tag
{{ "Tag" | doc }}

{{ "ExampleTag" | example }}

Note: the items are ordered by key when rendered to ensure repeatable code.

# Null
{{ "Null" | doc }}

In lists, nil will produce the same effect.

{{ "ExampleNull_and_nil" | example }}

# Empty
{{ "Empty" | doc }}

{{ "ExampleEmpty" | example }}

# Line
{{ "Line" | doc }}

# Comment, Commentf
{{ "Comment[:2]" | doc }}

{{ "ExampleComment" | example }}

{{ "ExampleComment_multiline" | example }}

{{ "Comment[2:]" | doc }}

{{ "ExampleComment_formatting_disabled" | example }}

{{ "Commentf[0]" | doc }}

{{ "ExampleCommentf" | example }}

# File
{{ "File" | doc }}

### NewFile
{{ "NewFile" | doc }}

### NewFilePath
{{ "NewFilePath" | doc }}

### NewFilePathName
{{ "NewFilePathName" | doc }}

{{ "ExampleNewFilePathName" | example }}

### PackageComment
{{ "File.PackageComment" | doc }}

{{ "ExampleFile_PackageComment" | example }}

### Anon
{{ "File.Anon" | doc }}

{{ "ExampleFile_Anon" | example }}

### PackagePrefix
{{ "File.PackagePrefix" | doc }}

{{ "ExampleFile_PackagePrefix" | example }}

### Save
{{ "File.Save" | doc }}

### Render
{{ "File.Render" | doc }}

{{ "ExampleFile_Render" | example }}

# Clone
Be careful when passing *Statement. Consider the following... 

{{ "ExampleStatement_Clone_broken" | example }}

Id("a") returns a *Statement, which the Call() method appends to twice. To 
avoid this, use Clone. {{ "Statement.Clone" | doc }}  

{{ "ExampleStatement_Clone_fixed" | example }}
