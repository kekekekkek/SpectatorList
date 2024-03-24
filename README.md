# Simple Spectator List
This plugin displays in the upper right corner the names of all the players who are spectating you at the moment. The server simply forces each player to send information to the array about who this player is currently spectating.<br>
Perhaps there is another way to get information about the observers, but so far I do not know how it can be done in another way.

# Installation
Installing the plugin consists of several steps:
1. [Download](https://github.com/kekekekkek/SpectatorList/archive/refs/heads/main.zip) this plugin;
2. Go to the directory `..\Sven Co-op\svencoop\scripts\plugins` and place the `Spectators.as` plugin here;
3. Next, go to the `..\Sven Co-op\svencoop` folder and find there the text file `default_plugins.txt`;
4. Open this file and paste the following text into it:
```
    	"plugin"
    	{
        	"name" "Spectators"
        	"script" "Spectators"
    	}
```
5. After completing the previous steps, you can run the game and check the result.

# Commands
When you start the game and connect to your server, you will have the following plugin commands at your disposal, which you will have to write in the game chat to activate them.
| Command | MinValue | MaxValue | DefValue | Description | Usage | 
| ------- | -------- | -------- | -------- | ----------- | ----- |
| `.sl`, `/sl` or `!sl` | `0` | `1` | `1` |  Allows you to enable or disable this feature. (`AdminsOnly`) | Usage: `.sl or /sl or !sl <enabled>.` Example: `!sl 1` |
| `.sl_ao`, `/sl_ao` or `!sl_ao` | `0` | `1` | `0` | Allows you to enable this feature only for admins or for all players. (`AdminsOnly`)<br>`0 - For everyone;`<br>`1 - Admins only.` | Usage: `.sl_ao or /sl_ao or !sl_ao <adminsonly>.` Example: `!sl_ao 0` |

**REMEMBER**: This plugin has problems and may crash sometimes.<br>
**REMEMBER**: The plugin may conflict with other plugins.<br>
**REMEMBER**: Observers are displayed only for a live player.<br>
**REMEMBER**: It may also be worth using another function instead of `HudMessage` to display a list with observers.<br>

# Screenshots
* Screenshot 1<br><br>
![Screenshot_1](https://github.com/kekekekkek/SpectatorList/blob/main/Images/Screenshot_1.png)
* Screenshot 2<br><br>
![Screenshot_2](https://github.com/kekekekkek/SpectatorList/blob/main/Images/Screenshot_2.png)
* Screenshot 3<br><br>
![Screenshot_3](https://github.com/kekekekkek/SpectatorList/blob/main/Images/Screenshot_3.png)
* Screenshot 4<br><br>
![Screenshot_4](https://github.com/kekekekkek/SpectatorList/blob/main/Images/Screenshot_4.png)
