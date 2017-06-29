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


## 取消操作应具有交互性

协程的取消应该具有交互性，即应该在协程中处理协程被取消的情况，
在 `kotlinx.coroutines` 库中的挂起函数都是可取消的，
函数中会检查协程的取消并在协程取消时抛出 `CancellationException` 异常。
但是，如果协程正处在循环计算中并且没有检查是否取消了协程，
则 `job.cancel` 方法无法取消协程的执行，如下：

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    val job = launch(CommonPool) {
        var nextPrintTime = 0L
        var i = 0
        while (i < 10) { // 循环运算
            val currentTime = System.currentTimeMillis()
            if (currentTime >= nextPrintTime) {
                println("I'm sleeping ${i++} ...")
                nextPrintTime = currentTime + 500L
            }
        }
    }
    delay(1300L)
    println("main: I'm tired of waiting!")
    job.cancel()
    delay(1300L)
    println("main: Now I can quit.")
}
```

输出结果如下：

```shell
I'm sleeping 0 ...
I'm sleeping 1 ...
I'm sleeping 2 ...
main: I'm tired of waiting!
I'm sleeping 3 ...
I'm sleeping 4 ...
I'm sleeping 5 ...
main: Now I'm quit!
```

可以看出，子协程在调用 `job.cancel` 方法后并没有停止执行，
而是在 `main` 函数执行结束时才退出

## 取消循环运算代码

有两种办法可以用来解决上述问题：

 - 周期性的调用挂起函数，如使用 `yield` 函数
 - 显式的检查协程的运行状态

这里我们尝试一下第二种方法，在上述例子中使用 `while(isActive)` 
来替换 `while(i < 10)`

```kotlin
...
while (isActive) { // cancellable computation loop
    val currentTime = System.currentTimeMillis()
    if (currentTime >= nextPrintTime) {
        println("I'm sleeping ${i++} ...")
        nextPrintTime = currentTime + 500L
    }
}
...
```

输出结果如下：

```shell
I'm sleeping 0 ...
I'm sleeping 1 ...
I'm sleeping 2 ...
main: I'm tired of waiting!
main: Now I'm quit!
```

这里我们可以看到 `job.cancel` 方法成功的结束了协程，
`isActive` 属性属于 `CoroutineScope` 接口，
可以在协程代码中访问，用来表示协程的运行状态。