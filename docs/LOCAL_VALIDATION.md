# Local-first validation

Run checks locally before commits/pushes. Draft PR development does not allocate hosted validation runners. The same named hosted checks run when the PR is ready for review, for all target branches including the repository default and release branches. There are no push, manual, scheduled or release-event triggers; release/default-branch changes are validated through reviewed PRs. Required checks, rulesets and permissions are not changed by this setup.

## Install the repo-scoped hook

Using the existing `pre-commit` installation:

```sh
sh Scripts/install_local_hooks.sh
git hook run pre-commit
```

This sets this checkout's local `core.hooksPath` to `.githooks`; it changes no global Git configuration. The real pre-commit hook invokes the checked-in `.pre-commit-config.yaml` with local/system hooks only, so it downloads no hook environments. It checks staged Python/Ruby/shell syntax, whitespace, secret patterns and CI policy. Its cache and execution receipt live in ignored `.local-validation.noindex/`. Staged checks are fast; full tests belong in the local validation gate before push. Hooks are defense in depth, not proof that all secrets or private data were found.

## Portable checks with act

```sh
python3 Scripts/local_checks.py
python3 Scripts/run_local_act.py
python3 Scripts/ci_policy.py --act-matrix
```

The repo `.actrc` maps only the dedicated `local-posix` runner to act's native-host mode, with pulls disabled and actions offline. `run_local_act.py` selects a separate local-only workflow outside `.github/workflows`, supplying an explicitly synthetic draft PR event. Local jobs deliberately have no draft guard, so they execute during draft development. The workflow runs the same portable checks with existing installed tools; it never installs software, downloads images, checks out another branch or accesses app/cloud credentials.

This is actual act execution on the Mac host. It is not a Linux-container or full hosted-runner equivalence claim. Native Apple validation is a separate gate. Running the hosted Ubuntu job locally requires a reviewed compatible cached image/tool setup; do not download an image or install extra software implicitly. Do not map a hosted setup/install job blindly onto this Mac.

The event policy test evaluates the exact hosted guard through act using harmless marker steps. It evaluates draft opened/synchronize/reopened, non-draft opened/synchronize, ready_for_review and default/release target branches through act. Unsupported push/manual events are checked against the actual hosted declaration; their act planners are not invoked. It downloads no actions/images and runs no application tests.

## Hosted handoff

Before a push inspect the actual workflow triggers and guard, validate the exact local changes and preserve check names. Use one final push after local checks, not intermediate pushes. A draft update may create GitHub workflow/check bookkeeping, but the guarded validation job is skipped without allocating its runner. When the PR is marked ready, `ready_for_review` runs the full named hosted gate; later non-draft updates also validate.

Do not weaken required checks or branch protections, cancel existing jobs, trigger manual reruns, or use commit-skip directives blindly: they can leave required checks pending. No GitLab repository or pipeline is changed by this GitHub-specific setup.

## Tap native gate

The portable act gate checks Ruby syntax and repository policy. Before an installable cask or release metadata is delivered, run the repository's full Homebrew style/readall/audit gate in an isolated tap checkout with the already approved tool/credential context. These packaging-preparation checks do not install or download private app artifacts. A local portable pass is not a full Linux/Homebrew test-bot claim.
