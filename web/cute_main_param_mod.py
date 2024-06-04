import json
import re
from typing import List
from dataclasses import dataclass
import constants
from constants2 import home_dir
import os

cute_main_param_json = home_dir + "/cute_main_param.json"
cute_main_param_txt = home_dir + "/cute_main_param"


@dataclass
class CuteMainParam:
    ips: List[str]
    repo: str
    first: str
    first_param: str
    second_param: str
    first_ponder: str
    second_ponder: str
    opening_epd: str
    resign: str
    draw: str
    tc: str
    hash_size: int
    concurrency: int
    variant: str
    tot_match: int
    make_command_aarch64: str
    make_command_x86_64: str
    path_src: str
    path_exe: str

    def has(self, p):
        for x in self.ips:
            if p in x:
                return True
        return False

    def get_node_by_id(self, id):
        for x in self.ips:
            if id in x:
                a = x.split(":")
                return a[0], a[1], a[2]
        return "", "", ""

    def get_repo_name(self):
        repo = self.repo
        pattern = r"^git@github.com(.+).git"
        result = re.search(pattern, repo)
        if result:
            return result.group(1)
        raise Exception("err repo name not found")

    def get_json(self):
        return json.dumps(
            self,
            default=lambda o: o.__dict__,
            sort_keys=True,
            indent=4)

    def save_cute_main_param(self):
        with open(cute_main_param_json, 'w') as f:
            json.dump(self.__dict__, f, indent=4)

        def write(outfile, vv, name):
            outfile.write(f'export {name}="{vv}"\n')

        with open(cute_main_param_txt, "w") as outfile:
            outfile.write(f"# DO NOT EDIT\n")
            outfile.write(f'export ips="')
            for x in self.ips:
                outfile.write(x + " ")
            outfile.write('"\n')

            write(outfile, self.repo, "repo")

            write(outfile, self.first_param, "first_param")
            write(outfile, self.second_param, "second_param")
            write(outfile, self.first_ponder, "first_ponder")
            write(outfile, self.second_ponder, "second_ponder")
            write(outfile, self.opening_epd, "opening_epd")
            write(outfile, self.resign, "resign")
            write(outfile, self.draw, "draw")
            write(outfile, self.tc, "tc")
            write(outfile, self.hash_size, "hash_size")
            write(outfile, self.concurrency, "concurrency")
            write(outfile, self.variant, "variant")

            write(outfile, self.tot_match, "tot_match")
            write(outfile, self.make_command_aarch64, "make_command_aarch64")
            write(outfile, self.make_command_x86_64, "make_command_x86_64")
            write(outfile, self.path_src, "path_src")
            write(outfile, self.path_exe, "path_exe")
            outfile.write("export id=$(cat /sys/class/net/*/address|sort|md5sum |cut -c1-6)\n")

    def remove_node(self, id):
        ips2: List[str] = []
        for x in self.ips:
            s = x.split(":")
            if id != s[3]:
                ips2.append(x)
        self.ips = ips2
        self.save_cute_main_param()
        if len(constants.cute_main_param_bean.ips) == 0:
            os.remove(home_dir + "/init_ok")

    def add_node(self, ip_port, user, id):
        self.ips.append(ip_port + ":" + user + ":" + id)
        self.save_cute_main_param()

    def __init__(self, ips: List[str], repo: str,
                 first_param: str, second_param: str, first_ponder: str, second_ponder: str, opening_epd: str,
                 resign: str, draw: str, tc: str, hash_size: str, concurrency: str, variant: str,
                 tot_match: str, make_command_aarch64: str, make_command_x86_64: str, path_src: str,
                 path_exe: str) -> None:
        self.ips = ips
        self.repo = repo
        self.first_param = first_param
        self.second_param = second_param
        self.first_ponder = first_ponder
        self.second_ponder = second_ponder
        self.opening_epd = opening_epd
        self.resign = resign
        self.draw = draw
        self.tc = tc
        self.hash_size = hash_size
        self.concurrency = concurrency
        self.variant = variant
        self.tot_match = tot_match
        self.make_command_aarch64 = make_command_aarch64
        self.make_command_x86_64 = make_command_x86_64
        self.path_src = path_src
        self.path_exe = path_exe


def read_cute_main_param():
    with open(cute_main_param_json, 'r') as openfile:
        json_object = json.load(openfile)
        c = CuteMainParam(**json_object)
        constants.cute_main_param_bean = c
        return c
