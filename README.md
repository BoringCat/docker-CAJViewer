[![Docker Image](https://img.shields.io/badge/docker%20image-available-green.svg)](https://hub.docker.com/r/boringcat/cajviewer/)

## 更新版本
### 2020/04/09  
  * 构建的第一版

## **注意事项**
### 图形界面
* **别开太小，会崩溃（不是容器问题，可能是渲染图片纹理溢出什么的）**
* 记得挂载主机目录..........

## 准备工作

允许所有用户访问X11服务,运行命令:

```bash
xhost +
```

## 运行

### docker-compose

```yml
version: '2'
services:
  cajviewer:
    image: boringcat/cajviewer
    hostname: CAJViewer       # 容器主机名，为了好看
    devices:
      - /dev/fuse
    cap_add:
      - SYS_ADMIN
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - $HOME:/HostHome       # 可选，但是你不选怎么打开文件呢？
    environment:
      DISPLAY: unix$DISPLAY
```

或

```bash
    docker run -d --name cajviewer --hostname CAJViewer\
    --device /dev/fuse --cap-add SYS_ADMIN\
    -v /tmp/.X11-unix:/tmp/.X11-unix\
    -v $HOME:/HostHome\
    -e DISPLAY=unix$DISPLAY\
    boringcat/cajviewer
```
