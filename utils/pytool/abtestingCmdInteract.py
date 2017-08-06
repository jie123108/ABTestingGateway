import cmd
import sys
import json
import argparse

class colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
        
def warning(fn):
    def wrapped():
        print(colors.WARNING)
        fn()
        print(colors.ENDC)
    return wrapped

CMDS = ["host", "policygroup", "runtime", "policy", "help"]

@warning
def help_help():
    print("syntax: help cmd -- show help for command `cmd`")
    print("help " + "|".join(CMDS))
    # print("")

@warning
def help_host():
    print("syntax: host -- show current host")
    print("syntax: host 127.0.0.1:8080 -- set a new host")
    # print("")

@warning
def help_policygroup():
    print("syntax: policygroup -- show policygroup help")
    print("syntax: policygroup list -- show all policygroup")
    print("syntax: policygroup set \"json format policygroup info\" -- add a policygroup")
    print("syntax: policygroup get pgid1|pgid1|pgid3 -- show policygroup info")
    print("syntax: policygroup del pgid1|pgid1|pgid3 -- delete policygroup")
    # print("")

@warning
def help_runtime():
    print("syntax: runtime -- show runtime help")
    print("syntax: runtime set hostkey = pgid -- Set a hostkey's runtime policygroup id")
    print("syntax: runtime get hostkey -- Get a hostkey's runtime policygroup")
    print("syntax: runtime del hostkey -- Delete a hostkey's runtime policygroup")
    # print("")

help_map = {
    "": help_help,
    "help": help_help,
    "host": help_host,
    "pg": help_policygroup,
    "policygroup": help_policygroup,
    "rt": help_runtime,
    "runtime": help_runtime,
}


class AbTestingCmd(cmd.Cmd):
    """AB Testing command processor."""
    def __init__(self, host):
        cmd.Cmd.__init__(self)
        self.host = host
        self.prompt = "AbTesting: "    # define command prompt
    
    def show_result(self, cmdname, resp):
        print '-----------------result-----------------'
        if cmdname == "policygroup_list":
            for k in resp:
                resp[k] = "{...}"
        print colors.GREEN + json.dumps(resp, indent = 1) + colors.ENDC

    def run_cmd(self, cmdname, cmdfull, args):
        cmdmod  = __import__('command')
        cmdclass = getattr(cmdmod, cmdname)
        cmdobj = cmdclass(self.host, args)
        valid, err = cmdobj.check()
        if not valid:
            hint = 'cmd [' + cmdfull + '] invalid.'
            if err:
                hint += ' : reason is ' + err
            print colors.FAIL + "ERR: " + hint + colors.ENDC
            return None

        resp = cmdobj.run()
        self.show_result(cmdname, resp)

    def do_host(self, host):
        if host: # set host
            self.host = host
            print("set host to: " + self.host)
        else:
            print("current host: " + self.host)

    def subcmd_parse(self, args):
        arr = args.split(" ", 1)
        subcmd = arr[0]
        subcmd_args = None 
        if len(arr) > 1:
            subcmd_args = arr[1]
        return subcmd, subcmd_args

    def do_policygroup(self, args):
        if args == "":
            help_policygroup()
        else:
            subcmds = {
                "list": "policygroup_list",
                "set": "policygroup_set",
                "get": "policygroup_get",
                "del": "policygroup_del",
            }
            subcmd, subcmd_args = self.subcmd_parse(args)
            abcmdname = subcmds.get(subcmd)
            if not abcmdname:
                print("unknow subcmd [" + subcmd + "]")
                return
            cmdfull = "policygroup " + subcmd
            self.run_cmd(abcmdname, cmdfull, subcmd_args)
            

    def do_pg(self, args):
        return self.do_policygroup(args)
 
    def do_runtime(self, args):
        if args == "":
            help_runtime()
        else:
            subcmds = {
                "set": "runtime_set",
                "get": "runtime_get",
                "del": "runtime_del",
            }
            subcmd, subcmd_args = self.subcmd_parse(args)
            abcmdname = subcmds.get(subcmd)
            if not abcmdname:
                print("unknow subcmd [" + subcmd + "]")
                return
            cmdfull = "runtime " + subcmd
            self.run_cmd(abcmdname, cmdfull, subcmd_args)
            

    def do_rt(self, args):
        return self.do_runtime(args)

    def do_help(self, cmd):
        func = help_map.get(cmd)
        if func:
            func()
        else:
            print(colors.FAIL + "unknow command '" + cmd + "'" + colors.ENDC)

    def default(self, line):
        print(colors.FAIL + "unknow command" + colors.ENDC)

    def do_exit(self, line):
        return True
    def do_EOF(self, line):
        return True

if __name__ == '__main__':
    host = "127.0.0.1:8080"
    parser = argparse.ArgumentParser(description='dygateway cmd utility')
    parser.add_argument('--host', action="store", dest="host")
    result = parser.parse_args(sys.argv[1:])

    if result.host:
        host = result.host

    AbTestingCmd(host).cmdloop()