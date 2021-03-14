# 0702. PHPStudy

## 问题记录

### 01

进 MySQL 的图形工具后报错：SQL执行错误 #1055。

解决方案：[MySQL5.7.26 | MySQL-Front访问数据库报错：SQL执行错误 #1055_BaoYi的博客-CSDN博客_phpstduy sql 错误1055](https://blog.csdn.net/weixin_41360604/article/details/102651830)。

把 MySQL 的配置文件 my.ini 复制出来（直接修改不了，复制出来改完后替换回去），里面添加语句：

```
sql_mode='NO_ENGINE_SUBSTITUTION'
```

