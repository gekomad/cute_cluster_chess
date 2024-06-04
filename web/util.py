import json
import os.path
import re
import subprocess
from datetime import datetime
from subprocess import Popen
from subprocess import check_output
import os

import constants
from constants import test_folder, home_dir, cute_main_param_bean


def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)


def get_test_date(branch):
    try:
        repo_name = cute_main_param_bean.get_repo_name()
        path_exe = cute_main_param_bean.path_exe
        milliseconds = os.path.getmtime(f"{test_folder}/{branch}/{repo_name}/{path_exe}")
        dt = datetime.fromtimestamp(milliseconds)
        return f"{dt.year}-{dt.month:02}-{dt.day:02}"
    except IOError:
        return "?????"


def get_date_time(f):
    try:
        milliseconds = os.path.getmtime(f)
        dt = datetime.fromtimestamp(milliseconds)
        return f"{dt.year}-{dt.month:02}-{dt.day:02} {dt.hour:02}:{dt.minute:02}:{dt.second:02}"
    except IOError:
        return "?????"


def get_ips():
    out = check_output(["hostname", "-I"])
    a = str(out, 'utf-8')
    return a.strip()


def clone_node(ip_port, user, cpus):
    a = ip_port.split(":")
    ip = a[0]
    port = 22
    try:
        port = a[1]
    except:
        pass
    print(f"call {home_dir}/remote/clone_node.sh {ip} {user} {port} {cpus}")
    out = check_output([home_dir + "/remote/clone_node.sh", ip, user, port, cpus])
    a = str(out, 'utf-8')

    return a


def share_pub_key(user, ip_port, password):
    a = ip_port.split(":")
    ip = a[0]
    port = 22
    try:
        port = a[1]
    except:
        pass
    print(f"call {home_dir}/remote/share_pub_key.sh {user} {ip} {password} {port}")

    out = check_output([home_dir + "/remote/share_pub_key.sh", user, ip, password, port])
    a = str(out, 'utf-8')
    return a


def start_all_servers():
    print("start_all.sh")
    Popen([home_dir + "/remote/start_all.sh", ""], stdout=subprocess.PIPE, stdin=subprocess.PIPE,
          stderr=subprocess.PIPE).wait()


def stop_all_servers():
    print("stop_all.sh")
    Popen([home_dir + "/remote/stop_all.sh", ""], stdout=subprocess.PIPE, stdin=subprocess.PIPE,
          stderr=subprocess.PIPE).wait()


def restart_all_servers():
    print("restart_all.sh")
    Popen([home_dir + "/remote/restart_all.sh", ""], stdout=subprocess.PIPE, stdin=subprocess.PIPE,
          stderr=subprocess.PIPE).wait()


def get_ip():
    j = subprocess.run(["/bin/hostname", "-I"], capture_output=True).stdout
    a = str(j, 'utf-8')
    return a.strip()


def get_servers_statistic(reload):
    print("start get_servers_statistic")
    stat = constants.tmp_folder + "/cute_statistics"
    stat_fe = constants.tmp_folder + "/cute_statistics_fe"

    class Server:
        def __init__(self, id, ip, load_avarage, stopped, tot_match, test_name, max_cpu, command):
            self.ip = ip.strip()
            self.id = id.strip()
            self.load_avarage = load_avarage
            self.stopped = stopped
            self.tot_match = tot_match
            self.test_name = test_name
            self.max_cpu = max_cpu
            self.command = command

    if not reload and os.path.isfile(stat_fe):
        r2 = open(stat_fe, "r").read()
        return r2
    Popen([home_dir + "/remote/get_statistics.sh", ""], stdout=subprocess.PIPE, stdin=subprocess.PIPE,
          stderr=subprocess.PIPE).wait()
    timestamp = get_date_time(stat)
    list = []

    my_ip = get_ip()

    with open(stat, "r") as f:
        for line in f:
            print("line: " + line)
            a = line.split("|")
            if a[1].strip() == my_ip:
                a[1] = a[1] + "*"
            aa = Server(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7])
            list.append(aa)
    # append to result
    r = json.dumps([ob.__dict__ for ob in list])

    r2 = '  {   "timestamp": "' + timestamp + '", "list": ' + r + ' }'
    with open(stat_fe, "w") as text_file:
        text_file.write(r2)
    print("end get_servers_statistic")
    return r2


# ##########################à

def is_init():
    if os.path.exists(home_dir + "/init_ok"):
        if len(constants.cute_main_param_bean.ips) == 0:
            return "OKK_no_nodes"
        return "OKK"
    return "KO"


def suspend_branch(branch):
    subprocess.run([home_dir + "/remote/suspend.sh", branch], capture_output=True)


def sync_nodes():
    print(f"call {home_dir}/remote/sync_nodes.sh")
    out = check_output([home_dir + "/remote/sync_nodes.sh"])
    a = str(out, 'utf-8')
    return a


def stop_server(id):
    address, port, user = constants.cute_main_param_bean.get_node_by_id(id)
    print(f"call {home_dir}/remote/kill.sh {address} {port} {user}")
    subprocess.run([home_dir + "/remote/kill.sh", address, port, user], capture_output=True)


def remove_server(id):
    address, port, user = constants.cute_main_param_bean.get_node_by_id(id)
    a = subprocess.run([home_dir + "/remote/remove_server.sh", address, port, user], capture_output=True)
    return a.returncode


def start_server(id):
    address, port, user = constants.cute_main_param_bean.get_node_by_id(id)
    subprocess.run([home_dir + "/remote/start.sh", address, port, user], capture_output=True)


def check_server(id):
    address, port, user = constants.cute_main_param_bean.get_node_by_id(id)
    a = subprocess.run([home_dir + "/util/check_server.sh", address, port, user], capture_output=True)
    return a.returncode


def failed_branch(branch):
    subprocess.run([home_dir + "/remote/failed_test.sh", branch], capture_output=True)


def get_opening_epd():
    print(f"call {home_dir}/remote/get_opening_epd.sh")
    out = check_output([home_dir + "/remote/get_opening_epd.sh"])
    a = str(out, 'utf-8')
    b = list(a.split(","))
    res = """{ "aaData": ["""
    for x in b:
        if len(x) > 0:
            res += ("  {   \"value\":\"" + x + "\" },")
    res = res[:-1]
    res += "]}"
    return res


def activate_branch(branch):
    subprocess.run([home_dir + "/remote/suspend_remove.sh", branch], capture_output=True)


def get_all_tests(reload, failed, suspended):
    if failed:
        cumulate = constants.tmp_folder + "/cumulate_failed"
        cumulate_fe = constants.tmp_folder + "/cumulate_failed_fe"
        arg = "failed"
    elif suspended:
        cumulate = constants.tmp_folder + "/cumulate_suspended"
        cumulate_fe = constants.tmp_folder + "/cumulate_suspended_fe"
        arg = "suspended"
    else:
        cumulate = constants.tmp_folder + "/cumulate"
        cumulate_fe = constants.tmp_folder + "/cumulate_fe"
        arg = ""

    class TestBean:
        def __init__(self, name, res, color, git_commit, has_error, git_comment, git_base, test_date, git_url):
            self.name = name
            self.res = res
            self.color = color
            self.git_commit = git_commit
            self.test_date = test_date
            self.has_error = has_error
            self.git_comment = git_comment
            self.git_base = git_base
            self.git_url = git_url

    def remove_double_space(s):
        while "  " in s:
            s = s.replace("  ", " ")
        return s.strip()

    def get_this_and_base_git_commit(branch):
        print(f"call {home_dir}/remote/get_last_git_commit.sh {branch}")
        j = subprocess.run([home_dir + "/remote/get_last_git_commit.sh", branch], capture_output=True).stdout
        a = str(j, 'utf-8')
        return a

    def name(x1):
        def get_error(x1):
            r1 = re.search(r".*ERROR:(.*):.*", x1)
            return r1.group(1)

        x = x1.split("----")
        result = re.search(r"(?s).*ratings(.*)los.*", x1)
        name = x[0].strip()[:20]
        score = result.group(1)
        _x = get_this_and_base_git_commit(name)
        print("get_this_and_base_git_commit: " + _x)
        git = _x.split("§")
        git_commit = git[0]
        git_comment = git[1].strip()
        git_base = git[2]
        git_url = git[3]
        test_date = get_test_date(name)
        has_error = get_error(x1)
        color = "yellow"
        for l in score.split('\n'):
            if name in l:
                v = remove_double_space(l).split(" ")
                if int(v[5]) < 1000:
                    color = "white"
                elif int(v[2]) >= 15:
                    color = "green"
                elif int(v[2]) < 0:
                    color = "red"
        return TestBean(name, score, color, git_commit, has_error, git_comment, git_base, test_date, git_url)

    if not reload and os.path.isfile(cumulate) and os.path.isfile(cumulate_fe):
        r2 = open(cumulate_fe, "r").read()
        return r2
    print(f"call {home_dir}/remote/b.sh {arg} and create {cumulate}")
    Popen([home_dir + "/remote/b.sh", arg], stdout=subprocess.PIPE, stdin=subprocess.PIPE,
          stderr=subprocess.PIPE).wait()
    try:
        a = open(cumulate, "r").read()
    except:
        return ''
    time = get_date_time(cumulate)
    b = a.split(" ----------- _test_/")
    c = filter(lambda x: (len(x) > 10), b)
    result = map(name, c)
    result = list(result)
    r = list(map(lambda ob: (ob.__dict__), result))
    j = subprocess.run([home_dir + "/remote/suspend_get.sh"], capture_output=True).stdout
    list_susp = list(filter(None, str(j, 'utf-8').split("\n")))
    s = json.dumps(list_susp)
    # j = subprocess.run([home_dir + "/remote/failed_get.sh"], capture_output=True).stdout
    # list_susp = list(filter(None, str(j, 'utf-8').split("\n")))
    # f = json.dumps(list_susp)
    # r2 = '  {"failed_list": ' + f + ',  "suspend_list": ' + s + ', "timestamp": "' + time + '", "list":   ' + json.dumps(r) + '}'
    r2 = ' {"suspend_list": ' + s + ', "timestamp": "' + time + '", "list":   ' + json.dumps(r) + '}'
    with open(cumulate_fe, "w") as text_file:
        text_file.write(r2)
    return r2
