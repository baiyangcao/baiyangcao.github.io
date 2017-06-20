---
layout: post
title: kotlin 协程基础
date: 2017-05-28
categories: Notes
tags: [Kotlin]
---

小生真是一个不安分的骚年啊，Go 坑还没有填完又跟风走向了 kotlin 的深渊...
  
Kotlin 本身的标准库只提供了最小化的低级 API 接口，并没有提供协程接口，
也没有 `async` 和 `await` 关键字来实现异步，不过好在有 `kotlin.coroutines` 库，
让我们可以轻松实现多协程编程，首先要在项目中引用库（这里以 Gradle 配置为例）：

```javascript
\\ 添加 JCenter 仓库
repositories {
    jcenter()
}

\\ 添加库依赖引用
dependencies {
    compile 'org.jetbrains.kotlinx:kotlinx-coroutines-core:0.16'
}
```