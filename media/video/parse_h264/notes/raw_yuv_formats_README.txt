
              --------------------------------------------
               Video Quality Experts Group Test Sequences
              --------------------------------------------

This directory contains the Video Quality Experts Group (VQEG) test sequences.

NOTE: Each sequence file beneath this directory is 182MB. Download
      times of an hour per sequence is typical. 

The sequence files are in the format specified by the VQEG Objective Video
Quality Model Test Plan except the alignment patterns have been removed.

The format is as follows:

  10 Frames(Not used) + 8seconds Video + 10 Frames(Not used)

The 10 frames of unused video allow enough frames for an MPEG2
codec to stabilize. Objective models will skip these frames.

There are two video formats: 525@60Hz and 625@50Hz. The format may be
identified by the sequence file name. The 525@60Hz sequence file
names end with _525.yuv and the 625@50Hz sequences end with _625.yuv. 
The 525 sequences are 260 frames long and the 625 sequences are 220 frames.

Both formats contain 720 pixels (1440 bytes) per horizontal line.
The 525 sequences have 486 active lines per frame and the 625 sequences
have 576 active lines per frame. Each line is in multiplexed 4:2:2
component video format as follows:

  Cb Y Cr Y ... 
  720 Y bytes per line 
  360 Cb bytes per line 
  360 Cr bytes per line 

Lines are concatenated into frames and frames are concatenated to form the
sequence files. The frames are identical to 8bit Abekas (also called Quantel)
files. There are no file headers.

All sequences are interlaced video except:

  src1  - which has no motion (all frames are identical).
  src7  - which is a progressive sequence.
  src13 - converted from 24Hz film by the 3/2 pull down method.

For the interlaced sequences:

The lines of the two fields are interlaced into the frames. The top field
of the 525@60Hz material is temporally LATER than the bottom field (Bottom
field first) and the top field of the 625@50Hz material is temporally EARLIER
than the bottom field (Top field first). 

The frame sizes are:

  525@60Hz Frame size = 1440 x 486 = 699840 bytes/frame
  625@50Hz Frame size = 1440 x 576 = 829440 bytes/frame

And the sequence sizes are:

  525@60Hz 8 sec + 20 frames file size = 699840 x 260 frames = 181958400 bytes
  625@50Hz 8 sec + 20 frames file size = 829440 x 220 frames = 182476800 bytes

Directories:

Reference     - The Original unimpaired sequences.

ThumbNails    - An HTML "thumb nail" index to the reference sequences.

HRC01 - HRC16 - The Hypothetical Reference Condition Sequences
		Each HRC is an impairment of the original Reference Sequence.

ALL_525       - Links to all of the 525@60 sequences.
                170 files (30GB)

ALL_625       - Links to all of the 625@50 sequences.
                170 files (30GB)

More Information:

More information is avaliable on the official VQEG website:

http://www.vqeg.org/

and in the various VQEG reports in the directory:

ftp://ftp.crc.ca/crc/vqeg/phase1-docs/

Various tools for converting and displaying these files can be found in:

ftp://ftp.crc.ca/crc/vqeg/TestSequenceTools
ftp://vqeg.its.bldrdoc.gov/VideoTools




Phil Blanchfield CRC
