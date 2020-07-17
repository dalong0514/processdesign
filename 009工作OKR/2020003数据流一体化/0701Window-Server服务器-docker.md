# 0701. Window-Server服务器

[Windows 10 上的 Windows 和 Linux 容器 | Microsoft Docs](https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server)

[Windows Server 2016 安装Docker - BBSMAX](https://www.bbsmax.com/A/QW5YeK7q5m/)

## 连接

搜索框里直接输入 mstsc，会跳出远程桌面的连接面板，服务器 IP 地址：192.168.1.38，用户名 titan\fengdalong，输入密码即可远程连接到服务器。

```
安装Hyper-V
>Install-WindowsFeature -Name Hyper-V

安装容器功能
>Install-WindowsFeature -Name containers

安装完成后需重启服务器
>Restart-computer
```

确认 NuGet 是否在 PackageProvider 中。

```
PS C:\windows\system32> Get-PackageProvider -ListAvailable

Name                     Version          DynamicOptions
----                     -------          --------------
msi                      3.0.0.0          AdditionalArguments
msu                      3.0.0.0
PowerShellGet            1.0.0.1          PackageManagementProvider, Type, Scope, AllowClobber, SkipPublisherCheck, ...
Programs                 3.0.0.0          IncludeWindowsInstaller, IncludeSystemComponent
```

如果不在其中，那么需要获取 NuGet。

```
PS C:\windows\system32> Install-PackageProvider NuGet -Verbose
VERBOSE: Using the provider 'Bootstrap' for searching packages.
VERBOSE: Finding the package 'Bootstrap::FindPackage' 'NuGet','','','''.
VERBOSE: Performing the operation "Install Package" on target "Package 'nuget' version '2.8.5.208' from
'https://oneget.org/nuget-2.8.5.208.package.swidtag'.".
```

进自己的共享网盘：

```
\\feng--dalong
```

供参考的：

```
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$targetNugetExe = "$rootPath\nuget.exe"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
Set-Alias nuget $targetNugetExe -Scope Global -Verbose
```

