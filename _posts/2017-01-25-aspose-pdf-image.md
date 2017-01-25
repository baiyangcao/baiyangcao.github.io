---
layout: post
title: Aspose.Pdf合并图片到PDF文件
date: 2017-01-25
categories: Notes
tags: Aspose.Pdf .NET C#
---

将图片和PDF文件合成为新的PDF文件，可以先将图片转换为PDF文件，
然后[合成PDF](#aspose.pdf合并pdf文件)即可，
将图片转换成PDF文件有如下方法：

 - `Aspose.Pdf.Document`
 - `Aspose.Pdf.Generator.Pdf`

### `Aspose.Pdf.Document`

一个PDF文档包含许多页面，而每个页面又是由多个段落构成，
段落可以是文本、图片、表格、悬浮框、图表、附件等，
所以把图片转换成PDF只要用段落将图片封装起来即可  

```cs
Document doc = new Document();
Page page = doc.Pages.Add();

// 创建Image对象，命名空间是必要的，因为在别的命名空间也有Image类
Aspose.Pdf.Image image = new Aspose.Pdf.Image();

// 设置Image数据源
// 如果是本地文件或Web图片，直接设置File属性即可
image.File = @"C:\test.jpg"; // "http://localhost/test.jpg"
// 如果是Stream类型，设置ImageStream属性
// image.ImageStream = stream;

// 添加图片到页面段落
page.Paragraphs.Add(image);

doc.Save(@"C:\outputtest.pdf");
```

### `Aspose.Pdf.Generator.Pdf`

与上述方法相同，只不过使用了`Section`而不是`Page`

```cs
Aspose.Pdf.Generator.Pdf pdf = new Aspose.Pdf.Generator.Pdf();
Aspose.Pdf.Generator.Section section = new Aspose.Pdf.Generator.Section(pdf);

// 创建Image，并设置数据源
Aspose.Pdf.Generator.Image image = new Aspose.Pdf.Generator.Image(section);
// 数据源的设置方式相同，只不过这次设置的是`Image.ImageInfo.File`和`Image.ImageInfo.ImageStream`属性
image.ImageInfo.File = "http://localhost/test.jpg";

section.Paragraphs.Add(image);
pdf.Sections.Add(section);

pdf.Save(@"C:\outputtest.pdf");
```

这两种方法的输出可以是到本地文件，也可以是`Stream`对象，
在配合[合成PDF](#aspose.pdf合并pdf文件)就可以实现图片和PDF的合并了

> 参考链接：
> [Convert an Image to PDF](http://www.aspose.com/docs/display/pdfnet/Convert+an+Image+to+PDF)
> [Working with Images (Generator)](http://www.aspose.com/docs/display/pdfnet/Working+with+Images+%28Generator%29)
