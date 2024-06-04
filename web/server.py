#!/usr/bin/env python3

import http.server
import base64
import json
import os
import subprocess

import constants
from constants2 import home_dir
from cute_main_param_mod import CuteMainParam, read_cute_main_param
from util import get_servers_statistic, start_all_servers, stop_all_servers, stop_server, \
    start_server, share_pub_key, clone_node, cute_main_param_bean, sync_nodes, is_init, touch, remove_server, \
    get_opening_epd, get_ips
from util import get_all_tests
from util import suspend_branch
from util import activate_branch
from util import failed_branch
from util import restart_all_servers


class CustomServerHandler(http.server.BaseHTTPRequestHandler):

    def do_AUTHHEAD(self):
        self.send_response(401)
        self.send_header(
            'WWW-Authenticate', 'Basic realm="Demo Realm"')
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

    def do_HEAD(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/text')
        self.end_headers()

    def do_GET(self):
        if self.headers.get('Authorization') != 'Basic ' + str(self.server.get_auth_key()):
            self.do_AUTHHEAD()
            response = {
                'success': False,
                'error': 'Invalid credentials'
            }
            self.wfile.write(bytes(json.dumps(response), 'utf-8'))
        else:
            try:
                self.send_response(200)
                page = self.path.rsplit('?', 1)[0]

                if page == "/":
                    page = "./index.html"
                if page.startswith("/download_pgn"):
                    a = page.split('/')
                    name = a[2]
                    self.send_header('Content-type', 'application/gzip')
                    pgn_file = home_dir + "/tmp/pgn/" + name + ".pgn.gz"
                    print("download " + pgn_file)
                    f = open(pgn_file, 'rb')

                    self.end_headers()
                    self.wfile.write(f.read())
                    f.close()
                    return
                if page.endswith(".html"):
                    self.send_header('Content-type', 'text/html')
                elif page.endswith(".css"):
                    self.send_header('Content-type', 'text/css')

                f = open("./" + page, 'rb')

                self.end_headers()
                self.wfile.write(f.read())
                f.close()
                return

            except IOError:
                self.send_error(404, 'File Not Found: %s' % self.path)

    def do_PUT(self):
        if self.headers.get('Authorization') != 'Basic ' + str(self.server.get_auth_key()):
            self.do_AUTHHEAD()
            response = {
                'success': False,
                'error': 'Invalid credentials'
            }
            self.wfile.write(bytes(json.dumps(response), 'utf-8'))
        else:
            length = int(self.headers.get('content-length'))
            message = json.loads(self.rfile.read(length))
            operation = message['operation']
            print("operation: " + operation)
            if operation == "get_all_server":
                res = get_servers_statistic(False)
            elif operation == "refresh_all_server":
                res = get_servers_statistic(True)
            elif operation == "restart_all_servers":
                res = restart_all_servers()
            elif operation == "start_all_servers":
                res = start_all_servers()
            elif operation == "stop_all_servers":
                res = stop_all_servers()
            elif operation == "get_all_tests":
                res = get_all_tests(False, False, False)
            elif operation == "get_all_failed":
                res = get_all_tests(False, True, False)
            elif operation == "refresh_all_failed":
                res = get_all_tests(True, True, False)
            elif operation == "get_all_suspended":
                res = get_all_tests(False, False, True)
            elif operation == "refresh_all_suspended":
                res = get_all_tests(True, False, True)
            elif operation == "refresh_all_tests":
                res = get_all_tests(True, False, False)
            elif operation == "is_init":
                res = is_init()
            elif operation == "suspend_branch":
                res = suspend_branch(message['branch'])
            elif operation == "activate_branch":
                res = activate_branch(message['branch'])
            elif operation == "get_opening_epd":
                res = get_opening_epd()
            elif operation == "failed_branch":
                res = failed_branch(message['branch'])
            elif operation == "stop_server":
                res = stop_server(message['id'])
            elif operation == "remove_server":
                if remove_server(message['id']) == 0:
                    constants.cute_main_param_bean.remove_node(message['id'])
                    res = "OKK"
                else:
                    res = "KO"
            elif operation == "start_server":
                res = start_server(message['id'])
            elif operation == "update_cute_main_param":
                def verify(cute_main_param_bean):
                    out = subprocess.run([home_dir + "/remote/verify_params.sh", cute_main_param_bean.repo],
                                         capture_output=True)
                    if out.returncode == 2:
                        return "Invalid URL must start with https"
                    elif out.returncode == 1:
                        return "'base' branch doesn't exist. Create it on github."
                    return "OKK"

                def cute_main_param_apply(ips, json_object):
                    c = CuteMainParam(**json_object)
                    c.ips = ips
                    v = verify(c)
                    if not "OKK" in v:
                        return v
                    constants.cute_main_param_bean = c
                    constants.cute_main_param_bean.save_cute_main_param()
                    return "OKK"

                params = message['params']
                res = cute_main_param_apply(constants.cute_main_param_bean.ips, params)
                if res == "OKK":
                    sync_nodes()
                    touch(home_dir + "/init_ok")

            elif operation == "load_cute_main_param":
                res = read_cute_main_param().get_json()
            elif operation == "share_pub_key":
                user = message['user'].strip().lower()
                ip_port = message['ip_port'].strip().lower()
                if ":" not in ip_port:
                    ip_port = ip_port + ":22"
                if constants.cute_main_param_bean.has(ip_port + ":" + user):
                    res = ip_port + " exists"
                else:
                    res = share_pub_key(user, ip_port, message['password'])
                    if "OKK" in res:
                        print("share_pub_key ok")
                        res = clone_node(ip_port, user, message['cpus'])  # includes add_crontab
                        if "OKK" in res:
                            id = res.strip().split("|")[1]
                            constants.cute_main_param_bean.add_node(ip_port, user, id)
                            res = "0"
                    else:
                        print("share_pub_key ko")
            self._set_headers()
            print(res)
            self.wfile.write(json.dumps(res).encode())


class CustomHTTPServer(http.server.HTTPServer):
    key = ''

    def __init__(self, address, handlerClass=CustomServerHandler):
        super().__init__(address, handlerClass)

    def set_auth(self, username, password):
        self.key = base64.b64encode(
            bytes('%s:%s' % (username, password), 'utf-8')).decode('ascii')

    def get_auth_key(self):
        return self.key


if __name__ == '__main__':
    def error():
        print("Error. Please install sshpass")
        exit(0)


    try:
        if subprocess.run(["sshpass", "-V"], stdout=subprocess.DEVNULL,
                          stderr=subprocess.DEVNULL, ).returncode != 0:
            error()
    except Exception as e:
        print(e)
    if not os.path.exists(home_dir + "/tmp"):
        os.mkdir(home_dir + "/tmp")
    port = 8395
    user = "b14168a9"
    pas = "b14168a9"
    ips = get_ips()
    print(f"\nopen http://{ips}:{port} user: {user} pass: {pas}\n")
    server = CustomHTTPServer(('0.0.0.0', port))
    server.set_auth(user, pas)
    server.serve_forever()
