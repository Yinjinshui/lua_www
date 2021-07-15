--ngx.header.content_type="text/plian"

--获取客户端真实ip
function get_client_ip()
     local headers=ngx.req.get_headers()
     local ip=headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"
     return ip
end
--ngx.say("客户端ip",get_client_ip())

--------------正式程序--------------
local cjson=require 'cjson'
local geo=require 'resty.maxminddb'
local arg_ip=ngx.var.arg_ip
--local arg_node=ngx.var.arg_node
--ngx.say("IP:",arg_ip,", node:",arg_node,"<br>")


--没有传递ip
if not arg_ip then
	arg_ip=ngx.var.remote_addr
end

if not geo.initted() then
        geo.init("/usr/local/openresty/lualib/vevor-lua/geoip/GeoLite2-Country.mmdb")
end

--当前服务部署的ip
--ngx.say("当前服务部署ip:",ngx.var.remote_addr)

local res,err=geo.lookup(arg_ip or ngx.var.remote_addr)

if not res then
	--获取不到ip，默认返回参数
	local result='{"msg": "success","code": 200,"country": {    "name_cn": "United States",    "name_en": "美国",    "code": "US"},"remote_ip": "'..ngx.var.remote_addr..'","continent": {    "name_cn": "北美洲",    "name_en": "North America",    "code": "NA"},"default":1}';
        ngx.say(result)
        ngx.log(ngx.ERR,' failed to lookup by ip , reason :',err)
else
	for k,v in pairs(res) do
        	--获取国家
        	if(k == "country") then
			--获取国家编码
			for key,item in pairs(v) do
				if (key=="iso_code") then
					--ngs.say(item)
				end
			end
		end
	end

	--原始数据
	--[[
	ngx.say(cjson.encode(res))
	ngx.exit(200)
	]]--

	--提取数据
	local result={
		code=200,
		country={
			code=res['country']['iso_code'], --国家编码
			name_en=res['country']['names']['en'], 
			name_cn=res['country']['names']['zh-CN']	
		},
		continent={
			code=res['continent']['code'], --大陆编码
                        name_en=res['continent']['names']['en'], 
                        name_cn=res['continent']['names']['zh-CN']
		},
		remote_ip=ngx.var.remote_addr,
		msg="success",
		default=0
		}
	ngx.say(cjson.encode(result))
	
        --ngx.say("Result:",cjson.encode(res))

        if arg_node then
                ngx.say("node name:",ngx.var.arg_node, " , value:",cjson.encode(res[ngx.var.arg_node] or {}))
 
        end
 
end

ngx.exit(200)
