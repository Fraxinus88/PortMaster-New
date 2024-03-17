## Notes
<br/>

Thanks to [Daniel Knobe, Jonathan Sieber, Sven Rech, Erik Schultheis, Silvio Mummert, New beach image and other contributors](https://github.com/danielknobe/blobbyvolley2) for creating this game and making available for free.  Also thanks to [Cebion and romadu](https://github.com/romadu/blobbyvolley2) for the porting work for portmaster.
<br/>

## Compile

```bash
git clone https://github.com/danielknobe/blobbyvolley2.git
edit src/main.cpp and remove joystick init from sdl_init.
mkdir build && cd build
cmake ..
make -j8
```