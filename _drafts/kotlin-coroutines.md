---
layout: post
title: kotlin 协程 —— 取消与超时
date: 2017-06-26
categories: Notes
tags: [Kotlin]
---

## 取消协程执行

在小型程序中，可以利用`main` 函数的结束来隐式结束所有子协程，
但在大型、长时间运行的程序中，我们就需要更细致的控制协程的生命周期，
`launch` 函数返回的 `Job` 对象可以用来取消运行中的协程：

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    val job = launch(CommonPool) {
        repeat(1000) { i ->
            println("I'm sleeping $i ...")
            delay(500L)
        }
    }
    delay(1300L) // delay a bit
    println("main: I'm tired of waiting!")
    job.cancel() // cancels the job
    delay(1300L) // delay a bit to ensure it was cancelled indeed
    println("main: Now I can quit.")
}
```

输出结果如下：

```shell
I'm sleeping 0 ...
I'm sleeping 1 ...
I'm sleeping 2 ...
main: I'm tired of waiting!
main: Now I can quit.
```

上述例子，在 `main` 函数中调用 `Job.cancel` 方法来结束子协程的运行。