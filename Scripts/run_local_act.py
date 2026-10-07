"""Run only portable local steps with installed act, using the native host; no images/actions downloaded."""
from pathlib import Path
import json,subprocess
repo=Path(__file__).resolve().parents[1];root=repo/'.local-validation.noindex';root.mkdir(exist_ok=True)
event=root/'local-act-event.json';event.write_text(json.dumps({'action':'synchronize','pull_request':{'draft':True,'head':{'sha':subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo,text=True).strip()}}}))
subprocess.run(['act','pull_request','-W','Scripts/act/local-validation.yml','-e',str(event),'-P','local-posix=-self-hosted','--pull=false','--action-offline-mode','--env','LOCAL_REPO_PATH='+str(repo)],cwd=repo,check=True)
print('ACT portable native-host workflow passed; this does not prove Linux-container or Xcode execution')
