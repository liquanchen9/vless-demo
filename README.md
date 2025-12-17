# VLESS demo 

## 概述

本专案用于在 测试 VLESS

## 部署

### 步骤
 


点击上面的链接以部署  

### 变量

对部署时需设定的变量名称做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `ID` | `******-***` | VLESS 用户 ID，用于身份验证，为 UUID 格式 例如：ad806487-2d26-4636-98b6-ab85cc8521f7 |
| `WSPATH` | `/` | WebSocket 所使用的 HTTP 协议路径 |

## 接入 CloudFlare

以下两种方式均可以将应用接入 CloudFlare，从而在一定程度上提升速度。

 1. 为应用绑定域名，并将该域名接入 CloudFlare
 2. 通过 CloudFlare Workers 反向代理
 3. 通过 CloudFlare 优选IP 国内访问

## 注意
 1. 若使用域名接入 CloudFlare，请考虑启用 TLS 1.3
 2. AWS 绝大部分 IPv4 地址已被 Twitter 屏蔽
