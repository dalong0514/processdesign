# 基本信息

[icindy/wxParse: wxParse-微信小程序富文本解析自定义组件，支持HTML及markdown解析](https://github.com/icindy/wxParse)

[wxParse 介绍 · icindy/wxParse Wiki](https://github.com/icindy/wxParse/wiki/wxParse-%E4%BB%8B%E7%BB%8D)

功能是支持 Html 及 markdown 转 wxml 可视化，可用于小程序开发。

已下载开源源码「2020009wxParse」。

## 01. 基本使用方法

### 1. Copy 文件夹 wxParse

```
- wxParse/
  -wxParse.js(必须存在)
  -html2json.js(必须存在)
  -htmlparser.js(必须存在)
  -showdown.js(必须存在)
  -wxDiscode.js(必须存在)
  -wxParse.wxml(必须存在)
  -wxParse.wxss(必须存在)
  -emojis(可选)
```

### 2. 引入必要文件

```
//在使用的View中引入WxParse模块
var WxParse = require('../../wxParse/wxParse.js');
//在使用的Wxss中引入WxParse.css,可以在app.wxss
@import "/wxParse/wxParse.wxss";
```

### 3. 数据绑定

```
var article = '<div>我是HTML代码</div>';
/**
* WxParse.wxParse(bindName , type, data, target,imagePadding)
* 1.bindName绑定的数据名(必填)
* 2.type可以为html或者md(必填)
* 3.data为传入的具体数据(必填)
* 4.target为Page对象,一般为this(必填)
* 5.imagePadding为当图片自适应是左右的单一padding(默认为0,可选)
*/
var that = this;
WxParse.wxParse('article', 'html', article, that, 5);
```

### 4. 模版引用

```
// 引入模板
<import src="你的路径/wxParse/wxParse.wxml"/>
//这里data中article为bindName
<template is="wxParse" data="{{wxParseData:article.nodes}}"/>
```

### 5. 高级用法

1）配置小表情 emojis。

```
/**
* WxParse.emojisInit(reg,baseSrc,emojis)
* 1.reg，如格式为[00]=>赋值 reg='[]'
* 2.baseSrc,为存储emojis的图片文件夹
* 3.emojis,定义表情键值对
*/
WxParse.emojisInit('[]', "/wxParse/emojis/", {
      "00": "00.gif",
      "01": "01.gif",
      "02": "02.gif",
      "03": "03.gif",
      "04": "04.gif",
      "05": "05.gif",
      "06": "06.gif",
      "07": "07.gif",
      "08": "08.gif",
      "09": "09.gif",
      "09": "09.gif",
      "10": "10.gif",
      "11": "11.gif",
      "12": "12.gif",
      "13": "13.gif",
      "14": "14.gif",
      "15": "15.gif",
      "16": "16.gif",
      "17": "17.gif",
      "18": "18.gif",
      "19": "19.gif",
    });
```

2）多数据格式。参见 wikiwxParse 多数据循环使用方法。

### 6. 二次开发。

参见 wikiwxParse 二次开发文档。

1）基础数据格式。

```
parsedata:{
    view:{},//样式存储
    nodes:{},//展示需要的存储节点
    images:[],//存放图片对象数组
    imageUrls:[],//存放图片url数组
}
```

### 7. 相关文章

wxDiscode－微信小程序特殊字符转义符转化工具类

微信小程序组件 wxParse 中的模版 template 使用，既然不能循环那就使用笨办法

微信小程序单图片的自适应计算

## 02. wxParse 如何重复嵌套模版

问题：HTML的嵌套层次比较多，造成深度节点无法渲染。

解决方案: 复制扩展模版。

1、找到 wxParse.wxml。

2、复制最底部的 Template。

```
<!--循环模版-->
<template name="wxParse11">
    <!--<template is="wxParse12" data="{{item}}" />-->
    <!--判断是否是标签节点-->
    <block wx:if="{{item.node == 'element'}}">
        <block wx:if="{{item.tag == 'button'}}">
            <button type="default" size="mini" >
                <block wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">
                    <template is="wxParse12" data="{{item}}"/>
                </block>
             </button>
        </block>
        <!--li类型-->
        <block wx:elif="{{item.tag == 'li'}}">
            <view class="{{item.classStr}} wxParse-li">
                <view class="{{item.classStr}} wxParse-li-inner">
                    <view class="{{item.classStr}} wxParse-li-text">
                        <view class="{{item.classStr}} wxParse-li-circle"></view>
                    </view>
                    <view class="{{item.classStr}} wxParse-li-text">
                        <block wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">
                            <template is="wxParse12" data="{{item}}"/>
                        </block>
                    </view>
                </view>
            </view>
        </block>

        <!--video类型-->
        <block wx:elif="{{item.tag == 'video'}}">
            <template is="wxParseVideo" data="{{item}}"/>  
        </block>

        <!--img类型-->
        <block wx:elif="{{item.tag == 'img'}}">
            <template is="wxParseImg" data="{{item}}"/>
        </block>

        <!--a类型-->
        <block wx:elif="{{item.tag == 'a'}}">
            <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-src="{{item.attr.href}}"  style="{{item.styleStr}}">
                <block wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">
                    <template is="wxParse12" data="{{item}}"/>
                </block>
            </view>
        </block>
        
        <!--其他块级标签-->
        <block wx:elif="{{item.tagType == 'block'}}">
            <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
                <block  wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">       
                    <template is="wxParse12" data="{{item}}"/>                 
                </block>
            </view>
        </block>

        <!--内联标签-->
        <view wx:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
            <block  wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">       
                <template is="wxParse12" data="{{item}}"/>                 
            </block>
        </view>

    </block>

    <!--判断是否是文本节点-->
    <block wx:elif="{{item.node == 'text'}}">
        <!--如果是，直接进行-->
        <template is="WxEmojiView" data="{{item}}"/>
    </block>

</template>
```

3、修改为下。

```
<!--循环模版-->
<template name="wxParse12">
    <!--<template is="wxParse13" data="{{item}}" />-->
    <!--判断是否是标签节点-->
    <block wx:if="{{item.node == 'element'}}">
        <block wx:if="{{item.tag == 'button'}}">
            <button type="default" size="mini" >
                <block wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">
                    <template is="wxParse13" data="{{item}}"/>
                </block>
             </button>
        </block>
        <!--li类型-->
        <block wx:elif="{{item.tag == 'li'}}">
            <view class="{{item.classStr}} wxParse-li">
                <view class="{{item.classStr}} wxParse-li-inner">
                    <view class="{{item.classStr}} wxParse-li-text">
                        <view class="{{item.classStr}} wxParse-li-circle"></view>
                    </view>
                    <view class="{{item.classStr}} wxParse-li-text">
                        <block wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">
                            <template is="wxParse13" data="{{item}}"/>
                        </block>
                    </view>
                </view>
            </view>
        </block>

        <!--video类型-->
        <block wx:elif="{{item.tag == 'video'}}">
            <template is="wxParseVideo" data="{{item}}"/>  
        </block>

        <!--img类型-->
        <block wx:elif="{{item.tag == 'img'}}">
            <template is="wxParseImg" data="{{item}}"/>
        </block>

        <!--a类型-->
        <block wx:elif="{{item.tag == 'a'}}">
            <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-src="{{item.attr.href}}"  style="{{item.styleStr}}">
                <block wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">
                    <template is="wxParse13" data="{{item}}"/>
                </block>
            </view>
        </block>
        
        <!--其他块级标签-->
        <block wx:elif="{{item.tagType == 'block'}}">
            <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
                <block  wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">       
                    <template is="wxParse13" data="{{item}}"/>                 
                </block>
            </view>
        </block>

        <!--内联标签-->
        <view wx:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
            <block  wx:for="{{item.nodes}}" wx:for-item="item" wx:key="">       
                <template is="wxParse13" data="{{item}}"/>                 
            </block>
        </view>

    </block>

    <!--判断是否是文本节点-->
    <block wx:elif="{{item.node == 'text'}}">
        <!--如果是，直接进行-->
        <template is="WxEmojiView" data="{{item}}"/>
    </block>

</template>
```

4、按照上面步骤依次添加到你的层级即可。

## 03. wxParse 多数据循环使用方法

介绍如何使用 wxParse 在回复等多条 HTML 共同渲染的方法。

方法介绍：

```
/**
* WxParse.wxParseTemArray(temArrayName,bindNameReg,total,that)
* 1.temArrayName: 为你调用时的数组名称
* 3.bindNameReg为循环的共同体 如绑定为reply1，reply2...则bindNameReg = 'reply'
* 3.total为reply的个数
*/
var that = this;
WxParse.wxParseTemArray("replyTemArray",'reply', replyArr.length, that)
```

使用方式：

1、循环绑定数据。

```
var replyHtml0 = `<div style="margin-top:10px;height:50px;">
		<p class="reply">
			wxParse回复0:不错，喜欢[03][04]
		</p>	
	</div>`;
    var replyHtml1 = `<div style="margin-top:10px;height:50px;">
		<p class="reply">
			wxParse回复1:不错，喜欢[03][04]
		</p>	
	</div>`;
    var replyHtml2 = `<div style="margin-top:10px;height:50px;">
		<p class="reply">
			wxParse回复2:不错，喜欢[05][07]
		</p>	
	</div>`;
    var replyHtml3 = `<div style="margin-top:10px;height:50px;">
		<p class="reply">
			wxParse回复3:不错，喜欢[06][08]
		</p>	
	</div>`;
    var replyHtml4 = `<div style="margin-top:10px; height:50px;">
		<p class="reply">
			wxParse回复4:不错，喜欢[09][08]
		</p>	
	</div>`;
    var replyHtml5 = `<div style="margin-top:10px;height:50px;">
		<p class="reply">
			wxParse回复5:不错，喜欢[07][08]
		</p>	
	</div>`;
    var replyArr = [];
    replyArr.push(replyHtml0);
    replyArr.push(replyHtml1);
    replyArr.push(replyHtml2);
    replyArr.push(replyHtml3);
    replyArr.push(replyHtml4);
    replyArr.push(replyHtml5);


    for (let i = 0; i < replyArr.length; i++) {
      WxParse.wxParse('reply' + i, 'html', replyArr[i], that);
      if (i === replyArr.length - 1) {
        WxParse.wxParseTemArray("replyTemArray",'reply', replyArr.length, that)
      }
    }
```

模版使用：

```
   <block wx:for="{{replyTemArray}}" wx:key="">
        回复{{index}}:<template is="wxParse" data="{{wxParseData:item}}"/>
    </block>
```
