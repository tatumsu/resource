from __future__ import with_statement
from fabric.api import *
from fabric.contrib.console import confirm

env.skip_bad_hosts=True
env.user = "vagrant"
env.password='vagrant'
#env.hosts = ['']
#env.passwords={'tatum@192.168.0.107:22': 'abc123_', 'vagrant@localhost:22': 'vagrant'}
git_folder = "/home/vagrant/github/resource"

def run_cmd(cmd):
	run(cmd)


def git_checkout():
	with cd(git_folder):
		run("checkout -- .")

def git_pull():
	with cd(git_folder):
		run("git pull")

def git_checkout_pull():
	with cd(git_folder):
		run("git checkout -- . && git pull")

def get_host_spec():
  get_cpu()
  get_memory()
  get_disk()
 
def get_cpu():
  print("Executing on %(host)s as %(user)s" % env)
  with hide('stderr','running'):
    run("echo $(lscpu | grep 'CPU(s):')")
  # print env.passwords 

def get_memory():
  with hide('stderr','running'):
    run("echo $(free -m | grep Mem: | tr -s ' ' | cut -d ' ' -f2 | xargs echo 'Total Memory: ')")
 
def get_disk():
  with hide('stderr','running'):
    run("df -h")
 
def handle_error():
  with settings(warn_only=True):
    result = run("ls /tmp/notexist")
  if result.failed and not confirm("Command failed. Continue anyway?"):
    abort("Aborting at user request.")
  # The shell is an empty shell
  with cd('/vagrant'):
    run('env && alias')
    run('type ls')

@hosts('localhost')
def run_local():
  run('whoami')
  print env.connection_attempts
