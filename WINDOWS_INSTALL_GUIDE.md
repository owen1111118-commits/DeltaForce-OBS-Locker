# Windows 电脑端完整安装指南

> **目标**: 在 Windows 10/11 上一键部署 DeltaForce OBS Locker 电脑端项目

---

## 📋 前置需求

### 必需软件

| 软件 | 版本 | 下载地址 |
|------|------|---------|
| **Python** | 3.11+ | https://www.python.org/downloads/ |
| **Git** | 最新版 | https://git-scm.com/download/win |
| **Visual C++ Build Tools** | 2022 | https://visualstudio.microsoft.com/visual-cpp-build-tools/ |

### 系统要求

- **操作系统**: Windows 10 / 11 (x64)
- **RAM**: 至少 8GB（推荐 16GB+）
- **硬盘**: 至少 10GB 可用空间
- **网络**: 稳定的互联网连接

### GPU 加速（可选但推荐）

- **NVIDIA GPU**: GTX 960 或更高
- **显卡驱动**: 最新版本
- **CUDA Toolkit**: 11.8+
- **cuDNN**: 8.7+

---

## 🚀 快速开始（推荐）

### 方法 A：一键部署脚本（最简单）

#### 步骤 1: 检查前置环境

```cmd
# 打开命令提示符，验证 Python
python --version

# 应输出 Python 3.11.x 或更高版本
```

#### 步骤 2: 克隆项目

```cmd
# 使用 Git 克隆（包含所有子模块）
git clone --recursive https://github.com/owen1111118-commits/DeltaForce-OBS-Locker.git

# 进入项目目录
cd DeltaForce-OBS-Locker
```

#### 步骤 3: 运行部署脚本

```cmd
# 直接双击运行脚本
Windows_Deploy.bat

# 或在命令行运行
.\Windows_Deploy.bat
```

**脚本做了什么？**

- ✅ 检查 Python 和 Git 环境
- ✅ 创建虚拟环境
- ✅ 安装所有依赖包
- ✅ 验证安装是否成功
- ✅ 创建启动快捷方式
- ✅ 生成测试脚本

**预期输出:**

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║              ✓ 部署完成！                                      ║
║                                                                ║
║  下一步操作:                                                  ║
║  1. 双击 Run_WebUI.bat 启动 Web 界面                          ║
║  2. 或双击 Run_Test.bat 检查环境                              ║
║  3. 或编辑 config.yaml 配置项目参数                           ║
║  4. 阅读 README.md 了解更多详情                               ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## 🔧 手动安装步骤

如果一键脚本无法使用，按以下步骤手动安装：

### 步骤 1: 创建虚拟环境

```cmd
# 使用 venv 创建虚拟环境
python -m venv deltaforce_env

# 激活虚拟环境
deltaforce_env\Scripts\activate.bat

# 验证激活成功（命令行前会出现 (deltaforce_env)）
```

### 步骤 2: 升级 pip

```cmd
python -m pip install --upgrade pip setuptools wheel
```

### 步骤 3: 安装依赖

**方式 A：使用 requirements.txt（推荐）**

```cmd
pip install -r yolov14/requirements.txt -i https://pypi.tsinghua.edu.cn/simple
```

**方式 B：分步安装（如果方式 A 失败）**

```cmd
# PyTorch + TorchVision
pip install torch==2.2.2 torchvision==0.17.2 --index-url https://download.pytorch.org/whl/cu118

# 计算机视觉库
pip install opencv-python==4.9.0.80 -i https://pypi.tsinghua.edu.cn/simple

# 模型和推理框架
pip install timm==1.0.14 albumentations==2.0.4 -i https://pypi.tsinghua.edu.cn/simple
pip install onnx==1.14.0 onnxruntime==1.15.1 -i https://pypi.tsinghua.edu.cn/simple

# 工具库
pip install yaml supervision gradio pycocotools -i https://pypi.tsinghua.edu.cn/simple
```

**方式 C：GPU 加速版（NVIDIA 用户）**

```cmd
# 安装 CUDA 版本的 PyTorch
pip install torch==2.2.2 torchvision==0.17.2 --index-url https://download.pytorch.org/whl/cu118

# 安装 GPU 推理库
pip install onnxruntime-gpu==1.18.0

# 其他依赖同方式 B
```

### 步骤 4: 验证安装

```cmd
# 运行测试脚本
python test_installation.py
```

**预期输出:**

```
======================================================================
🔍 DeltaForce 电脑端环境检查报告
======================================================================

系统: Windows 10
Python: 3.11.x

依赖检查:
  ✓ PyTorch
  ✓ OpenCV
  ✓ NumPy
  ✓ PyYAML
  ✓ ONNX Runtime
  ✓ Gradio
  ✓ Albumentations
  ✓ Supervision

总计: 8/8 个模块已安装

GPU 加速: ✓ 启用 (CUDA 11.8)
GPU 型号: NVIDIA GeForce RTX 3060

======================================================================
✓ 环境检查完成！您可以开始使用 DeltaForce 了
======================================================================
```

---

## 🎬 运行应用

### 方式 1: 启动 Web 界面（推荐新手）

```cmd
# 激活虚拟环境（如果还没激活）
deltaforce_env\Scripts\activate.bat

# 进入 yolov14 目录
cd yolov14

# 启动 Gradio Web 界面
python app.py

# 在浏览器打开
# http://127.0.0.1:7860
```

**功能:**
- 上传图像进行检测
- 实时预览检测结果
- 调整参数进行微调
- 下载处理后的图像

### 方式 2: 运行主程序

```cmd
# 确保虚拟环境已激活
deltaforce_env\Scripts\activate.bat

# 检测单张图像
python main.py --input screenshot.jpg

# 检测视频
python main.py --input video.mp4

# 实时摄像头
python main.py --mode camera

# OBS 窗口捕获
python main.py --mode obs
```

### 方式 3: 使用 Python 脚本

```python
# 创建 my_test.py
from ultralytics import YOLO
import cv2

# 加载模型
model = YOLO("yolov8m.pt")

# 检测图像
results = model.predict("test_image.jpg")

# 显示结果
for r in results:
    r.show()
    
    # 打印检测结果
    for box in r.boxes:
        print(f"检测到: {r.names[int(box.cls)]}, 置信度: {box.conf:.2f}")
```

运行:
```cmd
python my_test.py
```

---

## 📁 项目结构说明

```
DeltaForce-OBS-Locker/
├── Windows_Deploy.bat              ← 一键部署脚本（双击运行）
├── WINDOWS_INSTALL_GUIDE.md        ← 本文件
├── README.md                       ← 项目说明
├── test_installation.py            ← 环境检查脚本
├── requirements.txt                ← Python 依赖（可选）
│
├── yolov14/                        ← YOLOv14 核心代码
│   ├── app.py                      ← Web 界面（Gradio）
│   ├── requirements.txt            ← YOLOv14 依赖
│   ├── ultralytics/                ← Ultralytics 模型库
│   │   ├── nn/                     ← 神经网络模块
│   │   ├── cfg/                    ← 模型配置文件
│   │   └── ...
│   └── README.md
│
├── Desktop/                        ← 电脑端代码（Submodule）
│   ├── main.py                     ← 主程序
│   ├── config.yaml                 ← 配置文件
│   ├── utils/                      ← 工具函数
│   └── models/                     ← 模型权重存储
│
└── Mobile/                         ← 手机端（Submodule）
    └── APK 及下载脚本
```

---

## ⚙️ 配置文件说明

### config.yaml 配置

```yaml
# 模型配置
model:
  name: "yolov8m"                # 模型名称
  conf_threshold: 0.5            # 置信度阈值（0-1）
  iou_threshold: 0.45            # IOU 阈值
  device: 0                      # GPU 设备 ID（-1=CPU）

# 输入配置
input:
  mode: "image"                  # 模式: camera/video/image/obs
  source: "test.jpg"             # 输入源

# 输出配置
output:
  save_dir: "./results"          # 结果保存目录
  save_video: true               # 是否保存视频
  display: true                  # 是否显示实时画面

# 处理配置
processing:
  fps: 30                        # 处理帧率
  size: [640, 640]              # 输入大小
```

---

## 🐛 常见问题解决

### 问题 1: Python 未安装或找不到

**症状:** `'python' 不是内部或外部命令`

**解决:**
```cmd
# 检查 Python 是否在 PATH 中
python --version

# 如果不行，使用完整路径
C:\Users\YourUsername\AppData\Local\Programs\Python\Python311\python.exe --version

# 或重新安装 Python，勾选 "Add Python to PATH"
```

### 问题 2: pip 安装超时

**症状:** `Connection timeout` 或 `Network is unreachable`

**解决:**
```cmd
# 使用清华大学镜像源
pip install -i https://pypi.tsinghua.edu.cn/simple <package>

# 或阿里云镜像
pip install -i https://mirrors.aliyun.com/pypi/simple/ <package>

# 增加超时时间
pip install -i https://pypi.tsinghua.edu.cn/simple --default-timeout=1000 -r requirements.txt
```

### 问题 3: GPU 不被识别

**症状:** `CUDA 可用: False` 或 `GPU 型号: Unknown`

**解决:**
```cmd
# 检查 CUDA 支持
python -c "import torch; print(torch.cuda.is_available())"

# 如果 False，重新安装 CUDA 版本的 PyTorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# 检查显卡驱动
# https://www.nvidia.com/Download/driverDetails.aspx
```

### 问题 4: 虚拟环境激活失败

**症状:** `无法找到文件 deltaforce_env\Scripts\activate.bat`

**解决:**
```cmd
# 重新创建虚拟环境
python -m venv deltaforce_env

# 使用完整路径激活
deltaforce_env\Scripts\activate.bat

# 或使用 PowerShell（需要管理员权限）
deltaforce_env\Scripts\Activate.ps1
```

### 问题 5: 模块导入错误

**症状:** `ModuleNotFoundError: No module named 'torch'`

**解决:**
```cmd
# 确保虚拟环境已激活
deltaforce_env\Scripts\activate.bat

# 检查虚拟环境中的 Python
where python

# 重新安装依赖
pip install torch torchvision -i https://pypi.tsinghua.edu.cn/simple
```

---

## 📥 下载模型权重

### 自动下载（推荐）

```python
# 创建 download_models.py
from ultralytics import YOLO

print("正在下载 YOLOv8 模型...")
model = YOLO("yolov8m.pt")  # 自动下载到 ~/.yolov8/weights/
print("✓ 下载完成！")
```

运行:
```cmd
python download_models.py
```

### 手动下载

模型会自动保存到：
```
C:\Users\<YourUsername>\.yolov8\weights\
```

---

## ✅ 部署完成检查清单

在开始使用前，确保以下项目全部通过：

- [ ] Python 3.11+ 已安装
- [ ] 虚拟环境已创建并激活
- [ ] 所有依赖已安装
- [ ] `test_installation.py` 运行成功
- [ ] 所有模块显示 ✓
- [ ] GPU 已识别（如有 NVIDIA 显卡）
- [ ] 模型权重已下载
- [ ] Web 界面可以启动（http://127.0.0.1:7860）
- [ ] 至少一张测试图像可以成功检测

---

## 🚦 下一步操作

### 初学者路线

1. **启动 Web 界面**
   ```cmd
   .\Run_WebUI.bat
   ```
   - 上传图像测试
   - 查看检测结果

2. **阅读项目文档**
   - [项目 README](README.md)
   - [YOLOv14 技术说明](yolov14/README.md)

3. **运行示例代码**
   - 修改 `my_test.py` 进行实验
   - 调整参数观察效果

### 进阶开发者路线

1. **学习 YOLOv14 架构**
   - 查看 `yolov14/ultralytics/` 源代码
   - 理解 DeformableAAttn、GameToReal 适配等

2. **自定义训练**
   - 准备数据集
   - 修改 YAML 配置
   - 开始训练

3. **集成 OBS**
   - 配置 OBS 窗口捕获
   - 实现实时检测

---

## 📞 获取帮助

### 官方文档

- **项目主页**: https://github.com/owen1111118-commits/DeltaForce-OBS-Locker
- **技术博客**: https://blog.csdn.net/qq_63129682/article/details/161447283
- **CSDN 教程**:
  - [Python 环境配置指南](https://blog.csdn.net/qq_63129682/article/details/161473936)
  - [GitHub 账号注册指南](https://blog.csdn.net/qq_63129682/article/details/161460238)

### 常用命令速查

| 命令 | 功能 |
|------|------|
| `python --version` | 检查 Python 版本 |
| `pip list` | 列出已安装的包 |
| `pip install -r requirements.txt` | 安装依赖 |
| `python test_installation.py` | 环境检查 |
| `cd yolov14 && python app.py` | 启动 Web 界面 |
| `python main.py --input test.jpg` | 单图检测 |
| `deactivate` | 退出虚拟环境 |

---

## ⚠️ 重要声明

- **仅供学习**: 本项目仅供技术学习和原理研究
- **不修改内存**: 不修改任何游戏内存
- **禁止商用**: 严禁用于任何商业作弊工具
- **自担责任**: 使用者需自行承担使用本项目产生的一切后果

---

**最后更新**: 2026-06-17  
**维护者**: owen1111118-commits  
**许可证**: MIT License

