# 0104加载element-admin

[Laravel 5.8集合 vue-element-admin 踩坑记 - 个人文章 - SegmentFault 思否](https://segmentfault.com/a/1190000019393275)

将 vue-element-admin 中 package.json 中的 dependencies 与devDependencies 合并到 Laravel 的 package.json 中。版本以 vue-element-admin 的版本为准。

将 vue-element-admin 中整个 src 目录下的文件复制到 laravel 项目中的 resources/backend 目录中。

1『文件夹的名字还是用的「src」。』

修改 webpack.mix.js 为：

```js
const mix = require('laravel-mix');

mix.js('resources/js/app.js', 'public/js')
    .sass('resources/sass/app.scss', 'public/css');

mix.js('resources/backend/main.js', 'public/js')
```

在 routes/web.php 文件中添加如下路由：

```php
Route::get('/vue', function () {
    return view('admin');
});
```

运行时的问题没有原文作者那么多，也有 2 个。

1、别名@未定义。

报错：

```
ERROR in ./resources/backend/router/index.js
Module not found: Error: Can't resolve '@/views/zip/index' in '/path/to/laravel-vue-admin/resources/backend/router'
 @ ./resources/backend/router/index.js 365:13-40
 @ ./resources/backend/main.js
 @ multi ./resources/backend/main.js
```

解决方法：在 webpack.mix.js 添加如下代码：

```js
mix.webpackConfig({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'resources/backend'),
    },
  },
})
```

2、bable 失败。

```
ERROR in ./resources/backend/layout/components/Sidebar/Item.vue?vue&type=script&lang=js& (./node_modules/babel-loader/lib??ref--4-0!./node_modules/vue-loader/lib??vue-loader-options!./resources/backend/layout/components/Sidebar/Item.vue?vue&type=script&lang=js&)
Module build failed (from ./node_modules/babel-loader/lib/index.js):
SyntaxError: /path/to/laravel-vue-admin/resources/backend/layout/components/Sidebar/Item.vue: Unexpected token (20:18)

  18 | 
  19 |     if (icon) {
> 20 |       vnodes.push(<svg-icon icon-class={icon}/>)
     |                   ^
  21 |     }
```

经查询为 bable 没有正确配置，直接复制 vue-element-admin 中 babel.config.js 即可。



