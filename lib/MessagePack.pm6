use v6;

module MessagePack;

use MessagePack::Unpacker;

multi sub unpack(Str $str) {
    MessagePack::Unpacker.unpack($str);
}

multi sub from-msgpack(Str $str) is export {
    MessagePack::Unpacker.unpack($str);
}

# vim: ft=perl6

