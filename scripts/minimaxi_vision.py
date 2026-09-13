#!/usr/bin/env python3
"""
minimaxi 视觉模型调用器

用法：
  python3 minimaxi_vision.py <图片路径> "你的问题"
  python3 minimaxi_vision.py <图片 URL> "你的问题"

环境变量：
  MINIMAXI_API_KEY（必需）

minimaxi 视觉 API 实际是 `/v1/text/chatcompletion_v2`，
模型名 `MiniMax-Text-01`（多模态）。
"""

import os
import sys
import json
import base64
import urllib.request
import urllib.error
from pathlib import Path
from mimetypes import guess_type


def call_minimaxi_vision(image_input: str, prompt: str, model: str = "MiniMax-Text-01") -> dict:
    """调用 minimaxi 视觉 API（chatcompletion_v2 端点）"""

    # 判断是 URL 还是本地路径
    if image_input.startswith("http://") or image_input.startswith("https://"):
        image_url = image_input
    else:
        # 本地文件 → 读 + base64 → data URL
        path = Path(image_input)
        if not path.exists():
            return {"error": f"图片不存在: {image_input}"}
        img_data = path.read_bytes()
        img_b64 = base64.b64encode(img_data).decode("utf-8")
        mime = guess_type(str(path))[0] or "image/png"
        image_url = f"data:{mime};base64,{img_b64}"

    payload = {
        "model": model,
        "messages": [
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {
                        "type": "image_url",
                        "image_url": {"url": image_url}
                    }
                ]
            }
        ],
        "max_tokens": 2000,
    }

    req = urllib.request.Request(
        "https://api.minimaxi.com/v1/text/chatcompletion_v2",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {os.environ['MINIMAXI_API_KEY']}"
        }
    )

    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        return {"error": f"HTTP {e.code}", "body": e.read().decode("utf-8", errors="replace")}
    except Exception as e:
        return {"error": str(e)}


def main():
    if len(sys.argv) < 3:
        print("用法: python3 minimaxi_vision.py <图片路径或URL> <问题>")
        print()
        print("示例:")
        print('  python3 minimaxi_vision.py /tmp/screenshot.png "描述这张图"')
        print('  python3 minimaxi_vision.py https://example.com/img.jpg "图里有什么?"')
        sys.exit(1)

    image_input = sys.argv[1]
    prompt = sys.argv[2]

    if "MINIMAXI_API_KEY" not in os.environ:
        # 尝试从 bashrc 读
        bashrc = Path.home() / ".bashrc"
        if bashrc.exists():
            import re
            m = re.search(r'^export MINIMAXI_API_KEY="?([^"\n]+)"?', bashrc.read_text(), re.MULTILINE)
            if m:
                os.environ["MINIMAXI_API_KEY"] = m.group(1)
                print(f"  从 .bashrc 读取到 Key (前 10 字符): {m.group(1)[:10]}...")

    if "MINIMAXI_API_KEY" not in os.environ:
        print("❌ 未设置 MINIMAXI_API_KEY")
        print("   export MINIMAXI_API_KEY='sk-cp-...'")
        sys.exit(1)

    print(f"📸 输入: {image_input[:80]}{'...' if len(image_input) > 80 else ''}")
    print(f"💬 问题: {prompt}")
    print()
    print("调用 minimaxi 视觉 API...")

    result = call_minimaxi_vision(image_input, prompt)

    if "error" in result:
        print(f"❌ 错误: {result['error']}")
        if "body" in result:
            print(f"   详情: {result['body'][:500]}")
        sys.exit(1)

    # 提取回复
    try:
        answer = result["choices"][0]["message"]["content"]
        print("=" * 60)
        print("minimaxi 视觉模型回复:")
        print("=" * 60)
        print(answer)
        print()
        print("=" * 60)
        usage = result.get("usage", {})
        print(f"Token 用量: prompt={usage.get('prompt_tokens', '?')}, "
              f"completion={usage.get('completion_tokens', '?')}, "
              f"total={usage.get('total_tokens', '?')}")
    except (KeyError, TypeError) as e:
        print(f"❌ 响应格式异常: {e}")
        print(json.dumps(result, ensure_ascii=False, indent=2)[:1000])


if __name__ == "__main__":
    main()