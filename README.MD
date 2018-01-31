# Munsell Inversion Data
This repository provides fundamental data for conversion from some color spaces (e.g. RGB) to Munsell color system. All the data are generated with color library [dufy](https://github.com/privet-kitty/dufy).

## Copying
I don't claim any rights on the generated data (i.e. files in dat/ directory), which are all based on the [Munsell renotation data](https://www.rit.edu/cos/colorscience/rc_munsell_renotation.php). The other codes are under the MIT lincense.

## RGB-to-Munsell binary data
- sRGB: [mid-srgb-d65.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-srgb-d65.dat)
- sRGB [D50]: [mid-srgb-d50.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-srgb-d50.dat)
- Adobe RGB: [mid-adobergb-d65.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-adobergb-d65.dat)
- Adobe RGB [D50]: [mid-adobergb-d50.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/mid-adobergb-d50.dat)

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

   munsell -> lchab  [label = "dufy:mhvc-to-lchab"]
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


Note: as is clear from the above diagram, the error here means the color difference not to *true* colors but to the return values of `dufy:mhvc-to-lchab`. For more information about the converter, see https://github.com/privet-kitty/dufy.



## LCH<sub>ab</sub>-to-Munsell text data
- Medium set [C]: [lchab-to-munsell.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/lchab-to-munsell.dat)
- Large set [C]: [lchab-to-munsell-large.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/lchab-to-munsell-large.dat)
- Medium set [D65]: [lchab-to-munsell-d65.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/lchab-to-munsell-d65.dat)
- Large set [D65]: [lchab-to-munsell-d65-large.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/lchab-to-munsell-d65-large.dat)
- Medium set [D50]: [lchab-to-munsell-d50.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/lchab-to-munsell-d50.dat)
- Large set [D50]: [lchab-to-munsell-d50-large.dat](https://github.com/privet-kitty/munsell-inversion-data/raw/master/dat/lchab-to-munsell-d50-large.dat)

### Structure
These files are space-separated data of LCH<sub>ab</sub> and Munsell notations:

       L*      C*ab       hab         H         V         C      H360
        2        10         0   6.6121R   0.19144   1.49703   23.8035
        2        15         0   6.7657R   0.19144   2.33540   24.3564
        2        20         0   7.0775R   0.19144   3.34647   25.4789
        2        10         9  0.6621YR   0.19144   1.52596   38.3835
        2        15         9  0.8897YR   0.19144   2.37836   39.2031
     ...      ...       ...       ...       ...       ...       ...    

Here H360 is a numerical form of Munsell hue notation:

| H360 | H |
| -------------------- | --------------------- | 
| 0 to 36 | 10RP (=0R) to 10R (=0YR) |
| 36 to 72 | 10R (=0YR) to 10YR (=0Y) |
| ... | ... |
| 324 to 360 | 10P (=0RP) to 10RP (= 0R) |

Since the Munsell renotation data is measured under illuminant C, the data sets of illuminant D65 and D50 are generated by Bradford transformation. Hence you should use those of illuminant C, if you need *raw* data.

For each illuminant there are two data sets of different size:

| Data set | L<sup>&lowast;</sup> | C<sup>&lowast;</sup><sub>ab</sub> | H<sub>ab</sub> |
| -------------------- | --------------------- | ------ | -----|
| Medium | 2, 4, 6, 8, 10, 20, 30, ... , 100 | 5, 10, 15, ..., max. in MRD | 0, 9, 18, ..., 351|
| Large | 2, 4, 6, 8, 12, 14, 16, ... , 100 | 5, 10, 15, ..., max. in MRD| 0, 3, 6, ..., 357|



### Information about accuracy
Each data is accurate (i.e. significant digits = display digits) *as an inversion of* `dufy:mhvc-to-lchab`. Therefore the true errors depend on it. For more information, see https://github.com/privet-kitty/dufy.
