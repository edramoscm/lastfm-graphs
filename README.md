<p>I made this script because Spotify Wrapped is quite bad and doesn't really tell a story. I wanted to make something that could actually tell what my year was like, and didn't exclude December!<p>

<p>Not to mention that there are artists and albums that I listen to that are not available in their platform.</p>

<p>The results are four graphs, two describing your ten most heard artists and albums throughout the year (which you can change simply by changing 2022 to whatever you want), dividing in months, one describing your 100 most heard albums with regards to their ranking made in Plotly so that I could take a look at different artists in isolation, one describing how you listen to music throughout the day &#8212 if you don't pay for Last.fm's premium account you can see at what times you listen to music the most.</p>

<p>Anyway, now to the real thing.</p>

<p>You should get the CSV with all your Last.fm data first. It shouldn't be impossible to data scrape it, but I got mine from <a href="https://benjaminbenben.com/lastfm-to-csv/">Benjamin BenBen's</a> website. </p>

</p>You'll need the libraries data.table, ggplot2, plotly, lubridate and dplyr. Pay attention to the path to the CSV file, there are only two lines of code in which I commented, and the first one is for that.</p>

<p>The second one isn't too far off. In line 13, change the name of the CSV file to your username's, just like the file you download from BenBen's website.</p>

<p>You should pay attention to lines from 169 to 174. Depending on your timezone, you may have to change "[TIMEZONE]" to whatever your timezone actually is.</p>

<p>Get creative! Try to make a regression, for example! My plotly graph ended up close to a y=A/x^0.5 + B, what about yours?</p>

The graphs should look like this:

![image](https://github.com/edramoscm/lastfm-graphs/assets/67239361/5846fb31-c8bf-48cf-9ea4-b8016c6107db)

![image](https://github.com/edramoscm/lastfm-graphs/assets/67239361/dd09cc6f-18e7-4ebe-8837-b56d5af8289d)

I'm thinking of making these a little better to the eye, but at least you can see clearly each variable and, to be fair, I much prefer to see the raw data.

![image](https://github.com/edramoscm/lastfm-graphs/assets/67239361/f478a193-f52d-48ec-986b-1cd2be97f719)
