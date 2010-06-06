use v6;

# An Int playing this role is considered as unsigned
role MessagePack::Packer::Unsigned {
    submethod BUILD() {
        fail if self < 0;
    }
}

# A Num or a Rat playing this role is considered as float
role MessagePack::Packer::Float {
}

class MessagePack::Packer {
    my %type = (
        :nil,      :false,   :true,
        :fixnum,
        :float,    :double,
        :int8,     :int16,   :int32,  :int64,
        :uint8,    :uint16,  :uint32, :uint64,
        :fixraw,   :raw16,   :raw32,
        :fixarray, :array16, :array32,
        :fixmap,   :map16,   :map32,
    );

    # Class method
    method pack($object) {
        my $packer = self.new;
        $packer!pack($object);
    }

    method !pack($object is rw, :$as where %type | :!defined) {
        $object = (given $as {
            when :!defined      { $object      }
            when /int|fixnum/   { $object.Int  }
            when /float|double/ { $object.Num  }
            when /raw/          { $object.Str  }
            when /array/        { $object.list }
            when /map/          { $object.hash }
            when /nil/          { Nil          }
            when /false/        { False        }
            when /true/         { True         }
        });

        $as ~~ /(\d+)/;
        my $bytes = $0 ?? $0 / 8 !! *;

        return (given $object {
            when Int {
                self!pack-int($object, $bytes);
            }
            when Num | Rat {
                self!pack-num($object.Num, precision => $as);
            }
            when Str {
                self!pack-str($object, $bytes);
            }
            when Positional {
                self!pack-array($object, $bytes);
            }
            when Associative {
                self!pack-hash($object, $bytes);
            }
            when Nil {
                chr(0xc0);
            }
            when False {
                chr(0xc2);
            }
            when True {
                chr(0xc3);
            }
        });
    }
}

# vim: ft=perl6

