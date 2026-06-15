# DeltaForce-OBS-Locker —— 电脑端和手机端均有

> **🆕 最新更新（2026-06-15）**：我们已将 **YOLOv14 跨域实时目标检测框架** 完整集成至本项目的电脑端，实现了游戏角色吸附、鱼眼/广角畸变校正、无人机视角小目标检测等前沿功能。欢迎各位开发者学习、改进或提交 PR。

### 🎉 为庆祝 2026 年高考圆满落幕，本项目特别开源手机端完整代码及 APK，供大家学习与交流使用！

> 💬 **技术交流邀请**  
> 本项目曾尝试通过 **ACE反作弊软件** 实现一种画面吸附效果的原理验证，实测发现该方案受游戏版本、系统环境等因素影响极大，不具备稳定复现的条件。  
> **欢迎熟悉底层图像识别 / 输入模拟原理的开发者** 进入 [Issues #19](https://github.com/ace-trump-tech/DeltaForce-OBS-Locker/issues/19) 参与技术讨论，共同探索更优的视觉识别与模拟输入思路。  

---

## 🎥 手机端功能演示

<div align="center">
  <img src="https://raw.githubusercontent.com/ace-trump-tech/DeltaForce-Locker/main/Mobile/demo_video.gif" alt="手机端功能演示" width="400">
  <br>
  <em>手机端 APK 核心效果（画面吸附 / 模拟输入演示）</em>
</div>

---

## 🚀 如何获取本项目（无论电脑端还是手机端）

请按照以下三步操作：

![Star -> Fork -> Download 流程示意图](https://raw.githubusercontent.com/ace-trump-tech/DeltaForce-Locker/main/Mobile/demo.png)

1. **⭐ Star**  
   点击本仓库右上角的 **Star** 按钮，申请自己的使用权限。

2. **⑂ Fork**  
   点击 **Fork** 按钮，将本仓库复制到你自己的 GitHub 账号下，不然无法进行修改。

3. **⬇️ Download**  
   在你自己 Fork 后的仓库页面，点击 **Code → Download ZIP** 下载压缩包。  

> 💡 **电脑端** 代码位于 `desktop/` 文件夹，**手机端** 脚本位于 `mobile/` 文件夹。下载后请根据对应子项目的 README 进行操作。

---

## 📚 完整教程（必读）

> **👉 [三角洲行动腾讯管家吸附原理 & 本项目 v3 版本介绍](https://blog.csdn.net/qq_63129682/article/details/161447283)**  
> **👉 [手把手教你注册GitHub账号](https://blog.csdn.net/qq_63129682/article/details/161460238)**
> **👉 [从零开始：两种主流方式轻松部署Python开发环境](https://blog.csdn.net/qq_63129682/article/details/161473936?spm=1001.2014.3001.5501)**

**请务必先阅读以上三篇教程**，它们包含了本项目的原理讲解、环境配置、常见问题解决等核心内容。

---

## 📦 项目构成

本仓库包含两个独立的子项目，分别面向 **电脑端（PC）** 和 **手机端（Android）**，均以技术教学与原理验证为目的。

| 子项目 | 主要技术栈 | 适合人群 | 详细文档 |
|--------|-----------|----------|----------|
| **电脑端** | Python, OpenCV, YOLOv14, OBS, SendInput | Python 初学者、计算机视觉爱好者 | [电脑端 README](https://github.com/ace-trump-tech/DeltaForce-Desktop/blob/main/README.md) |
| **手机端** | Python 下载脚本 + APK | 普通用户、Android 测试者 | [手机端 README](https://github.com/ace-trump-tech/DeltaForce-Locker/blob/main/Mobile/README.md) |

> 💡 **电脑端** 提供从零开始的 Python 编程实战教程（本地代码结构解析），其中 OBS 画面吸附功能正是基于 **YOLOv14** 目标检测框架实现；  
> **手机端** 提供 APK 自动下载脚本。

---

## 🧠 YOLOv14：统一跨域实时目标检测框架

**YOLOv14** 是一个专为 **非理想成像条件** 设计的实时目标检测框架。与假设标准针孔相机的传统 YOLO 不同，YOLOv14 通过学习 **域不变、视角鲁棒** 的特征，解决了以下难题：

| 场景 | 传统检测器 | YOLOv14 |
|------|-----------|---------|
| **鱼眼 / 广角镜头** | 边缘处漏检 | 可变形区域注意力（Deformable Area-Attention）扭曲特征网格以补偿畸变 |
| **游戏角色**（三角洲行动、COD、PUBG） | 无法识别为“人” | Game2Real 域适配对齐游戏/真实特征分布 |
| **无人机 / 俯视视角** | 小目标检测差 | 多视图条件 + 动态尺度路由器适应航空视角 |
| **360° 全景图** | 边界不连续、纬度畸变 | 球形注意力 + 循环卷积处理等矩形投影 |
| **混合相机源** | 单一模型无法处理所有 | 自适应增强策略自动选择每场景方法 |

### 系统流程

![System Pipeline](https://raw.githubusercontent.com/ace-trump-tech/DeltaForce-OBS-Locker/main/yolov14/pipeline.png)

流程包括六个阶段：

1. **场景分析** — 轻量级启发式分类输入场景类型（游戏、鱼眼、无人机、全景、标准）
2. **自适应增强**（仅训练）— 场景路由增强分支（游戏风格化、鱼眼畸变、透视变换、域混合）
3. **域适配** — DomainAdaptiveLayer + AdaIN 对齐游戏→真实特征统计；DomainAdversarialLoss 通过梯度反转驱动域不变学习
4. **多视图条件** — ViewEmbedding 注入 6 类视角嵌入（针孔、鱼眼、全景、无人机、BEV、地面）
5. **可变形特征金字塔** — 可变形区域注意力 + 动态尺度路由器自适应采样位置和尺度权重
6. **检测头** — 解耦的 P3/P4/P5 头 + 自适应 NMS

### 核心架构

```
Input → Scene Analysis → DomainAdaptiveLayer → ViewEmbedding →
DeformableA2C2f（×N）→ DynamicScaleRouter → Detect(P3/P4/P5)
```

#### 可变形区域注意力（D-AAttn）

用可学习的 2D 变形场替代标准区域注意力。偏移预测器在计算注意力之前扭曲特征网格，使模型能够适应局部几何畸变。

| 模块 | 描述 |
|------|------|
| `DeformableConv` | 密集扭曲再卷积；预测每像素偏移场 |
| `DeformableAAttn` | 在变形网格上计算区域注意力 |
| `DeformableA2C2f` | 带有可变形 ABlocks 的 R-ELAN 模块 |

#### Game2Real 域适配

三种互补机制连接游戏渲染域到摄影域：

- **数据级：** `GameCharacterStylization` 对真实图像应用海报化、边缘锐化、饱和度提升、对比度调整和非锐化掩模，模拟游戏引擎渲染。
- **特征级：** `DomainAdaptiveLayer` 使用自适应实例归一化（AdaIN）将游戏域特征统计向真实域分布靠拢。
- **目标级：** `DomainAdversarialLoss` 让域分类器与特征提取器进行极小极大博弈，产生域不变表征。

#### 自适应增强策略

`AdaptiveAugmentPolicy` 通过边缘密度、饱和均值和对比度方差启发式分析每个输入，然后选择最优增强分支。

#### 多视图条件

`ViewEmbedding` 将 6 类学习嵌入（针孔=0、鱼眼=1、全景=2、无人机=3、BEV=4、地面=5）通过拼接和 1×1 投影注入主干特征。`CrossViewConsistencyLoss`（NT-Xent 对比）将来自不同视图的同类特征在嵌入空间中拉近。

#### 自适应分辨率金字塔

`DynamicScaleRouter` 是一个轻量级门控网络，学习每个输入的 P3/P4/P5 尺度重要性权重。无人机视图强调 P3（小物体）；BEV/卫星视图平衡所有尺度。

#### 球形注意力

`SphereAAttn` 将特征图划分为纬度带，用于等矩形全景图的球面感知注意力。`CircularConv` 应用环绕式水平填充以保持 0°/360° 的边界连续性。

### 模型变体

| 变体 | 关键模块 | 目标场景 |
|------|---------|----------|
| Standard | A2C2f | 常规针孔图像 |
| Deformable | DeformableA2C2f | 鱼眼 / 广角 |
| MultiView | ViewEmbedding + CrossViewLoss | 无人机 / BEV / 混合视角 |
| Panorama | SphereAAttn + CircularConv | 360° 等矩形全景 |
| Game2Real | DomainAdaptiveLayer + DomainAdvLoss | 游戏角色检测 |
| Adaptive | 所有组件组合 | 通用 — 自动场景检测 |

### 快速开始

```bash
# 克隆本仓库后进入 yolov14 目录
cd yolov14

# 创建环境并安装依赖
conda create -n yolov14 python=3.11 supervision flash-attn
conda activate yolov14
pip install -r requirements.txt
pip install -e .
```

**训练 Game2Real 模型：**
```python
from ultralytics import YOLO
model = YOLO("ultralytics/cfg/models/v14/yolov14-game2real.yaml")
model.train(data="coco.yaml", epochs=300, imgsz=640)
```

**训练自适应模型（全部创新）：**
```python
model = YOLO("ultralytics/cfg/models/v14/yolov14-adaptive.yaml")
model.train(data="coco.yaml", epochs=300, imgsz=640)
```

**推理 —— 游戏角色被识别为“人”：**
```python
results = model.predict("delta_force_screenshot.jpg")
results[0].show()
```

**Web 演示：**
```bash
python app.py
# 打开 http://127.0.0.1:7860
```

### 项目结构

```
yolov14/
├── app.py                              # Web 演示
├── pipeline.png                        # 系统流程图
├── pipeline_prompt.txt                 # 绘图提示
├── pipeline_tikz.tex                   # TikZ 源码
├── fig_domain_adapt.tex                # 域适配 TikZ 图
├── table_ablation.tex                  # 消融实验表（LaTeX）
├── latex_guide.tex                     # 编译指南
├── ultralytics/
│   ├── nn/modules/
│   │   ├── block.py                    # A2C2f, DeformableAAttn, DeformableA2C2f,
│   │   │                              # ViewEmbedding, DynamicScaleRouter,
│   │   │                              # SphereAAttn, DomainAdaptiveLayer
│   │   ├── conv.py                    # Conv, DeformableConv, CircularConv
│   │   └── __init__.py
│   ├── nn/tasks.py                    # 模型注册表
│   ├── data/augment.py                # GameCharacterStylization,
│   │                                  # AdaptiveAugmentPolicy, DomainMixup
│   ├── utils/loss.py                  # CrossViewConsistencyLoss,
│   │                                  # DomainAdversarialLoss
│   └── cfg/models/v14/               # YOLOv14 模型配置
│       ├── yolov14-deformable.yaml
│       ├── yolov14-multiview.yaml
│       ├── yolov14-panorama.yaml
│       ├── yolov14-game2real.yaml
│       └── yolov14-adaptive.yaml
└── README.md
```

### 为什么是 YOLOv14？

YOLOv14 不是简单的增量更新。它引入了根本不同的设计理念：

| 方面 | 传统 YOLO | YOLOv14 |
|------|-----------|---------|
| **输入假设** | 理想针孔图像 | 任意相机模型 / 渲染引擎 |
| **领域** | 单域（真实照片） | 跨域（游戏→真实适配） |
| **视角** | 地面级前向 | 任意视角（无人机、BEV、地面、360°） |
| **增强** | 固定统一流程 | 自适应每场景策略 |
| **注意力** | 规则网格区域注意力 | 可变形采样位置 |

---

## 🚨 版本更新通知（V3.0.0）

- 截至 **2026年6月9日**，本项目代码逻辑在本机测试环境中仍可运行；若因游戏更新导致原理验证失效，将在本仓库第一时间同步说明。  
- 近期出现部分仿制或旧版本项目流传，请认准 **ace-trump-tech** 仓库。本项目始终免费开源，**任何收费行为均与项目初衷无关**。  

### ✅ V3.0.0 新特性
- **🪟 腾讯管家吸附原理验证**：演示通过模拟腾讯管家窗口置顶与鼠标穿透技术，实现“画面吸附”效果（环境依赖，仅用于研究）。
- **🧠 版本更迭历史整理**：记录 V1 → V3 各阶段的核心技术演进。

### ✅ 继承自 V2.6.0 的技术改进
- **动态路径隐藏演示**：动态加密 + 随机目录名，展示规避静态特征扫描的思路。
- **视觉中心模拟头部**：利用手电筒光斑视觉中心作为目标点。
- **强化人物判定模型**：优化 YOLOv14 骨骼点识别，多帧投票降噪。

> ⚠️ **重要声明**：本插件 **不修改任何游戏内存**，仅使用公开的图像识别与模拟输入 API。  
> **🔬 本版本仅供技术学习者对比研究，不建议在任何真实游戏对局中使用。**

---

## 📜 版本更迭简史（技术演进路线）

| 版本 | 主要技术演进 | 学习重点 |
|------|-------------|----------|
| **V1.x** | 基础 YOLO 检测 + OBS 捕获 + 简单鼠标移动 | OpenCV、YOLO推理、模拟输入入门 |
| **V2.x** | 动态路径隐藏、Base64编码、光斑视觉中心算法 | 反静态检测、坐标变换、多帧投票 |
| **V3.x** | 腾讯管家吸附原理验证、兼容性探讨 | 窗口穿透技术、输入模拟边界、环境适配 |

> 💡 **为什么不断迭代？** 游戏安全策略会更新，静态方法很快失效。本项目的价值在于展示 **如何根据环境变化调整技术方案**。

---

## 🔥 项目定位

- **电脑端**：基于真实游戏画面的 Python 编程实战项目，涵盖环境配置、图像处理、目标检测、模拟输入、反检测演示等。其中 **OBS 吸附功能正是 YOLOv14 框架的一次具体实践**。  
- **手机端**：提供 APK 文件及自动下载脚本，方便在 Android 设备上测试原理验证效果。

👉 详细代码结构与本地运行说明请分别查看：
- [电脑端 README（本地代码解析）](https://github.com/ace-trump-tech/DeltaForce-Desktop/blob/main/README.md)
- [手机端 README（APK 下载）](https://github.com/ace-trump-tech/DeltaForce-Locker/blob/main/Mobile/README.md)

---

## 📄 许可证

MIT License —— 可自由修改、二次开发，但**严禁用于任何商业作弊软件**。

---

## ⭐ 支持项目

如果你通过本项目学到了技术知识，请给仓库点一个 **Star**。  
你的星星，是对“用技术教学代替作弊工具”这一理念的认同。

*最后更新：2026-06-15*

5. 更新顶部最新更新日期和内容摘要。

你可以将此文件保存为 `README.md` 并推送到 `DeltaForce-OBS-Locker` 仓库的根目录。如果还需要调整细节（如图片链接、表格样式），请随时告知。
