use v6;

use Test;
use MessagePack::Unpacker;

plan 61;

$_ = MessagePack::Unpacker;

is .unpack("\x00"), 0x00, q[positive fixnum];
is .unpack("\x7f"), 0x7f, q[positive fixnum];

is .unpack("\xff"), -0x01, q[negative fixnum];
is .unpack("\xe0"), -0x20, q[negative fixnum];

is .unpack("\xcc\x00"), 0x00, q[uint8];
is .unpack("\xcc\xff"), 0xff, q[uint8];

is .unpack("\xcd\x00\x00"), 0x0000, q[uint16];
is .unpack("\xcd\x00\x01"), 0x0001, q[uint16]; 
is .unpack("\xcd\xff\xff"), 0xffff, q[uint16];

is .unpack("\xce\x00\x00\x00\x00"), 0x0000_0000, q[uint32];
is .unpack("\xce\x00\x00\x00\x01"), 0x0000_0001, q[uint32];
is .unpack("\xce\xff\xff\xff\xff"), 0xffff_ffff, q[uint32];

is .unpack("\xcf" ~ "\x00" x 8         ), 0x0000_0000_0000_0000, q[uint64];
is .unpack("\xcf" ~ "\x00" x 7 ~ "\x01"), 0x0000_0000_0000_0001, q[uint64];
is .unpack("\xcf" ~ "\xff" x 8         ), 0xffff_ffff_ffff_ffff, q[uint64];

is .unpack("\xd0\x00"),  0x00, q[int8];
is .unpack("\xd0\x7f"),  0x7f, q[int8];
is .unpack("\xd0\xff"), -0x01, q[int8];
is .unpack("\xd0\x80"), -0x80, q[int8];

is .unpack("\xd1\x00\x00"),  0x0000, q[int16];
is .unpack("\xd1\x7f\xff"),  0x7fff, q[int16];
is .unpack("\xd1\xff\xff"), -0x0001, q[int16];
is .unpack("\xd1\x80\x00"), -0x8000, q[int16];

is .unpack("\xd2\x00\x00\x00\x00"),  0x0000_0000, q[int32];
is .unpack("\xd2\x7f\xff\xff\xff"),  0x7fff_ffff, q[int32];
is .unpack("\xd2\xff\xff\xff\xff"), -0x0000_0001, q[int32];
is .unpack("\xd2\x80\x00\x00\x00"), -0x8000_0000, q[int32];

is .unpack("\xd3"     ~ "\x00" x 8),  0x0000_0000_0000_0000, q[int64];
is .unpack("\xd3\x7f" ~ "\xff" x 7),  0x7fff_ffff_ffff_ffff, q[int64];
is .unpack("\xd3"     ~ "\xff" x 8), -0x0000_0000_0000_0001, q[int64];
is .unpack("\xd3\x80" ~ "\x00" x 7), -0x8000_0000_0000_0000, q[int64];

is .unpack("\xc0"), Any,   q[nil];
is .unpack("\xc2"), False, q[false];
is .unpack("\xc3"), True,  q[true];

is .unpack("\xca\x00\x00\x00\x00"),  0.0, q[float];
is .unpack("\xca\x3f\x00\x00\x00"),  0.5, q[float];
is .unpack("\xca\xbf\x00\x00\x00"), -0.5, q[float];

is .unpack("\xcb\x00\x00\x00\x00\x00\x00\x00\x00"),  0.0, q[double];
is .unpack("\xcb\x3f\xe0\x00\x00\x00\x00\x00\x00"),  0.5, q[double];
is .unpack("\xcb\xbf\xe0\x00\x00\x00\x00\x00\x00"), -0.5, q[double];

is .unpack("\xa0" ~ ""      ), "",       q[fixraw];
is .unpack("\xa3" ~ "ABC"   ), "ABC",    q[fixfaw];
is .unpack("\xbf" ~ "A" x 31), "A" x 31, q[fixraw];

is .unpack("\xda\x00\x00" ~ ""          ), "",           q[raw16];
is .unpack("\xda\x00\x03" ~ "ABC"       ), "ABC",        q[raw16];
is .unpack("\xda\xff\xff" ~ "A" x 0xffff), "A" x 0xffff, q[raw16];

is .unpack("\xdb\x00\x00\x00\x00" ~ ""            ), "",             q[raw32];
is .unpack("\xdb\x00\x00\x00\x03" ~ "ABC"         ), "ABC",          q[raw32];
is .unpack("\xdb\x00\x01\x00\x00" ~ "A" x 0x1_0000), "A" x 0x1_0000, q[raw32];

is .unpack("\x90"            ), [],        q[fixarray];
is .unpack("\x93\x00\x01\x02"), [0, 1, 2], q[fixarray];

is .unpack("\xdc\x00\x00"            ), [],        q[array16];
is .unpack("\xdc\x00\x03\x00\x01\x02"), [0, 1, 2], q[array16];

is .unpack("\xdd\x00\x00\x00\x00"            ), [],        q[array32];
is .unpack("\xdd\x00\x00\x00\x03\x00\x01\x02"), [0, 1, 2], q[array32];

is .unpack("\x80"                ), {},               q[fixmap];
is .unpack("\x82\x00\x01\x02\x03"), {0 => 1, 2 => 3}, q[fixmap];

is .unpack("\xde\x00\x00"                ), {},               q[map16];
is .unpack("\xde\x00\x02\x00\x01\x02\x03"), {0 => 1, 2 => 3}, q[map16];

is .unpack("\xdf\x00\x00\x00\x00"                ), {},               q[map32];
is .unpack("\xdf\x00\x00\x00\x02\x00\x01\x02\x03"), {0 => 1, 2 => 3}, q[map32];

# vim: ft=perl6 :

