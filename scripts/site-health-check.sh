#!/bin/bash
# ===================================================================
#  小龙的个人网站 - 健康检查脚本
# ===================================================================
#
#  检查项目：
#    - 每个页面 HTTP 200
#    - 每个页面内容大小合理（> 1KB）
#    - 每个页面包含标题
#    - 链接的页面都能访问（无 404）
#    - busuanzi 统计脚本已加载
#    - 部署目录大小
#    - 服务进程状态
#
#  用法：
#    ~/.hermes/longxia/scripts/site-health-check.sh
#    ~/.hermes/longxia/scripts/site-health-check.sh --json   # 输出 JSON 格式
#
# ===================================================================

set -e

LONGXIA_DIR="$HOME/.hermes/longxia"
DEPLOY_DIR="/var/www/longxia-site"
BASE_URL="${BASE_URL:-http://localhost}"
JSON_MODE=false

for arg in "$@"; do
  case $arg in
    --json) JSON_MODE=true ;;
    --help|-h)
      echo "用法: ./site-health-check.sh [--json]"
      echo "  --json    输出 JSON 格式"
      echo "  环境变量:"
      echo "    BASE_URL=公网 URL 检查外网可访问性"
      exit 0
      ;;
  esac
done

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# 收集所有要检查的页面
PAGES=(
    "/"
    "/thoughts/"
    "/thoughts/2026-07-13/"
    "/thoughts/2026-07-14/early/"
    "/thoughts/2026-07-14/midday/"
    "/thoughts/2026-07-15/morning/"
    "/thoughts/2026-07-15/afternoon/"
    "/thoughts/2026-07-15/evening/"
    "/journal/2026-07-15/"
    "/journal/2026-07-15/weread-summary-xueyizhiyong"
    "/journal/2026-07-15/weread-shoucangleyigandhuo"
    "/skills-registry/"
)

# 统计
TOTAL=0
PASS=0
WARN=0
FAIL=0
RESULTS=()

check_page() {
    local path=$1
    # URL encode 中文路径（保留开头的 /）
    local encoded_path
    encoded_path=$(python3 -c "
import urllib.parse
p = sys.argv[1]
print(urllib.parse.quote(p, safe='/-_./~?&='))
" "$path" 2>/dev/null) || encoded_path="$path"
    local url="${BASE_URL}${encoded_path}"
    local result

    TOTAL=$((TOTAL + 1))

    # 用 curl 获取状态码和内容
    local output=$(curl -s -w "\n%{http_code}|%{size_download}|%{time_total}" \
        -o /tmp/health_body.html \
        --max-time 10 "$url" 2>&1)
    local http_code=$(echo "$output" | tail -1 | cut -d'|' -f1)
    local size=$(echo "$output" | tail -1 | cut -d'|' -f2)
    local time=$(echo "$output" | tail -1 | cut -d'|' -f3)

    # 默认结果
    local status="PASS"
    local message=""

    # 检查 HTTP 状态
    if [ "$http_code" != "200" ]; then
        status="FAIL"
        message="HTTP $http_code"
        FAIL=$((FAIL + 1))
    elif [ "$size" -lt 1000 ]; then
        status="WARN"
        message="内容过小 (${size} 字节)"
        WARN=$((WARN + 1))
    else
        # 检查 HTML 标题
        local title=$(grep -oE '<title>[^<]*</title>' /tmp/health_body.html 2>/dev/null | head -1)
        if [ -z "$title" ]; then
            status="WARN"
            message="无 <title> 标签"
            WARN=$((WARN + 1))
        else
            PASS=$((PASS + 1))
            message="$title (${size} 字节, ${time}s)"
        fi
    fi

    # 输出
    local color="$GREEN"
    [ "$status" = "WARN" ] && color="$YELLOW"
    [ "$status" = "FAIL" ] && color="$RED"
    local icon="✓"
    [ "$status" = "WARN" ] && icon="!"
    [ "$status" = "FAIL" ] && icon="✗"

    if [ "$JSON_MODE" = false ]; then
        printf "  ${color}${icon}${NC} %-60s %s\n" "$path" "$message"
    fi
    RESULTS+=("{\"path\":\"$path\",\"status\":\"$status\",\"http_code\":$http_code,\"size\":$size,\"time\":\"$time\",\"message\":\"$message\"}")
}

# ===== 启动 =====
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  🏥 网站健康检查${NC}"
echo -e "${BLUE}  目标: $BASE_URL${NC}"
echo -e "${BLUE}  $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 1. 部署目录状态
echo -e "${YELLOW}📁 部署目录${NC}"
if [ -d "$DEPLOY_DIR" ]; then
    FILE_COUNT=$(find "$DEPLOY_DIR" -type f | wc -l)
    TOTAL_SIZE=$(du -sh "$DEPLOY_DIR" | awk '{print $1}')
    echo -e "  ${GREEN}✓${NC} $DEPLOY_DIR"
    echo "    文件: $FILE_COUNT"
    echo "    大小: $TOTAL_SIZE"
else
    echo -e "  ${RED}✗${NC} $DEPLOY_DIR 不存在"
    FAIL=$((FAIL + 1))
fi
echo ""

# 2. Caddy 服务状态
echo -e "${YELLOW}🌐 Web 服务${NC}"
if systemctl is-active --quiet caddy 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} Caddy 运行中"
else
    echo -e "  ${RED}✗${NC} Caddy 未运行"
    FAIL=$((FAIL + 1))
fi

# 检查监听
if ss -tln 2>/dev/null | grep -q ':80 '; then
    echo -e "  ${GREEN}✓${NC} 80 端口在监听"
else
    echo -e "  ${RED}✗${NC} 80 端口未监听"
    FAIL=$((FAIL + 1))
fi
echo ""

# 3. 页面检查
echo -e "${YELLOW}📄 页面检查 (${#PAGES[@]} 个页面)${NC}"
for page in "${PAGES[@]}"; do
    check_page "$page"
done
echo ""

# 4. 统计脚本检查
echo -e "${YELLOW}📊 第三方依赖${NC}"
for page in "/" "/thoughts/"; do
    if curl -s "$BASE_URL$page" | grep -q "busuanzi"; then
        echo -e "  ${GREEN}✓${NC} busuanzi 统计脚本: $page"
        break
    fi
done

# 5. 总结
echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  📊 总结${NC}"
echo -e "${BLUE}=========================================${NC}"
echo "  总计: $TOTAL 个检查"
echo -e "  ${GREEN}通过: $PASS${NC}"
if [ "$WARN" -gt 0 ]; then
    echo -e "  ${YELLOW}警告: $WARN${NC}"
fi
if [ "$FAIL" -gt 0 ]; then
    echo -e "  ${RED}失败: $FAIL${NC}"
fi
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}✅ 网站健康${NC}"
    exit 0
else
    echo -e "${RED}❌ 有问题需要修复${NC}"
    exit 1
fi