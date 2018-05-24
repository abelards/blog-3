#!/bin/bash

# Optimizes and compresses the specified PDF using Ghostscript (gs).
#
# [NOTE]
# You need at least Ghostscript 9.10 in order for page labels defined in the
# PDF to be preserved (e.g., front matter pages numbered using roman numerals).

if [ -z $1 ]; then
   echo "Please supply a PDF file to optimize"
   exit 1
fi

if [ -z $GS ]; then
  GS=gs
fi

FILE=$1
FILE_BASENAME=${FILE%.pdf}
FILE_OPTIMIZED=$FILE_BASENAME-optimized.pdf
FILE_PDFMARK=
if [ -f "$FILE_BASENAME.pdfmark" ]; then
  FILE_PDFMARK="$FILE_BASENAME.pdfmark"
fi
DOWNSAMPLE_IMAGES=true
if [ -z $IMAGE_DPI ]; then
  #IMAGE_DPI=150
  IMAGE_DPI=300
fi

# /prepress defaults (see http://ghostscript.com/doc/current/Ps2pdf.htm)
# -d{Color,Gray,Mono}ImageDownsampleType=/Bicubic
# -dAutoFilter{Color,Gray}Images=true
# -dOptimize=true
# -dEmbedAllFonts=true
# -dSubsetFonts=true
# -dColorConversionStrategy=/LeaveColorUnchanged
# -dUCRandBGInfo=/Preserve
# -dCompressPages=true
#
# other unused settings
# -r72
#
# for info about pdfmarks, see http://milan.kupcevic.net/ghostscript-ps-pdf
#
# to convert to grayscale, add the following (though doesn't always work)
#
# -dProcessColorModel=/DeviceGray \
# -dColorConversionStrategy=/Gray \

"$GS" -q -dNOPAUSE -dBATCH -dSAFER -dNOOUTERSAVE \
  -sDEVICE=pdfwrite \
  -dPDFSETTINGS=/prepress \
  -dCannotEmbedFontPolicy=/Warning \
  -dDownsampleColorImages=$DOWNSAMPLE_IMAGES \
  -dColorImageResolution=$IMAGE_DPI \
  -dDownsampleGrayImages=$DOWNSAMPLE_IMAGES \
  -dGrayImageResolution=$IMAGE_DPI \
  -dDownsampleMonoImages=$DOWNSAMPLE_IMAGES \
  -dMonoImageResolution=$IMAGE_DPI \
  -sOutputFile="$FILE_OPTIMIZED" \
  "$FILE" $FILE_PDFMARK

exit 0