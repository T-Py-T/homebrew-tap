"""Fast, repo-local staged checks; --full adds portable synthetic tests."""
from pathlib import Path
import argparse,ast,datetime,hashlib,json,re,subprocess
import ci_policy
repo=Path(__file__).resolve().parents[1]
def git(*args):return subprocess.check_output(['git',*args],cwd=repo)
def run(args):subprocess.run(args,cwd=repo,check=True)
def checks(staged):
 run(['git','diff',*(['--cached'] if staged else []),'--check'])
 names=(git('diff','--cached','--name-only','--diff-filter=ACMR','-z') if staged else git('ls-files','--cached','--others','--exclude-standard','-z')).decode().split('\0');checked=0
 for name in sorted(set(names)-{''}):
  data=git('show',':'+name) if staged else (repo/name).read_bytes()
  if b'\0' in data:continue
  text=data.decode('utf8',errors='replace')
  assert not re.search(r'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|\bgh[pousr]_[A-Za-z0-9]{20,}|\bAKIA[A-Z0-9]{16}\b',text),'Secret pattern in '+name
  assert not name.endswith(('.store','.store-wal','.store-shm','.p12','.p8','.mobileprovision','.provisionprofile')),name
  if name.endswith('.py'):ast.parse(text,filename=name)
  elif name.endswith(('.rb','.tmpl','.rb.in')):
   p=subprocess.run(['ruby','-c'],input=data,capture_output=True);assert p.returncode==0,p.stderr.decode()
  elif name.endswith('.sh') or name=='.githooks/pre-commit':
   p=subprocess.run(['bash','-n'],input=data,capture_output=True);assert p.returncode==0,p.stderr.decode()
  checked+=1
 count=ci_policy.check(repo);root=repo/'.local-validation.noindex';root.mkdir(exist_ok=True)
 result={'atUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'staged':staged,'textFilesChecked':checked,'policyCases':count,'stagedDiffSHA256':hashlib.sha256(git('diff','--cached','--binary')).hexdigest()}
 (root/('hook-last-run.json' if staged else 'fast-checks.json')).write_text(json.dumps(result,indent=2));print('Local syntax/whitespace/secret-pattern gate passed:',checked,'text files;',count,'policy cases')
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--staged',action='store_true');p.add_argument('--full',action='store_true');a=p.parse_args();checks(a.staged)
 if a.full and (repo/'Rust/Cargo.toml').exists():
  cargo=['cargo','test','--offline','--locked','--manifest-path',str(repo/'Rust/Cargo.toml')];vendor=repo/'Rust/vendor'
  if vendor.is_dir():cargo+=['--config','source.crates-io.replace-with="local-cache"','--config','source.local-cache.directory="'+str(vendor)+'"']
  run(cargo);run(['python3','-m','unittest','discover','-s','Tests','-p','test_sync_status_gate.py'])
 elif a.full:
  run(['ruby','-c','Templates/focus-owned.rb.tmpl']);run(['ruby','-c','Casks/mac-ogcs.rb'])
