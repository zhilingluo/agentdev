### Note
This cource code is platform-free, which means you can run it on Windows/Linux/MacOS.
But we suggest you to use MacOS.
The following bash commands are for MacOS, for example ``cp .env.template .env``. If you are using Windows or Linux, please refer to the official documentation.

### Prequisites
1. Python 3.11+
2. your modelscope api key (https://www.modelscope.cn/user/settings). 
3. uv #TODO add details

### Config
1. copy the '.env.template' to '.env'.
```bash
cp .env.template .env
```

2. Edit the ``.env`` file and set your modelscope api key. This file is looks like:
```text
MODELSCOPE_API_KEY=
```
You need add your modelscope api key after the ``MODELSCOPE_API_KEY=``.

3. Install the dependencies, you can use the following command.
```bash
pip install -r requirements.txt
```
