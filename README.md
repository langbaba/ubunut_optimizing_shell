# ubunut_optimizing_shell
ubuntu系统部署优化脚本


## 执行方式

需要root的 请使用sudo 或给予root权限后执行

```shell
    sodu ./ubuntu_shell.sh
```

输入对应数字后执行响应操作


### 包含内容

* 升级Linux Kernel  4.18.13 内核
* 开启 TCP - BBR 算法 
* 修改DNS为114与阿里公共DNS 223.5.5.5
* 安装openSSH 7.8p1
* 优化TCP参数与open files
* 设置系统时区为东8[shanghai]
* 禁止系统自动升级内核(高危漏洞也不自动升级)
* 中文字体安装(支持java环境下图片输出中文)
* 优化VIM
* Oracle JDK8u181 安装
* 安装Maven环境
* 安装docker环境
* 安装node v10.9.0环境

