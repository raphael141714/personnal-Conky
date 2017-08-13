# personnal-Conky
Personnal conky config, inspired by the Numix theme.
Sorry, I'm french, therefore my conky is in french :)

## Installing it

You will need theses fonts :   
Content : [Standard Roboto](https://fonts.google.com/specimen/Roboto)   
Titles : [Roboto Slab](https://fonts.google.com/specimen/Roboto+Slab)   
Monospace font : [Roboto Mono](https://fonts.google.com/specimen/Roboto+Mono)   

Then install conky, obviously. (conky 1.10 works, don't know for 1.9)   
If you download this as an archive, simply unpack it in `~/`   
You should then have a `~/conky/` folder, and more importantly a `~/conky/graphs.lua` file.   
Once all that is done, rename `conkyrc`, `conkyrc_wlan0`, `conkyrc_headless` or `conkyrc_headless_wlan0` to `.conkyrc`.   
It depends on what you want :   
* `conkyrc` :    
![Image of my Conky](https://github.com/raphael141714/personnal-Conky/blob/master/screen.png)
* `conkyrc_wlan0` :   
![Image of my Conky](https://github.com/raphael141714/personnal-Conky/blob/master/screen_wlan0.png)
* `conkyrc_headless` or `conkyrc_headless_wlan0`, as the only thing changing is the NET arrows, monitoring `wlan0` or `eth0`:   
![Image of my Conky](https://github.com/raphael141714/personnal-Conky/blob/master/screen_headless.png)   

Then, just launch `conky` and voilà, it works.
