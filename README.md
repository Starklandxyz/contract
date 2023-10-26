```
   _____ _             _       _                     _ 
  / ____| |           | |     | |                   | |
 | (___ | |_ __ _ _ __| | __  | |     __ _ _ __   __| |
  \___ \| __/ _` | '__| |/ /  | |    / _` | '_ \ / _` |
  ____) | || (_| | |  |   <   | |___| (_| | | | | (_| |
 |_____/ \__\__,_|_|  |_|\_\  |______\__,_|_| |_|\__,_|
```
## Intro🧙  

Welcome to **StarkLand** ! This is the **First** Full On-chain Multiplayer Online Simulation Game (**FOMOSLG**) built with **Dojo** engine on Starknet !  

In this full on-chain world, hundreds of Starknet users will compete for glory and territories. Here, you can create your own empire, build magnificent cities, cultivate bountiful farmlands, mine endless resources, train powerful warriors, explore challenging dungeons for unknown treasures, and engage in fierce battles with other StarkLand players!  

To experience all of this, you just need to:  

1. Log in to https://app.starkland.xyz and create your wallet with a catchy nickname, and embark on a great journey.  

2. Choose your desired area on the vast map to establish your base. Note that building your base near gold and iron mines may accelerate the development of your empire.  

3. Move forward bravely, dispatch warriors to conquer the lands of nearby tribes. Establish farms, gold mines, iron mines, and camps on the lands to enhance your economic and military power, and become a true ruler of the empire.  

4. Recruit more soldiers, accumulate more resources, and launch attacks on your neighboring countries, that is, other StarkLand players, to expand your territory! Compete with Starknet players from all over the world, conquer the entire StarkLand!  

Moreover, we have prepared a rich task system for you. By completing tasks, you can receive generous resource airdrops, helping you gain an advantage on the battlefield and paving the way for the glorious development of your kingdom.  

StarkLand awaits your arrival, becoming a legendary ruler, engraving your name on the leaderboard, and writing your epic war history! Join us now and experience this Full On-chain Game that transcends reality and virtuality!  



## DEV 🛠

go contracts folder

1. terminal_1
`katana --disable-fee`
2. terminal_2, comment world_address
`sozo build && sozo migrate --name test`
3. terminal_3 uncomment world_address
`touch indexer.db`
`torii -d indexer.db`