## 00. 安装相关

### 1. Aspen8.4 的安装

1、先 NetFrame4.0，再安装 SQL Express2008；

先装的东西全选；选对所有服务使用相同的账号，选 ***\SYSTEM；模式就选 Windows 验证；要添加当前用户；

2、安装完在「控制面板」的「打开或关闭 Windows 功能」里勾选 Internet 信息服务和可承载 web 核心；

3、按照「安装白羊版」那个 PDF 的教程走；

## 01. 物性代号

分子量——MW

临界温度——TC 

临界压力——PC

临界体积——VC

标准态下的物性物性代号生成热——DHFORM

生成自由能——DGFORM

沸点——TB

标准沸点下的摩尔体积——VB

汽化热——DHVLB

凝固点——TEP

相对密度——SG

临界压缩因子——ZC

偏心因子——OMEGA 

偶极距——MUP

回转半径——RGYR

API 重度——API

溶解度参数——DELTA

等张比容——PARC

纯物质粘度——MU；混合物粘度——MUMX

纯物质导热系数——K；混合物导热系数——KMX

纯物质密度——RHO；混合物密度——RHOMX

## 02. 快捷键汇总

1、关叠加小窗口的快捷键：ctrl+F4

2、拉直流股的快捷键：ctrl+B



## V10版本操作记录

### 1. 算给定操作条件下的各个物性

1、在物性里新建一个物性集 PS-1，把要算的物性加进去。

2、在模拟板块的 Report Options 里，进 Stream 面板，进入 Property Sets，把 PS-1 加进去。