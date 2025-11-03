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
