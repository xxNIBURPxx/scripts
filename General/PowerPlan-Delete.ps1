#List Power plans
powercfg.exe /L

#Change/Set active plan
powercfg -setactive GUID

#Delete power plan
powercfg -delete GUID