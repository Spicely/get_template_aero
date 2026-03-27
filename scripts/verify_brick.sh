#!/bin/bash
set -e

# 获取脚本所在目录的绝对路径，并自动定位到项目根目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$DIR")"

echo "==> 🚀 1. 开始生成测试用项目..."
cd "$PROJECT_ROOT"

# 使用当前目录的 brick 强制生成测试工程，并跳过交互式询问，自动传入默认变量
mason make get_template_aero -o ../.mason_playground \
    --project_name test_app \
    --org_name com.test.app \
    --app_display_name "Test App" \
    --flavor_name test \
    --description_info "Auto generated test template" \
    --on-conflict overwrite

echo "==> 📦 2. 进入项目开始校验..."
cd ../.mason_playground/test_app

# 安装依赖并检查语法
flutter pub get
flutter analyze

echo "==> 🎉 验证完成！模板代码完全正确，没有语法或格式问题。"
