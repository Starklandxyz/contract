```
   _____ _             _       _                     _ 
  / ____| |           | |     | |                   | |
 | (___ | |_ __ _ _ __| | __  | |     __ _ _ __   __| |
  \___ \| __/ _` | '__| |/ /  | |    / _` | '_ \ / _` |
  ____) | || (_| | |  |   <   | |___| (_| | | | | (_| |
 |_____/ \__\__,_|_|  |_|\_\  |______\__,_|_| |_|\__,_|
```

**v 0.1.0**
Build contract framework (components systems events utils)  
Initial map 50x50  
Set properties of the land  
Add random mod for utils  


## DEV

go contracts folder

1. terminal_1
`katana --disable-fee`
2. terminal_2, comment world_address
`sozo build && sozo migrate --name test`
3. terminal_3 uncomment world_address
`touch indexer.db`
`torii -d indexer.db`