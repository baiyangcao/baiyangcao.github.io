---
layout: post
title: Python 父类调用子类方法的问题
date: 2017-08-19
categories: Notes
tags: [python]
---

今天遇到了这样一个问题，通过重载方法来设置不同的字段值，
而这个设置方法对于类外部来说没有什么作用，所以设置成了私有，
结果在调用的时候，始终调用的是父类的方法而不是子类重载的方法，
如下例：

```python
class A():
    def __init__(self):
        print(self.__get_name())

    def __get_name(self):
        return "A"

class B(A):
    def __get_name(self):
        return "B"

if __name__ == "__main__":
    b = B() # 输出为 "A"
```

上例中初始化时应该调用 B 中的 __get_name 方法，却调用了父类 A 中的 __get_name 方法，
后来才幡然醒悟，私有方法只能在类内部使用，对于父类是不可见的，
当然无法调用，但是我又不想对外开放这样的方法，最后选择了使用 `protected` 方法，
只对继承链上的类可见。  
  
在 python 中， 双下划线开头的方法 `__xxx` 为私有方法，只有类内部可见，
单下划线开头的方法 `_xxx` 相当于其他语言的 `protected` 方法，
仅继承链上的类中可见。

```python
class A():
    def __init__(self):
        print(self.__get_name())

    def _get_name(self):
        return "A"

class B(A):
    def _get_name(self):
        return "B"

if __name__ == "__main__":
    b = B() # 输出为 "B"
```

> 参考链接：  
>   
> <http://www.codeweblog.com/python%E9%87%8C%E7%9A%84%E7%B1%BBprivate-protected%E6%88%90%E5%91%98%E5%B1%9E%E6%80%A7/>
> <http://www.cnblogs.com/wanpython/archive/2013/05/23/3095534.html>
