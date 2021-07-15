"# lua_www" 

**实现功能**

    1.根据 ip 识别 国家编码
        资料：https://dev.maxmind.com/geoip/geolite2-free-geolocation-data
   
   2. Lua 模块 demo
        资料：https://www.runoob.com/lua/lua-modules-packages.html
        
   3. Lua 对象使用
        资料：https://www.runoob.com/lua/lua-object-oriented.html   


**nginx配置**

具体查看nginx.conf 
所在目录：/usr/local/openresty/nginx/conf/nginx.conf

    #关闭代码缓存 。修改lua脚本不需要重启
        lua_code_cache off;
        lua_package_path  "/usr/local/openresty/lualib/?.lua;;";
        lua_package_cpath  "/usr/local/openresty/lualib/?.so;;";

    server {
            listen       80;
            server_name  localhost;
    
            #charset koi8-r;
    
            #access_log  logs/host.access.log  main;
    
            location / {
                root   html;
                index  index.html index.htm;
            }
    
             location /lua {
                    default_type "text/html";
                    proxy_set_header            X-real-ip $remote_addr;
                    proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
                    #return 200 $proxy_add_x_forwarded_for;
                    charset utf-8;
                    #lua_code_cache off;
                    content_by_lua_file  /usr/local/openresty/lualib/vevor-lua/geoip/test.lua;
            }
    
            location /test {
                default_type text/html;
                content_by_lua '
                    ngx.say("<p>Hello, World!</p>")
                ';
            }


        location /test {
            default_type text/html;
            content_by_lua '
                ngx.say("<p>Hello, World!</p>")
            ';
        }

    }
    
    
    
**lua 文件存放目录**
    
    [root@localhost vevor-lua]# pwd
    /usr/local/openresty/lualib/vevor-lua

    [root@localhost vevor-lua]# ll
    total 0
    drwxr-xr-x. 2 root root 54 Jul 16 10:03 class
    drwxr-xr-x. 2 root root 29 Jul 15 19:18 common
    drwxr-xr-x. 2 root root 22 Jul 16 08:42 config
    drwxr-xr-x. 2 root root 89 Jul 16 09:23 geoip
    
    
**conf.d 存放目录**    

    [root@localhost conf.d]# pwd
    /etc/nginx/conf.d
    [root@localhost conf.d]# ll
    total 4
    -rw-r--r--. 1 root root 1778 Jul 15 19:40 test.lua.conf
