use v6;

module MessagePack;

use MessagePack::Unpacker;

sub unpack($str) {
    MessagePack::Unpacker.unpack($str);
}

# vim: ft=perl6 :

