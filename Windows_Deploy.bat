@echo off
:: ========================================================================
::  DeltaForce-OBS-Locker Windows 一键部署脚本 v1.0
::  平台: Windows 10/11 x64
::  需求: Python 3.11+, Git
:: ========================================================================

setlocal enabledelayedexpansion
chcp 65001 > nul
cls

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║   DeltaForce OBS Locker - 电脑端完全部署工具 v3.0.0           ║
echo ║   Windows 智能安装脚本                                       ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

:: 颜色定义
set GREEN=[92m
set YELLOW=[93m
set RED=[91m
set RESET=[0m

:: ========================================================================
:: 步骤 1: 检查系统环境
:: ========================================================================
echo [*] 步骤 1/8: 检查系统环境...
echo.

:: 检查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo %RED%✗ 错误: 未检测到 Python%RESET%
    echo.
    echo 请先安装 Python 3.11 或更高版本
    echo 下载地址: https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VER=%%i
    echo %GREEN%✓ Python 已安装: !PYTHON_VER!%RESET%
)

:: 检查 Git
git --version >nul 2>&1
if errorlevel 1 (
    echo %YELLOW%⚠ 警告: 未检测到 Git，部分功能可能受限%RESET%
    echo   建议下载: https://git-scm.com/download/win
    set NO_GIT=1
) else (
    for /f "tokens=3" %%i in ('git --version') do set GIT_VER=%%i
    echo %GREEN%✓ Git 已安装: !GIT_VER!%RESET%
)

echo.
pause /b

:: ========================================================================
:: 步骤 2: 创建虚拟环境
:: ========================================================================
echo [*] 步骤 2/8: 创建 Python 虚拟环境...
echo.

if exist "deltaforce_env" (
    echo %YELLOW%⚠ 虚拟环境已存在，跳过创建%RESET%
) else (
    echo 正在创建虚拟环境: deltaforce_env
    python -m venv deltaforce_env
    if errorlevel 1 (
        echo %RED%✗ 虚拟环境创建失败%RESET%
        pause
        exit /b 1
    )
    echo %GREEN%✓ 虚拟环境创建成功%RESET%
)

echo.

:: ========================================================================
:: 步骤 3: 激活虚拟环境
:: ========================================================================
echo [*] 步骤 3/8: 激活虚拟环境...
echo.

call deltaforce_env\Scripts\activate.bat
if errorlevel 1 (
    echo %RED%✗ 虚拟环境激活失败%RESET%
    pause
    exit /b 1
)
echo %GREEN%✓ 虚拟环境已激活%RESET%

echo.

:: ========================================================================
:: 步骤 4: 升级 pip
:: ========================================================================
echo [*] 步骤 4/8: 升级 pip, setuptools, wheel...
echo.

python -m pip install --upgrade pip setuptools wheel --quiet
if errorlevel 1 (
    echo %RED%✗ pip 升级失败%RESET%
    pause
    exit /b 1
)
echo %GREEN%✓ pip 升级成功%RESET%

echo.

:: ========================================================================
:: 步骤 5: 下载项目依赖
:: ========================================================================
echo [*] 步骤 5/8: 安装项目依赖包...
echo.

if exist "yolov14\requirements.txt" (
    echo 检测到 requirements.txt，开始安装...
    pip install -r yolov14/requirements.txt -i https://pypi.tsinghua.edu.cn/simple --no-cache-dir
    if errorlevel 1 (
        echo %YELLOW%⚠ 部分依赖安装失败，尝试使用默认源重新安装%RESET%
        pip install -r yolov14/requirements.txt --no-cache-dir
    )
) else (
    echo %YELLOW%⚠ 未找到 requirements.txt，手动安装关键依赖%RESET%
    pip install torch==2.2.2 torchvision==0.17.2 -i https://pypi.tsinghua.edu.cn/simple
    pip install timm==1.0.14 albumentations==2.0.4 opencv-python==4.9.0.80 -i https://pypi.tsinghua.edu.cn/simple
    pip install onnxruntime==1.15.1 gradio==4.44.1 supervision==0.22.0 -i https://pypi.tsinghua.edu.cn/simple
)

if errorlevel 1 (
    echo %RED%✗ 依赖安装失败%RESET%
    pause
    exit /b 1
)
echo %GREEN%✓ 依赖安装成功%RESET%

echo.

:: ========================================================================
:: 步骤 6: 验证安装
:: ========================================================================
echo [*] 步骤 6/8: 验证安装...
echo.

echo 正在检查关键模块...

python -c "import torch; print(f'  ✓ PyTorch {torch.__version__}'); print(f'  ✓ CUDA 可用: {torch.cuda.is_available()}')" 2>nul
if errorlevel 1 (
    echo %RED%  ✗ PyTorch 检查失败%RESET%
) else (
    echo %GREEN%  ✓ PyTorch 检查通过%RESET%
)

python -c "import cv2; print(f'  ✓ OpenCV {cv2.__version__}')" 2>nul
if errorlevel 1 (
    echo %RED%  ✗ OpenCV 检查失败%RESET%
) else (
    echo %GREEN%  ✓ OpenCV 检查通过%RESET%
)

python -c "from ultralytics import YOLO; print('  ✓ Ultralytics 可用')" 2>nul
if errorlevel 1 (
    echo %RED%  ✗ Ultralytics 检查失败%RESET%
) else (
    echo %GREEN%  ✓ Ultralytics 检查通过%RESET%
)

python -c "import yaml; print('  ✓ PyYAML 可用')" 2>nul
if errorlevel 1 (
    echo %RED%  ✗ PyYAML 检查失败%RESET%
) else (
    echo %GREEN%  ✓ PyYAML 检查通过%RESET%
)

echo.

:: ========================================================================
:: 步骤 7: 创建测试脚本
:: ========================================================================
echo [*] 步骤 7/8: 创建测试脚本...
echo.

cat > test_installation.py << 'EOF'
# -*- coding: utf-8 -*-
import sys
import platform

print("=" * 70)
print("🔍 DeltaForce 电脑端环境检查报告")
print("=" * 70)
print()

# 系统信息
print(f"系统: {platform.system()} {platform.release()}")
print(f"Python: {sys.version.split()[0]}")
print()

# 模块检查
modules = {
    'torch': 'PyTorch',
    'cv2': 'OpenCV',
    'numpy': 'NumPy',
    'yaml': 'PyYAML',
    'onnxruntime': 'ONNX Runtime',
    'gradio': 'Gradio',
    'albumentations': 'Albumentations',
    'supervision': 'Supervision',
}

print("依赖检查:")
success = 0
for module, name in modules.items():
    try:
        __import__(module)
        print(f"  ✓ {name}")
        success += 1
    except ImportError:
        print(f"  ✗ {name}")

print()
print(f"总计: {success}/{len(modules)} 个模块已安装")
print()

# CUDA 检查
try:
    import torch
    if torch.cuda.is_available():
        print(f"GPU 加速: ✓ 启用 (CUDA {torch.version.cuda})")
        print(f"GPU 型号: {torch.cuda.get_device_name(0)}")
    else:
        print("GPU 加速: ✗ 禁用 (使用 CPU 模式)")
except:
    pass

print()
print("=" * 70)
print("✓ 环境检查完成！您可以开始使用 DeltaForce 了")
print("=" * 70)
EOF

python test_installation.py
echo.

:: ========================================================================
:: 步骤 8: 创建启动脚本
:: ========================================================================
echo [*] 步骤 8/8: 生成启动快捷方式...
echo.

:: 生成启动脚本 - Web 界面
cat > Run_WebUI.bat << 'EOF'
@echo off
chcp 65001 > nul
call deltaforce_env\Scripts\activate.bat
cd yolov14
echo 启动 Gradio Web 界面...
echo 访问地址: http://127.0.0.1:7860
echo.
python app.py
pause
EOF

:: 生成启动脚本 - 测试
cat > Run_Test.bat << 'EOF'
@echo off
chcp 65001 > nul
call deltaforce_env\Scripts\activate.bat
python test_installation.py
pause
EOF

:: 生成启动脚本 - Python 命令行
cat > Python_Shell.bat << 'EOF'
@echo off
chcp 65001 > nul
call deltaforce_env\Scripts\activate.bat
python
EOF

echo %GREEN%✓ 启动脚本已生成:%RESET%
echo   - Run_WebUI.bat      (启动 Web 界面)
echo   - Run_Test.bat       (运行环境检查)
echo   - Python_Shell.bat   (进入 Python 命令行)
echo.

:: ========================================================================
:: 完成
:: ========================================================================
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                                                                ║
echo ║              %GREEN%✓ 部署完成！%RESET%                               ║
echo ║                                                                ║
echo ║  下一步操作:                                                  ║
echo ║  1. 双击 Run_WebUI.bat 启动 Web 界面                          ║
echo ║  2. 或双击 Run_Test.bat 检查环境                              ║
echo ║  3. 或编辑 config.yaml 配置项目参数                           ║
echo ║  4. 阅读 README.md 了解更多详情                               ║
echo ║                                                                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

pause
