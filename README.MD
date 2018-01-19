# Munsell inversion data
This repository provides fundamental datas for conversion from some color spaces (e.g. RGB) to Munsell color system. All datas are generated with a color library [dufy](https://github.com/privet-kitty/dufy).

## Copying
I don't claim any rights on the transformation datas (i.e. files in dat/ directory), which are all based on the [Munsell renotation data](https://www.rit.edu/cos/colorscience/rc_munsell_renotation.php). The other codes are under the MIT lincense.

## RGB-to-Munsell binary data
- sRGB: [mid-srgb-d65.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-srgb-d65.dat)
- sRGB (D50): [mid-srgb-d50.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-srgb-d50.dat)
- Adobe RGB: [mid-adobergb-d65.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-adobergb-d65.dat)
- Adobe RGB (D50): [mid-adobergb-d50.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-adobergb-d50.dat)

### Structure
Each of these files is 256 * 256 * 256 * 32 bit (&#8786; 64MB) binary data, which is a table of  conversion from hex (#000000 to #FFFFFF) to Munsell color.  Each 32-bit data gives a corresponding Munsell color in hue-value-chroma format in *big-endian* byte-order:

| 1-bit | 1-bit | 10-bit | 10-bit | 10-bit |
| :---: | :---: | :---: | :---: | :---: |
| 0 | 0 | 0000000000 | 0000000000 | 0000000000 |
| F | - | H | V | C |

#### F: flag of large transformation error: 

This flag means that the transformation error is slightly large, which is estimated as follows:

![Transformation Error e.g. in the case of sRGB(D65)](https://g.gravizo.com/source/error_diagram?https%3A%2F%2Fraw.githubusercontent.com%2Fprivet-kitty%2Fmunsell-inversion-data%2Fmaster%2FREADME.MD)
<details> 
<summary></summary>
error_diagram
digraph G {
   graph [
      labelloc = "t",
      label = "Transformation Error e.g. in the case of sRGB(D65)",
      fontsize = 16
   ];
   node [shape = "box", fontname = "helvetica"]
   munsell [ label = "Munsell Color" ]
   lchab [ label = "LCH(ab)\n illuminant C" ]
   xyzc [label = "XYZ\nilluminant C" ]
   xyzd65a [label = "XYZ\nilluminant D65" ]
   xyzd65b [label = "XYZ\nilluminant D65" ]
   hex [label = "Hex"]

   {rank=same; munsell; hex;}
   {rank=same; xyzd65a; xyzd65b;}

   munsell -> lchab  [label = "dufy:munsell-hvc-to-lchab"]
   hex -> xyzd65b
   lchab -> xyzc
   xyzc -> xyzd65a [label = "Bradford" ]
  
  

  xyzd65b -> xyzd65a [  label = "Error",
                        dir = both,
                        color = palevioletred3,
                        fontcolor = palevioletred3 ]

}
error_diagram
</details>

The error is evaluated by &Delta;E<sup>&lowast;</sup><sub>ab</sub>:  If &Delta;E<sup>&lowast;</sup><sub>ab</sub>  &ge; 1.0, the flag is 1.


#### H: quantized hue in {0, 1, ..., 999}

H corresponds to Munsell hue string as follows:

| H | Hue String |
| -------------------- | --------------------- | 
| 0 to 100 | 10RP (=0R) to 10R (=0YR) |
| 100 to 200 | 10R (=0YR) to 10YR (=0Y) |
| ... | ... |
| 900 to 999 | 10P (=0RP) to 9.9RP |

#### V: quantized value in {0, 1, ..., 1000}
Munsell value in [0, 10] is quantized to V by 0.01.
#### C:  quantized chroma in {0, 1, ..., 500}
Munsell chroma in [0, 50] is quantized to C by 0.1.


### Information about accuracy
The transformation error is evaluated as described above. The general statistics is as follows:

| RGB space | Num. of nodes s.t. &Delta; E<sup>&lowast;</sup><sub>ab</sub> &ge; 1 |Mean &Delta; E<sup>&lowast;</sup><sub>ab</sub> | Max. &Delta; E<sup>&lowast;</sup><sub>ab</sub> |Mean &Delta; E<sup>&lowast;</sup><sub>00</sub> | Max. &Delta; E<sup>&lowast;</sup><sub>00</sub> |
| --- | ---: | ---: | ---: | ---:| ---: |
| sRGB (D65) | 957 (0.006%)| 0.1993 | 3.009 | 0.09052 | 2.359 |
| sRGB (D50) | 1252 (0.007%) | 0.2007 | 3.035 | 0.09400 | 2.253 |
| Adobe RGB (D65) | 32158 (0.192%) | 0.2197 | 3.339 | 0.09133 | 2.704 |
| Adobe RGB (D50) | 22745 (0.136%) | 0.2211 | 3.346 | 0.09456 | 2.598 |


Note: as is clear from the above diagram, the error here means the color difference not to *true* colors but to the return values of `dufy:munsell-hvc-to-lchab`. For more information about the converter, see https://github.com/privet-kitty/dufy.

