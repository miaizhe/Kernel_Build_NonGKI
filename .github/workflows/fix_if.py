import re

with open('.github/workflows/build-kernel.yml', 'r', encoding='utf-8') as f:
    content = f.read()

# 修复多余的 }}
content = re.sub(r"== true \}\} \}\}", "== 'true' }}", content)
content = re.sub(r"== 'syscall' \}\} \}\}", "== 'syscall' }}", content)

with open('.github/workflows/build-kernel.yml', 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed if conditions")
