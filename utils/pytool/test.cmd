# dygateway命令脚本说明文档，# 号开头的行是注释，文档前面是接口使用说明
# 所有命令的参数都不应该为空，以一个 | 号隔开

host:                       127.0.0.1:8080

# del_upstream:               stable
# get_upstream:                             

# add_upstream:               stable| server 10.13.112.54:8020; server 10.13.112.54:8021 backup; keepalive 1000;
# get_upstream:                             
#  
# add_member:                 stable| 10.13.112.54| 8040| 1| 1| 10
# get_member:                 stable                
# 
# del_member:                 stable| 10.13.112.54| 8040
# get_member:                 stable                
# 
# setup_member:               stable| 1| weight=9| fail_timeout=9| max_fails=9
# get_member:                 stable                

# policygroup_set:                  {"1":{"divtype":"uidappoint","divdata":[{"uidset":[1234,5124,653],"upstream":"beta1"},{"uidset":[3214,652,145],"upstream":"beta2"}]},"2":{"divtype":"iprange","divdata":[{"range":{"start":1111,"end":2222},"upstream":"beta1"},{"range":{"start":3333,"end":4444},"upstream":"beta2"},{"range":{"start":7777,"end":8888},"upstream":"beta3"}]}} | {"1":{"divtype":"uidappoint","divdata":[{"uidset":[1234,5124,653],"upstream":"beta1"},{"uidset":[3214,652,145],"upstream":"beta2"}]},"2":{"divtype":"iprange","divdata":[{"range":{"start":1111,"end":2222},"upstream":"beta1"},{"range":{"start":3333,"end":4444},"upstream":"beta2"},{"range":{"start":7777,"end":8888},"upstream":"beta3"}]}}

# policygroup_del:                  1
# policygroup_get:                  1| 2| 3|4|5|6|7

# policygroup_set: {"1": {"divtype": "uidappoint","divdata": [{"uidset":[1234,5678], "upstream":"beta1"},{"uidset":[11,22,33], "upstream":"beta2"}] }}
# policygroup_set: {"1": {"divtype": "uidappoint","divdata": [{"uidset":[1234,5678], "upstream":"beta1"},{"uidset":[11,22,33], "upstream":"beta2"}] }}

#policygroup_get:                  1| 2| 3|4|5|6|7

# policygroup_set:    {"1":{"divtype":"version","divdata":[{"version":"1.0","upstream":"beta1"},{"version": "1.1","upstream":"beta2"}]}}
policygroup_list:

# runtime_del: api.weibo.cn

runtime_set: api.weibo.cn = 14
runtime_get: api.weibo.cn

# policygroup_del: 4|5|6


# runtime_del:                 api.weibo.cn
# runtime_del:                 api.weibo.cn

# runtime_del:                  api.weibo.cn = 2
# runtime_del:                 api.weibo.cn
