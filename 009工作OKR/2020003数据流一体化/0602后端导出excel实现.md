# 0602后端导出 excel 实现

## 01

导出文件的时候又存在跨域冲突了，必须在导出文件里分常规传输数据的和导出 excel 文件的情况。

```php
<?php

namespace App\Http\Middleware;

use Closure;

class CrossHttp
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request $request
     * @param  \Closure $next
     * @return mixed
     */
    const ILLUMINATE_RESPONSE = 'Illuminate\Http\Response';
    const SYMFONY_RESPONSE = 'Symfony\Component\HttpFoundation\Response';

    public function handle($request, Closure $next)
    {
        // $response = $next($request);
        // $response->header('Access-Control-Allow-Origin', '*');
        // $response->header("Access-Control-Allow-Credentials", true);
        // $response->header("Access-Control-Allow-Methods", '*');
        // $response->header("Access-Control-Allow-Headers", 'Content-Type,Access-Token');
        // $response->header("Access-Control-Expose-Headers", '*');

        $response = $next($request);
        $headers = [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Headers' => 'Content-Type,Access-Token',
            'Access-Control-Expose-Headers' => '*',
            'Access-Control-Allow-Methods' => '*',
            'Access-Control-Allow-Credentials' => true
        ];
        $IlluminateResponse = self::ILLUMINATE_RESPONSE;
        $SymfonyResponse = self::SYMFONY_RESPONSE;

        switch ($response) {
            // 普通的http请求
            case ($response instanceof $IlluminateResponse) :
                foreach ($headers as $key => $value) {
                    $response->header($key, $value);
                }
                break;
            // laravel-excel
            case ($response instanceof $SymfonyResponse):
                foreach ($headers as $key => $value) {
                    $response->headers->set($key, $value);
                }
                break;
        }

        return $response;
    }
}

```

后来改用 PhpSpreadSheet 来实现数据的写入，整个流程是打通，但是如果通过传输流文件到前端，然后再解析出来，发现又存在跨域的问题。

目前可以解决的办法是，在导出流文件的代码那边直接添加解决跨域的头文件信息。

```php
// 输出，添加对应的 header 头部
header('Content-Type:application/vnd.ms-excel');
header('Content-Disposition:attachment;filename="equipment.xlsx"');
header('Cache-Control:max-age=0');
$writer->save('php://output');
exit();
```

更改为：

```php
// 输出，添加对应的 header 头部
header('Access-Control-Allow-Origin', '*');
header("Access-Control-Allow-Credentials", true);
header("Access-Control-Allow-Methods", '*');
header("Access-Control-Allow-Headers", 'Content-Type,Access-Token');
header("Access-Control-Expose-Headers", '*');
// 以上为新增的
header('Content-Type:application/vnd.ms-excel');
header('Content-Disposition:attachment;filename="equipment.xlsx"');
header('Cache-Control:max-age=0');
$writer->save('php://output');
exit();
```

## 02

ajax 请求无法打开自动导出 excel 文件的弹出框，必须跳到 url 地址去才行，所以做了一个跳转链接，而且后端还必须直接返回文件，不能返回 json 格式的数组，不适合自己的应用场景。

额外知道了 ajax 下载二进制文件的方法。

[Laravel Excel 使用 Ajax 请求，没办法下载如何处理？(有方案)[vue][axios][Excel] | Laravel China 社区](https://learnku.com/laravel/t/6027/laravel-excel-uses-the-ajax-request-and-cannot-download-it-scheme-vue-axios-excel)

[Missing documentation for downloading binary files · Issue #448 · axios/axios](https://github.com/axios/axios/issues/448)

借鉴上面的知识，在 vue 里的实现如下。

```js
    testExcel() {
      axios.get(testurl, {
        responseType: 'arraybuffer'
      }).then((response) => {
        console.log(response);
      })
    },
```

这篇文章好好研究，应该可以实现通过 Ajax 请求直接下载 excel 文件：[Laravel-Excel 无法导出数据的问题 | Laravel China 社区](https://learnku.com/laravel/t/46011)。

```
    testExcel() {
      axios.get(testurl, {
        responseType: 'blob',
        headers: {
        'Content-Type': 'application/json'
        }
      }).then((response) => {
        console.log(response);
        this.loading = false

        const content = response.data;
        const blob = new Blob([content]);
        const fileName = '导出信息.xlsx';
        if ('download' in document.createElement('a')) {
            // 非IE下载
            const elink = document.createElement('a');
            elink.download = fileName;
            elink.style.display = 'none';
            elink.href = URL.createObjectURL(blob);
            document.body.appendChild(elink);
            elink.click();
            URL.revokeObjectURL(elink.href); // 释放URL 对象
            document.body.removeChild(elink);
        } else {
            // IE10+下载
            navigator.msSaveBlob(blob, fileName);
        }
      })
    },
```

## 03

发现 PhpSpreadSheet 应该是可以解决自己的需求的。

[PHPOffice/PhpSpreadsheet: A pure PHP library for reading and writing spreadsheet files](https://github.com/PHPOffice/PhpSpreadsheet)

[Welcome to PhpSpreadsheet's documentation - PhpSpreadsheet Documentation](https://phpspreadsheet.readthedocs.io/en/latest/)

[Laravel 插件 PhpSpreadSheet 使用总结 | Laravel China 社区](https://learnku.com/articles/29608)

基本思路参考这个：[PHP Excel | Laravel China 社区](https://learnku.com/articles/43302)。

详见消化吸收的 PhpSpreadsheet 文档。

前、后端导出 excel 讲的比较清楚的一篇文章：[前后端生成Excel下载的差异 - 栋栋也疯狂的个人空间 - OSCHINA](https://my.oschina.net/gcdong/blog/3009425)。

## 04

又碰到一些 laravel-excel 好的资料。

[Laravel Excel 的五个隐藏功能 | Laravel China 社区](https://learnku.com/laravel/t/24161)

[Export/Import with Excel in Laravel | Laravel Daily](https://laraveldaily.teachable.com/p/export-import-with-excel-in-laravel)

## 05

具体实现的时候参考了下面的文章，不过最大的收益来自官方文档，可以局域批量写数据。

[PHP读取和写入EXCEL，并实现文件下载](https://qii404.me/2018/10/31/php-excel.html)

[PhpOffice/PhpSpreadsheet读取和写入Excel - 简书](https://www.jianshu.com/p/10e1f047f2bd)

