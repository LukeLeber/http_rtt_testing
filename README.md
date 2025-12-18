# HTTP Response Timing Test
This is a simple test to check HTTP response timing as the response size
increases.

It's semi-widely-ish broadcasted there are performance benefits if asset the
remains under 14kb, but I figured why not test it out to see?

- https://endtimes.dev/why-your-website-should-be-under-14kb-in-size/

## How to run?
Make sure the `gnuplot` binary is installed on your system and run the shell
script. Two files will be generated: a text file (`plot-data.txt`) and a line
chart (`chart.png`). The X axis is the asset size and the Y axis is the total
seconds to download the asset.

## Is it perfect?
By no means, but it may spawn a "Frequently Questioned Answer"!