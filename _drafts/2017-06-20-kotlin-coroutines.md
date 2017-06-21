---
layout: post
title: kotlin 协程基础
date: 2017-06-20
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

## 小试协程

所谓协程，就是一种轻量级的线程，下面来看一个例子：

```kotlin
fun main(args: Array<String>) {
    launch(CommonPool) {
        delay(1000L)
        println("World!")
    }

    print("Hello ")
    Thread.sleep(2000L)
}
```

上述代码会先输出 `Hello ` 然后停顿 1 秒左右输出 `World!`  
  
这里，`fun main` 执行时会新建一个线程（主线程），
然后 `launch(CommonPool)` 语句创建一个协程（子协程），
接着主线程继续执行 `print("Hello ")` 语句，
同时子协程中执行 `delay(1000L)` 等待 1 秒，
此时主线程执行 `Thread.sleep(2000L)` 阻塞，休眠 2 秒，
子协程等待结束后打印 `World!` ，最后主线程阻塞结束，主线程结束。

## 举一反三

如果将上面例子的最后一句改动一下：

```kotlin
...
    Thread.sleep(500L)
...
```

结果就只会输出 `Hello `，而不会输出 `World!`，因为主线程阻塞 0.5 秒，然后主线程就结束了，
而子协程中的执行延迟了 1 秒，子协程中的延迟并不会阻塞到主线程，并且在主线程结束时，
所有的子协程也都会结束，所以最终只会输出 `Hello `。