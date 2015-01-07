2015-01-05 11:28:18 +0545

make install

cd fortune && /Library/Developer/CommandLineTools/usr/bin/make CC='clang' \
		    CFLAGS='-O2 -DFORTDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes\"" -DOFFDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes/off\"" -Wall -fomit-frame-pointer -pipe -DHAVE_REGEX_H -DPOSIX_REGEX -I../util'	\
		    LDFLAGS='-s' LIBS=''
clang -O2 -DFORTDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes\"" -DOFFDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes/off\"" -Wall -fomit-frame-pointer -pipe -DHAVE_REGEX_H -DPOSIX_REGEX -I../util   -c -o fortune.o fortune.c
clang -s -o fortune fortune.o 
install -m 0755 -d /usr/local/Cellar/fortune/9708/bin
install -m 0755 fortune/fortune /usr/local/Cellar/fortune/9708/bin
cd util && /Library/Developer/CommandLineTools/usr/bin/make CC='clang' CFLAGS='-O2 -DFORTDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes\"" -DOFFDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes/off\"" -Wall -fomit-frame-pointer -pipe'	\
		    LDFLAGS='-s'
clang -O2 -DFORTDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes\"" -DOFFDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes/off\"" -Wall -fomit-frame-pointer -pipe   -c -o strfile.o strfile.c
clang -s -o strfile strfile.o
clang -O2 -DFORTDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes\"" -DOFFDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes/off\"" -Wall -fomit-frame-pointer -pipe   -c -o unstr.o unstr.c
clang -s -o unstr unstr.o
clang -O2 -DFORTDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes\"" -DOFFDIR="\"/usr/local/Cellar/fortune/9708/share/games/fortunes/off\"" -Wall -fomit-frame-pointer -pipe   -c -o rot.o rot.c
clang -s -o rot rot.o
install -m 0755 -d /usr/local/Cellar/fortune/9708/bin
install -m 0755 util/strfile /usr/local/Cellar/fortune/9708/bin
install -m 0755 util/unstr /usr/local/Cellar/fortune/9708/bin
-n Building fortune/fortune.man ... 
done.
install -m 0755 -d /usr/local/Cellar/fortune/9708/share/man/man6
install -m 0644 fortune/fortune.man /usr/local/Cellar/fortune/9708/share/man/man6/fortune.6
install -m 0755 -d /usr/local/Cellar/fortune/9708/share/man/man1
install -m 0644 util/strfile.man /usr/local/Cellar/fortune/9708/share/man/man1/strfile.1
rm -f /usr/local/Cellar/fortune/9708/share/man/man1/unstr.1
ln -s strfile.1 /usr/local/Cellar/fortune/9708/share/man/man1/unstr.1
cd datfiles && /Library/Developer/CommandLineTools/usr/bin/make COOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes \
		    OCOOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes/off WCOOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes/html \
		    OFFENSIVE=1 WEB=0
rm -f *.dat
for i in art ascii-art computers cookie definitions drugs education ethnic food fortunes goedel humorists kids law linuxcookie literature love magic medicine men-women miscellaneous news people pets platitudes politics riddles science songs-poems sports startrek translate-me wisdom work zippy ; do ../util/strfile $i || exit  ; done
"art.dat" created
There were 460 strings
Longest string: 1553 bytes
Shortest string: 16 bytes
"ascii-art.dat" created
There were 10 strings
Longest string: 1103 bytes
Shortest string: 106 bytes
"computers.dat" created
There were 1021 strings
Longest string: 1779 bytes
Shortest string: 10 bytes
"cookie.dat" created
There were 1140 strings
Longest string: 1790 bytes
Shortest string: 9 bytes
"definitions.dat" created
There were 1105 strings
Longest string: 2146 bytes
Shortest string: 10 bytes
"drugs.dat" created
There were 208 strings
Longest string: 1341 bytes
Shortest string: 23 bytes
"education.dat" created
There were 203 strings
Longest string: 1323 bytes
Shortest string: 21 bytes
"ethnic.dat" created
There were 163 strings
Longest string: 1322 bytes
Shortest string: 21 bytes
"food.dat" created
There were 198 strings
Longest string: 1054 bytes
Shortest string: 22 bytes
"fortunes.dat" created
There were 433 strings
Longest string: 187 bytes
Shortest string: 15 bytes
"goedel.dat" created
There were 54 strings
Longest string: 999 bytes
Shortest string: 6 bytes
"humorists.dat" created
There were 196 strings
Longest string: 1336 bytes
Shortest string: 24 bytes
"kids.dat" created
There were 150 strings
Longest string: 1487 bytes
Shortest string: 28 bytes
"law.dat" created
There were 202 strings
Longest string: 1690 bytes
Shortest string: 43 bytes
"linuxcookie.dat" created
There were 105 strings
Longest string: 1158 bytes
Shortest string: 37 bytes
"literature.dat" created
There were 256 strings
Longest string: 1371 bytes
Shortest string: 26 bytes
"love.dat" created
There were 151 strings
Longest string: 843 bytes
Shortest string: 26 bytes
"magic.dat" created
There were 29 strings
Longest string: 1216 bytes
Shortest string: 47 bytes
"medicine.dat" created
There were 72 strings
Longest string: 1144 bytes
Shortest string: 22 bytes
"men-women.dat" created
There were 582 strings
Longest string: 1487 bytes
Shortest string: 28 bytes
"miscellaneous.dat" created
There were 644 strings
Longest string: 997 bytes
Shortest string: 5 bytes
"news.dat" created
There were 53 strings
Longest string: 983 bytes
Shortest string: 49 bytes
"people.dat" created
There were 1231 strings
Longest string: 1208 bytes
Shortest string: 23 bytes
"pets.dat" created
There were 51 strings
Longest string: 826 bytes
Shortest string: 15 bytes
"platitudes.dat" created
There were 497 strings
Longest string: 694 bytes
Shortest string: 3 bytes
"politics.dat" created
There were 692 strings
Longest string: 1720 bytes
Shortest string: 10 bytes
"riddles.dat" created
There were 135 strings
Longest string: 2034 bytes
Shortest string: 36 bytes
"science.dat" created
There were 622 strings
Longest string: 1532 bytes
Shortest string: 14 bytes
"songs-poems.dat" created
There were 719 strings
Longest string: 1653 bytes
Shortest string: 29 bytes
"sports.dat" created
There were 147 strings
Longest string: 1525 bytes
Shortest string: 5 bytes
"startrek.dat" created
There were 225 strings
Longest string: 1024 bytes
Shortest string: 17 bytes
"translate-me.dat" created
There were 19 strings
Longest string: 1186 bytes
Shortest string: 15 bytes
"wisdom.dat" created
There were 402 strings
Longest string: 1819 bytes
Shortest string: 21 bytes
"work.dat" created
There were 630 strings
Longest string: 1446 bytes
Shortest string: 15 bytes
"zippy.dat" created
There were 548 strings
Longest string: 486 bytes
Shortest string: 5 bytes
touch cookies-stamp
if [ 1 = 1 ] ; then \
	    cd off && /Library/Developer/CommandLineTools/usr/bin/make OCOOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes/off ; fi
for i in drugs misandry privates sex astrology ethnic miscellaneous racism songs-poems black-humor hphobia misogyny religion vulgarity definitions limerick politics riddles         ; \
	    do ../../util/rot < unrotated/$i > $i || exit $? ; done
touch rotated-stamp
rm -f *.dat
for i in drugs misandry privates sex astrology ethnic miscellaneous racism songs-poems black-humor hphobia misogyny religion vulgarity definitions limerick politics riddles          ; do ../../util/strfile -x $i || exit $? ; done
"drugs.dat" created
There were 73 strings
Longest string: 1408 bytes
Shortest string: 29 bytes
"misandry.dat" created
There were 23 strings
Longest string: 772 bytes
Shortest string: 26 bytes
"privates.dat" created
There were 132 strings
Longest string: 1506 bytes
Shortest string: 13 bytes
"sex.dat" created
There were 805 strings
Longest string: 1524 bytes
Shortest string: 10 bytes
"astrology.dat" created
There were 42 strings
Longest string: 961 bytes
Shortest string: 37 bytes
"ethnic.dat" created
There were 126 strings
Longest string: 1660 bytes
Shortest string: 39 bytes
"miscellaneous.dat" created
There were 64 strings
Longest string: 1339 bytes
Shortest string: 23 bytes
"racism.dat" created
There were 3 strings
Longest string: 162 bytes
Shortest string: 148 bytes
"songs-poems.dat" created
There were 206 strings
Longest string: 1706 bytes
Shortest string: 50 bytes
"black-humor.dat" created
There were 270 strings
Longest string: 1758 bytes
Shortest string: 24 bytes
"hphobia.dat" created
There were 40 strings
Longest string: 1401 bytes
Shortest string: 40 bytes
"misogyny.dat" created
There were 60 strings
Longest string: 1225 bytes
Shortest string: 39 bytes
"religion.dat" created
There were 226 strings
Longest string: 1655 bytes
Shortest string: 17 bytes
"vulgarity.dat" created
There were 194 strings
Longest string: 1444 bytes
Shortest string: 12 bytes
"definitions.dat" created
There were 332 strings
Longest string: 1066 bytes
Shortest string: 10 bytes
"limerick.dat" created
There were 1001 strings
Longest string: 873 bytes
Shortest string: 66 bytes
"politics.dat" created
There were 349 strings
Longest string: 2065 bytes
Shortest string: 22 bytes
"riddles.dat" created
There were 267 strings
Longest string: 667 bytes
Shortest string: 40 bytes
touch ocookies-stamp
if [ 0 = 1 ] ; then \
	    cd html && /Library/Developer/CommandLineTools/usr/bin/make WCOOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes/html; fi
cd datfiles && /Library/Developer/CommandLineTools/usr/bin/make COOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes \
		    OCOOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes/off WCOOKIEDIR=/usr/local/Cellar/fortune/9708/share/games/fortunes/html \
		    OFFENSIVE=1 WEB=0 install
install -m 0755 -d /usr/local/Cellar/fortune/9708/share/games/fortunes
if [ 1 = 1 ] ; then cd off && /Library/Developer/CommandLineTools/usr/bin/make install ; fi
install -m 0755 -d /usr/local/Cellar/fortune/9708/share/games/fortunes/off
for i in drugs misandry privates sex astrology ethnic miscellaneous racism songs-poems black-humor hphobia misogyny religion vulgarity definitions limerick politics riddles          ; \
	    do install -m 0644 $i $i.dat /usr/local/Cellar/fortune/9708/share/games/fortunes/off || exit $? ; done
if [ 0 = 1 ] ; then cd html && /Library/Developer/CommandLineTools/usr/bin/make install ; fi
for i in art ascii-art computers cookie definitions drugs education ethnic food fortunes goedel humorists kids law linuxcookie literature love magic medicine men-women miscellaneous news people pets platitudes politics riddles science songs-poems sports startrek translate-me wisdom work zippy ; do \
		install -m 0644 $i $i.dat /usr/local/Cellar/fortune/9708/share/games/fortunes || exit cookies-stamp ; done
