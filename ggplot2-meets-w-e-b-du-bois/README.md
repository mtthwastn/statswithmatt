Code to reproduce the images from [ggplot2 meets W. E. B. Du Bois](https://statswithmatt.com/post/ggplot2-meets-w-e-b-du-bois/). The
original images can be seen at the Library of Congress, and my corresponding
scrips are named accordingly:

1. [Proportion of freemen and slaves among American Negroes.](https://hdl.loc.gov/loc.pnp/ppmsca.33913)
2. [Occupations of Negroes and whites in Georgia.](https://hdl.loc.gov/loc.pnp/ppmsca.08993)
3. [City and rural population among American Negroes in the former slave states.](https://hdl.loc.gov/loc.pnp/ppmsca.33914)
4. [Conjugal condition of American Negroes according to age periods.](https://hdl.loc.gov/loc.pnp/ppmsca.33915)

The remaining charts and other materials from the 1900 Paris Exposition are
available [here](https://www.loc.gov/pictures/search/?st=grid&co=anedub).

I used the Inconsolata font for all text in my plots. R will probably yell at
you and/or do something weird if you run my code and don't have it, so you can
either freely download Inconsolata [here](https://fonts.google.com/specimen/Inconsolata),
or choose a different font, or omit my choice of `font_name` altogether
wherever it's specified.