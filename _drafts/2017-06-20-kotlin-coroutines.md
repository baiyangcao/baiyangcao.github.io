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
  
## 阻塞与非阻塞

在上面的例子中，`Thread.sleep` 会阻塞主线程，而非阻塞函数 `delay` 只会延迟协程的执行，
对主线程不会造成影响，此外，
`delay` 这种 *suspending function*（暂定为挂起函数） 只能用在协程中而不能用在线程中，
挂起函数使用关键字 `suspend fun` 定义，如 `delay` 的定义为：

```kotlin
suspend fun delay( ... ) { ... }
```

对于只能使用非阻塞函数的情况，可以选择将主线程转换为“主协程”，如上述例子可以转换为：

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    launch(CommonPool) {
        delay(1000L)
        println("World!")
    }

    print("Hello ")
    delay(2000L)
}
```

这里的 `runBlocking {}` 就是用来创建顶层主协程的，这样就可以在 `main` 函数里面调用挂起函数了，
当然并非只有 `main` 函数可以这样用，所有的函数都可以这样使用，
如用在给挂起函数编写单元测试时：

```kotlin
class MyTest {
    @Test
    fun testMySuspendingFunction() = runBlocking<Unit> {
        // ...
    }
}
```

## 等待协程完成

上面的例子中，我们都指定了协程的大概执行时间，然后在主线程/协程中指定稍长的时间，
来确保子协程可以正确完成，但是如果我们不知道子协程执行的时间又该如何？

```kotlin
fun main(args:Array<String>) = runBlocking<Unit> {
    var job = launch(CommonPool) {
        delay(1000L)
        println("World!")
    }

    print("Hello ")
    job.join()
}
```

`lanuch(CommonPool)` 返回一个 `Job` 对象，表示子协程中执行的任务，
这里调用 `Job.join` 方法来延迟主协程，使主协程在子协程完成之前处于挂起状态，
这样不用知道子协程的执行时间也可以保证子协程结束之后再结束主协程

> 注：`Job.join` 方法是挂起函数，只能在协程中调用，
> 所以上例中使用了 `runBlocking<Unit>` 来创建主协程

## 创建挂起函数

*suspending function* 只能在协程中调用，或者由另一个挂起函数调用，
我们可以为上述协程中的代码创建一个单独的挂起函数，如：

```kotlin
fun main(args: Array<String>) = runBlocking<Unit> {
    var job = launch(CommonPool) {
        doWorld()
    }

    print("Hello ")
    job.join()
}

suspend fun doWorld() {
    delay(1000L)
    println("World!")
}
```

挂起函数在协程中调用与普通函数一致，只不过在挂起函数中可以调用其他的挂起函数

## 总结

 - 协程是一种轻量级的线程，比线程暂用资源少（比如我们可以同时运行100K个协程，
 但如果运行100K个线程，就可能会导致内存泄露）

 - 运行中的协程并不会保证线程的正常运行，如上面的例子，协程处于挂起状态未执行完成，
 主线程结束之后，子协程也直接结束了

 - 挂起函数只能由别的挂起函数调用，或者用在协程中，不可以直接在线程中使用