# Munsell inversion data
This repository provides fundamental datas for conversion from some color spaces (e.g. RGB) to Munsell color system. Every conversion is based on a color library [dufy](https://github.com/privet-kitty/dufy).

## RGB-to-Munsell binary data
- sRGB: [mid-srgb-d65.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/mid-srgb-d65.dat)
- sRGB (D50): [mid-srgb-d50.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/mid-srgb-d50.dat)

### Structure
Each of these files is 256 * 256 * 256 * 32 bit (&#8786; 64MB) binary data, which is a table of  conversion from hex (#000000 to #FFFFFF) to Munsell color.  Each cell gives a corresponding Munsell color in hue-value-chroma format in big-endian byte-order:

| 1-bit | 1-bit | 10-bit | 10-bit | 10-bit |
| :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | 0000000000 | 0000000000 | 0000000000 |
| F | - | H | V | C |

#### F: flag of large interpolation error: 

This flag means that the transformation error is large:

![Interpolation Error in the case of sRGB(D65)](https://g.gravizo.com/source/error_diagram?https%3A%2F%2Fraw.githubusercontent.com%2Fprivet-kitty%2Fmunsell-inversion-data%2Fmaster%2FREADME.MD)
<details> 
<summary></summary>
error_diagram
digraph G {
   graph [
      labelloc = "t",
      label = "Transformation Error in the case of sRGB(D65)",
      fontsize = 16
   ];
   node [shape = "box", fontname = "helvetica"]
   munsell [ label = "Munsell Color" ]
   lchab [ label = "LCH(ab)\n Illuminant C" ]
   xyzc [label = "XYZ\nIlluminant C" ]
   xyzd65a [label = "XYZ\nIlluminant D65" ]
   xyzd65b [label = "XYZ\nIlluminant D65" ]
   hex [label = "Hex"]

   {rank=same; munsell; hex;}
   {rank=same; xyzd65a; xyzd65b;}

   munsell -> lchab  [label = "dufy:munsell-hvc-to-lchab"]
   hex -> xyzd65b
   lchab -> xyzc
   xyzc -> xyzd65a [label = "bradford" ]
  
  

  xyzd65b -> xyzd65a [  label = "Error",
                        dir = both,
                        color = palevioletred3,
                        fontcolor = palevioletred3 ]

}
error_diagram
</details>

The error is evaluated by &Delta;E<sub>ab</sub>:  If &Delta;E<sub>ab</sub>  &ge; 1.0, the flag is 1.


#### H: quantized hue in {0, 1, ..., 999}

H corresponds to Munsell hue string as follows:

| H | Hue String |
| -------------------- | --------------------- | 
| 0 - 100 | 10RP (=0R) - 10R (=0YR) |
| 100 - 200 | 10R (=0YR) - 10YR (=0Y) |
| ... | ... |
| 900 - 999 | 10P (=0RP) - 9.9RP |

#### V: quantized value in {0, 1, ..., 1000}
Munsell value in [0, 10] is quantized to V by 0.01.
#### C:  quantized chroma in {0, 1, ..., 500}
Munsell chroma in [0, 50] is quantized to C by 0.1.


### Information about accuracy
The transformation error is evaluated as described above. The result is as follows:

| RGB space | Num. of Nodes with &Delta; E<sub>ab</sub> &ge; 1 |Mean &Delta; E<sub>ab</sub> | Max. &Delta; E<sub>ab</sub> |Mean &Delta; E<sub>00</sub> | Max. &Delta; E<sub>00</sub> |
| --- | ---: | ---: | ---: | ---:| ---: |
| sRGB (D65) | 957 (0.006%)| 0.1993 | 3.009 | 0.09052 | 2.359 |
| sRGB (D50) | 1252 (0.007%) | 0.2007 | 3.035 | 0.09400 | 2.253 |


Note: as is clear from the above diagram, the error here means the color difference not to *true* colors but to the return values of `dufy:munsell-hvc-to-lchab`. For more information, see https://github.com/privet-kitty/dufy.

