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

## 使用 finally 关闭资源

`kotlinx.coroutine` 库中的挂起函数在取消时，
都会抛出 `CancellationException` 异常，
这个异常可以通过正常的 `try ... catch ... finally` 语句处理，
或者对于 `use` 函数，在协程取消时，也可以正常的执行其终止操作

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    val job = launch(CommonPool) {
        try {
            repeat(1000) { i ->
                println("I'm sleeping $i ...")
                delay(500L)
            }
        } finally {
            println("I'm running finally")
        }
    }
    delay(1300L) // delay a bit
    println("main: I'm tired of waiting!")
    job.cancel() // cancels the job
    delay(1300L) // delay a bit to ensure it was cancelled indeed
    println("main: Now I can quit.")
}
```

输出如下：

```shell
I'm sleeping 0 ...
I'm sleeping 1 ...
I'm sleeping 2 ...
main: I'm tired of waiting!
I'm running finally
main: Now I can quit.
```

##  执行不可取消代码块

如果在上述例子中的 `finally` 块中执行挂起函数，会导致新的
`CancellationException` 异常抛出，毕竟执行这块代码的协程已经处于取消状态了，
正常情况下，在 `finally` 块中执行的关闭操作都应该是非阻塞函数
（如关闭文件、取消任务或者关闭各种通信通道）；
但在某些特殊情况下我们需要在取消的协程中执行挂起函数，
我们可以使用 `run` 函数与 `NonCancellable` 上下文包裹所需执行的代码块：

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    val job = launch(CommonPool) {
        try {
            repeat(1000) { i ->
                println("I'm sleeping $i ...")
                delay(500L)
            }
        } finally {
            run(NonCancellable) {
                println("I'm running finally")
                delay(1000L)
                println("And I've just delayed for 1 sec because I'm non-cancellable")
            }
        }
    }
    delay(1300L) // delay a bit
    println("main: I'm tired of waiting!")
    job.cancel() // cancels the job
    delay(1300L) // delay a bit to ensure it was cancelled indeed
    println("main: Now I can quit.")
}
```

## 超时

实际操作中取消协程的最常见原因就是协程执行超时，
即协程的执行时间超过了设定的超时时间，根据上面学习的内容，
我们可以通过检查协程执行的时间，然后调用 `Job` 相应的方法来取消协程的执行，
不过，`kotlinx.coroutine` 库中提供了一个封装好的函数 `withTimeout`

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    withTimeout(1300L) {
        repeat(1000) { i ->
            println("I'm sleeping $i ...")
            delay(500L)
        }
    }
}
```

输出结果如下：

```shell
I'm sleeping 0 ...
I'm sleeping 1 ...
I'm sleeping 2 ...
Exception in thread "main" kotlinx.coroutines.experimental.TimeoutException: Timed out waiting for 1300 MILLISECONDS
```

上例输出中我们可以看出，在协程执行超时 `withTimeout` 函数抛出了
`TimeoutException`，超时异常是 `CancellationException` 的一个私有子类，
在之前取消协程执行，抛出 `CancellationException` 异常的例子中，
并没有在控制台输出中看到错误堆栈的信息，但是这次超时异常中却出现了，
这是因为之前在协程中抛出 `CancellationException` 异常可以看做是
协程完成的正常原因，而上例中直接在 `main` 函数中调用 `withTimeout` 函数，
而不是在协程中，所以其抛出的异常就会输出在控制台中。
  
由于取消操作只是抛出了异常，所以所有的资源都会以正常的方式被关闭，
我们可以将 `withTimeout` 代码放在 `try ... catch(e: CancellationException) ...`
中，这样就可以在协程超时之后做一些相应的处理，如记录日志等。