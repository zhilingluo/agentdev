import os.path

from dotenv import load_dotenv


def load_env():
    env_path = os.path.join(os.path.dirname(__file__),"..","..", ".env")
    load_dotenv(env_path)

def stdio_mcp(js):

    name=list(js.keys())[0]

    return {
        "name":name,
        "command":js[name]["command"],
        "args":js[name]["args"] if "args" in js[name] else [],
        "env":js[name]["env"] if "env" in js[name] else {}
    }


def markdown_to_html(md_text, html_file):
    import markdown

    html = markdown.markdown(md_text,extensions=['tables', 'fenced_code', 'nl2br'])
    with open(html_file, "w", encoding="utf-8") as f:
        f.write(html)



# 使用示例
if __name__ == "__main__":
    example_md="""
# 这是一个标题

这是**Markdown**格式的文本。

- 这是一个列表项
- 这是另一个列表项

```python
print("这是代码块")
```

| 表头 | 表头 |
| --- | --- |
| 表格内容 | 表格内容 |
"""
    markdown_to_html(example_md, "output.html")

if __name__ == "__main__":
    stdio_json = {
        "mcp-server-firecrawl": {
            "args": [
                "-y",
                "firecrawl-mcp"
            ],
            "command": "npx",
            "env": {
                "FIRECRAWL_API_KEY": os.environ.get("FIRECRAWL_API_KEY", "")
            }
        }
    }
    print(stdio_mcp(stdio_json))
