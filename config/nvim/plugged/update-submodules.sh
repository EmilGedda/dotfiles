find . -maxdepth 1 -type d | xargs -P4 -n1 -Ifoo bash -c "cd foo; echo Updating $(basename foo); git pull --recurse-submodules &>/dev/null; echo Updated $(basename foo)"
