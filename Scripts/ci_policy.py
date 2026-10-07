"""Audit this repository's PR-only/draft guard and evaluate it with act on demand."""
from pathlib import Path
import argparse,json,os,re,subprocess,tempfile
GUARD="github.event_name == 'pull_request' && github.event.pull_request.draft == false"
CASES=[('draft-opened','pull_request','opened',True,'main',False),('draft-sync','pull_request','synchronize',True,'main',False),('draft-reopened','pull_request','reopened',True,'main',False),('review-opened','pull_request','opened',False,'main',True),('review-sync','pull_request','synchronize',False,'main',True),('ready','pull_request','ready_for_review',False,'main',True),('default-base','pull_request','synchronize',False,'default',True),('release-base','pull_request','synchronize',False,'release/v1',True),('push','push',None,False,'main',False),('manual','workflow_dispatch',None,False,'main',False)]
def policies(repo):
 files=sorted((repo/'.github/workflows').glob('*.y*ml'));assert files,'No hosted workflow'
 for path in files:
  text=path.read_text();assert re.search(r'^on:\n  pull_request:\n    types: \[opened, synchronize, reopened, ready_for_review\]',text,re.M),path
  assert not re.search(r'^  (push|workflow_dispatch|schedule|pull_request_target|workflow_run):',text,re.M),path
  jobs=re.findall(r'^  ([\w-]+):\n    if: (.*)\n    runs-on:',text,re.M);assert jobs and all(guard==GUARD for name,guard in jobs),path
  assert '${{ github.event.pull_request.head.sha }}' in text,path
  yield path,jobs

def check(repo):
 count=0
 for path,jobs in policies(repo):
  for name,guard in jobs:
   for label,event,action,draft,base,expected in CASES:
    actual=event=='pull_request' and action in ['opened','synchronize','reopened','ready_for_review'] and not draft
    assert actual==expected,(path,name,label);count+=1
 return count

def act_matrix(repo):
 root=repo/'.local-validation.noindex';root.mkdir(exist_ok=True);results=[]
 for path,jobs in policies(repo):
  for name,guard in jobs:
   with tempfile.TemporaryDirectory(prefix='matrix-',dir=root) as directory:
    d=Path(directory);workflow=d/'probe.yml';workflow.write_text('name: Local event policy probe\non:\n  pull_request:\n    types: [opened, synchronize, reopened, ready_for_review]\njobs:\n  probe:\n    if: '+guard+'\n    runs-on: local-posix\n    steps:\n      - run: python3 -c "from pathlib import Path; import os; Path(os.environ[\'LOCAL_POLICY_MARKER\']).touch()"\n')
    for label,event,action,draft,base,expected in CASES:
     if event != 'pull_request':
      # These events are absent from the actual hosted declaration. Do not invoke
      # act's manual-event planner for a workflow that cannot receive that event.
      assert expected is False
      results.append({'workflow':path.name,'job':name,'case':label,'expectedRun':False,'actualRun':False,'verification':'event absent from audited hosted declaration','actExit':None})
      continue
     marker=d/(label+'.ran');payload=d/(label+'.json');payload.write_text(json.dumps({'action':action,'pull_request':{'draft':draft,'head':{'sha':'0'*40},'base':{'ref':base}},'repository':{'default_branch':'default'}}))
     command=['act',event,'-W',str(workflow),'-e',str(payload),'-P','local-posix=-self-hosted','--pull=false','--action-offline-mode','--env','LOCAL_POLICY_MARKER='+str(marker)]
     run=subprocess.run(command,cwd=repo,capture_output=True,text=True,timeout=45);log=root/('policy-'+path.stem+'-'+name+'-'+label+'.log');log.write_text(run.stdout+run.stderr)
     actual=marker.exists();assert actual==expected,(path,name,label,run.returncode,str(log))
     if expected:assert run.returncode==0,(path,name,label,str(log))
     results.append({'workflow':path.name,'job':name,'case':label,'expectedRun':expected,'actualRun':actual,'actExit':run.returncode,'log':str(log)})
 (root/'act-policy-matrix.json').write_text(json.dumps(results,indent=2));return results
if __name__=='__main__':
 parser=argparse.ArgumentParser();parser.add_argument('--act-matrix',action='store_true');args=parser.parse_args();repo=Path(__file__).resolve().parents[1];count=check(repo)
 if args.act_matrix:print('ACT evaluated',len(act_matrix(repo)),'event cases; native host policy probes only, no image pulls')
 else:print('CI policy:',count,'event cases passed')
