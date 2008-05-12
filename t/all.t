package SCALAR;

sub test { __PACKAGE__ }

our $VERSION = 0.01;

package ARRAY;

sub test { __PACKAGE__ }

our $VERSION = 0.01;

package HASH;

sub test { __PACKAGE__ }

our $VERSION = 0.01;

package CODE;

sub test { __PACKAGE__ }

our $VERSION = 0.01;

package Test::SCALAR;

sub test { lc shift }

package MyScalar;

sub test { __PACKAGE__ }

package MyDefault;

sub test { __PACKAGE__ }

package MyNamespace::SCALAR;

sub test { __PACKAGE__ }

package MyNamespace::ARRAY;

sub test { __PACKAGE__ }

package MyNamespace::HASH;

sub test { __PACKAGE__ }

package MyNamespace::CODE;

sub test { __PACKAGE__ }

package Test;

sub new { bless {}, ref $_[0] || $_[0]; }
sub test { 'rubicund' }

package main;

use strict;
use warnings;

use Test::More tests => 292;

BEGIN {
    chdir 't' if -d 't';
    unshift @INC, '../lib';
}

$| = 1;

sub add { my ($x, $y) = @_; $x + $y }

my $undef = undef;
my $int = 3;
my $float = 3.1415927;
my $string = 'Hello, world!';
my $array = [ 0 .. 9 ];
my $hash = { 0 .. 9 };
my $code = \&add;
my $error = qr{Can't call method "test" without a package or object reference};
my $string_error = qr{Can't locate object method "test" via package "Hello, world!"};
my $unblessed_error = qr{Can't call method "test" on unblessed reference};
my $undef_error = qr{Can't call method "[^"]+" on an undefined value};

# test no args
{
    use autobox; # don't use use_ok(...) as this needs to be loaded at compile time

    my $object = Test->new();
    is (ref $object, 'Test', 'no args: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'no args: $object->test() - object not autoboxed');

    is (3->test(), 'SCALAR', 'no args: integer literal');
    is ((-3)->test(), 'SCALAR', 'no args: negative integer literal');
    is ((+3)->test(), 'SCALAR', 'no args: positive integer literal');
    is ($int->test(), 'SCALAR', 'no args: $integer');

    is (3.1415927->test(), 'SCALAR', 'no args: float literal');
    is ((-3.1415927)->test(), 'SCALAR', 'no args: negative float literal');
    is ((+3.1415927)->test(), 'SCALAR', 'no args: positive float literal');
    is ($float->test(), 'SCALAR', 'no args: $float');

    is ('Hello, world'->test(), 'SCALAR', 'no args: single quoted string literal');
    is ("Hello, world"->test(), 'SCALAR', 'no args: double quoted string literal');
    is ($string->test(), 'SCALAR', 'no args: $string');

    is ([ 0 .. 9 ]->test(), 'ARRAY', 'no args: ARRAY ref');
    is ($array->test(), 'ARRAY', 'no args: $array');

    is ({ 0 .. 9 }->test(), 'HASH', 'no args: HASH ref');
    is ($hash->test(), 'HASH', 'no args: $hash');

    is ((\&add)->test(), 'CODE', 'no args: CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'CODE', 'no args: ANON sub');
    is ($code->test(), 'CODE', 'no args: $code');
}

# test override package 
{
    use autobox SCALAR => 'MyScalar';

    my $object = Test->new();
    is (ref $object, 'Test', 'override package: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'override package: $object->test() - object not autoboxed');

    is (3->test(), 'MyScalar', 'override package: integer literal');
    is ((-3)->test(), 'MyScalar', 'override package: negative integer literal');
    is ((+3)->test(), 'MyScalar', 'override package: positive integer literal');
    is ($int->test(), 'MyScalar', 'override package: $integer');

    is (3.1415927->test(), 'MyScalar', 'override package: float literal');
    is ((-3.1415927)->test(), 'MyScalar', 'override package: negative float literal');
    is ((+3.1415927)->test(), 'MyScalar', 'override package: positive float literal');
    is ($float->test(), 'MyScalar', 'override package: $float');

    is ('Hello, world'->test(), 'MyScalar',
	'override package: single quoted string literal');
    is ("Hello, world"->test(), 'MyScalar',
	'override package: double quoted string literal');
    is ($string->test(), 'MyScalar', 'override package: $string');
}

# test override namespace 
{
    use autobox SCALAR => 'MyNamespace::';

    my $object = Test->new();
    is (ref $object, 'Test', 'override namespace: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'override namespace: $object->test() - object not autoboxed');

    is (3->test(), 'MyNamespace::SCALAR', 'override namespace: integer literal');
    is ((-3)->test(), 'MyNamespace::SCALAR',
	'override namespace: negative integer literal');
    is ((+3)->test(), 'MyNamespace::SCALAR',
	'override namespace: positive integer literal');
    is ($int->test(), 'MyNamespace::SCALAR',
	'override namespace: $int');

    is (3.1415927->test(), 'MyNamespace::SCALAR',
	'override namespace: float literal');
    is ((-3.1415927)->test(), 'MyNamespace::SCALAR',
	'override namespace: negative float literal');
    is ((+3.1415927)->test(), 'MyNamespace::SCALAR',
	'override namespace: positive float literal');
    is ($float->test(), 'MyNamespace::SCALAR',
	'override namespace: $float');

    is ('Hello, world'->test(), 'MyNamespace::SCALAR',
	'override namespace: single quoted string literal');
    is ("Hello, world"->test(), 'MyNamespace::SCALAR',
	'override namespace: double quoted string literal');
    is ($string->test(), 'MyNamespace::SCALAR', 'override namespace: $string');
}

# test default package
{
    use autobox DEFAULT => 'MyDefault';

    my $object = Test->new();
    is (ref $object, 'Test', 'default package: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'default package: $object->test() - object not autoboxed');

    is (3->test(), 'MyDefault', 'default package: integer literal');
    is ((-3)->test(), 'MyDefault', 'default package: negative integer literal');
    is ((+3)->test(), 'MyDefault', 'default package: positive integer literal');
    is ($int->test(), 'MyDefault', 'default package: $int');

    is (3.1415927->test(), 'MyDefault', 'default package: float literal');
    is ((-3.1415927)->test(), 'MyDefault', 'default package: negative float literal');
    is ((+3.1415927)->test(), 'MyDefault', 'default package: positive float literal');
    is ($float->test(), 'MyDefault', 'default package: $float');

    is ('Hello, world'->test(), 'MyDefault',
	'default package: single quoted string literal');
    is ("Hello, world"->test(), 'MyDefault',
	'default package: double quoted string literal');
    is ($string->test(), 'MyDefault', 'default package: $string');

    is ([ 0 .. 9 ]->test(), 'MyDefault', 'default package: ARRAY ref');
    is ($array->test(), 'MyDefault', 'default package: $array');

    is ({ 0 .. 9 }->test(), 'MyDefault', 'default package: HASH ref');
    is ($hash->test(), 'MyDefault', 'default package: $hash');

    is ((\&add)->test(), 'MyDefault', 'default package: CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'MyDefault', 'default package: ANON sub');
    is ($code->test(), 'MyDefault', 'default package: $code');
}

# test default namespace
{
    use autobox DEFAULT => 'MyNamespace::';

    my $object = Test->new();
    is (ref $object, 'Test', 'default namespace: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'default namespace: $object->test() - object not autoboxed');

    is (3->test(), 'MyNamespace::SCALAR', 'default namespace: integer literal');
    is ((-3)->test(), 'MyNamespace::SCALAR',
	'default namespace: negative integer literal');
    is ((+3)->test(), 'MyNamespace::SCALAR',
	'default namespace: positive integer literal');
    is ($int->test(), 'MyNamespace::SCALAR', 'default namespace: $int');

    is (3.1415927->test(), 'MyNamespace::SCALAR',
	'default namespace: float literal');
    is ((-3.1415927)->test(), 'MyNamespace::SCALAR',
	'default namespace: negative float literal');
    is ((+3.1415927)->test(), 'MyNamespace::SCALAR',
	'default namespace: positive float literal');
    is ($float->test(), 'MyNamespace::SCALAR',
	'default namespace: $float');

    is ('Hello, world'->test(), 'MyNamespace::SCALAR',
	'default namespace: single quoted string literal');
    is ("Hello, world"->test(), 'MyNamespace::SCALAR',
	'default namespace: double quoted string literal');
    is ($string->test(), 'MyNamespace::SCALAR', 'default namespace: $string');

    is ([ 0 .. 9 ]->test(), 'MyNamespace::ARRAY', 'default namespace: ARRAY ref');
    is ($array->test(), 'MyNamespace::ARRAY', 'default namespace: $array');

    is ({ 0 .. 9 }->test(), 'MyNamespace::HASH', 'default namespace: HASH ref');
    is ($hash->test(), 'MyNamespace::HASH', 'default namespace: $hash');

    is ((\&add)->test(), 'MyNamespace::CODE', 'default namespace: CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'MyNamespace::CODE', 'default namespace: ANON sub');
    is ($code->test(), 'MyNamespace::CODE', 'default namespace: $code');
}

# test default undef
{
    use autobox DEFAULT => undef;

    eval { $int->test() };
    ok (($@ && ($@ =~ /^$error/)), 'default undef: $int');

    eval { $float->test() };
    ok (($@ && ($@ =~ /^$error/)), 'default undef: $float');

    eval { $string->test() };
    ok (($@ && ($@ =~ /^$string_error/)), 'default undef: $string');

    eval { $array->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'default undef: $array');

    eval { $hash->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'default undef: $hash');

    eval { $code->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'default undef: $code');
}

# test all 1
{
    use autobox 
	SCALAR	=> 'MyScalar',	    # specific package
	HASH	=> undef,	    # don't autobox
	DEFAULT => 'MyNamespace::'; # use MyNamespace:: namespace for CODE

    my $object = Test->new();
    is (ref $object, 'Test', 'test all 1: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'test all 1: $object->test() - object not autoboxed');

    is (3->test(), 'MyScalar', 'test all 1: integer literal');
    is ((-3)->test(), 'MyScalar', 'test all 1: negative integer literal');
    is ((+3)->test(), 'MyScalar', 'test all 1: positive integer literal');
    is ($int->test(), 'MyScalar', 'test all 1: $int');

    is (3.1415927->test(), 'MyScalar', 'test all 1: float literal');
    is ((-3.1415927)->test(), 'MyScalar', 'test all 1: negative float literal');
    is ((+3.1415927)->test(), 'MyScalar', 'test all 1: positive float literal');
    is ($float->test(), 'MyScalar', 'test all 1: $float');

    is ('Hello, world'->test(), 'MyScalar',
	'test all 1: single quoted string literal');
    is ("Hello, world"->test(), 'MyScalar',
	'test all 1: double quoted string literal');
    is ($string->test(), 'MyScalar', 'test all 1: $string');

    my $error = q{Can't call method "test" on unblessed reference};
    eval { ({ 0 .. 9 })->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 1: HASH ref: not autoboxed');
	
    is ((\&add)->test(), 'MyNamespace::CODE', 'test all 1: CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'MyNamespace::CODE', 'test all 1: ANON sub');
    is ($code->test(), 'MyNamespace::CODE', 'test all 1: $code');
}

# test all 2
{
    use autobox 
	SCALAR	=> 'MyScalar',	    # specific package
	HASH	=> undef,	    # don't autobox
	DEFAULT => 'MyDefault';	    # use MyDefault package for CODE

    my $object = Test->new();
    is (ref $object, 'Test', 'test all 2: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'test all 2: $object->test() - object not autoboxed');

    is (3->test(), 'MyScalar', 'test all 2: integer literal');
    is ((-3)->test(), 'MyScalar', 'test all 2: negative integer literal');
    is ((+3)->test(), 'MyScalar', 'test all 2: positive integer literal');
    is ($int->test(), 'MyScalar', 'test all 2: $int');

    is (3.1415927->test(), 'MyScalar', 'test all 2: float literal');
    is ((-3.1415927)->test(), 'MyScalar', 'test all 2: negative float literal');
    is ((+3.1415927)->test(), 'MyScalar', 'test all 2: positive float literal');
    is ($float->test(), 'MyScalar', 'test all 2: $float');

    is ('Hello, world'->test(), 'MyScalar',
	'test all 2: single quoted string literal');
    is ("Hello, world"->test(), 'MyScalar',
	'test all 2: double quoted string literal');
    is ($string->test(), 'MyScalar', 'test all 2: $string');

    my $error = q{Can't call method "test" on unblessed reference};
    eval { ({ 0 .. 9 })->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 2: HASH ref: not autoboxed');
	
    is ((\&add)->test(), 'MyDefault', 'test all 2: CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'MyDefault', 'test all 2: ANON sub');
    is ($code->test(), 'MyDefault', 'test all 2: $code');
}

# test all 3
{
    use autobox 
	SCALAR	=> 'MyScalar',	    # specific package
	HASH	=> undef,	    # don't autobox
	DEFAULT => 'CODE';	    # use CODE package for CODE

    my $object = Test->new();
    is (ref $object, 'Test', 'test all 3: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'test all 3: $object->test() - object not autoboxed');

    is (3->test(), 'MyScalar', 'test all 3: integer literal');
    is ((-3)->test(), 'MyScalar', 'test all 3: negative integer literal');
    is ((+3)->test(), 'MyScalar', 'test all 3: positive integer literal');
    is ($int->test(), 'MyScalar', 'test all 3: $int');

    is (3.1415927->test(), 'MyScalar', 'test all 3: float literal');
    is ((-3.1415927)->test(), 'MyScalar', 'test all 3: negative float literal');
    is ((+3.1415927)->test(), 'MyScalar', 'test all 3: positive float literal');
    is ($float->test(), 'MyScalar', 'test all 3: $float');

    is ('Hello, world'->test(), 'MyScalar',
	'test all 3: single quoted string literal');
    is ("Hello, world"->test(), 'MyScalar',
	'test all 3: double quoted string literal');
    is ($string->test(), 'MyScalar', 'test all 3: $string');

    my $error = q{Can't call method "test" on unblessed reference};
    eval { ({ 0 .. 9 })->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 3: HASH ref: not autoboxed');
	
    is ((\&add)->test(), 'CODE', 'test all 3: CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'CODE', 'test all 3: ANON sub');
    is ($code->test(), 'CODE', 'test all 3: $code');
}

# test all 4
{
    use autobox 
	SCALAR	=> 'MyScalar',	    # specific package
	DEFAULT => undef;	    # don't autobox ARRAY, HASH or CODE

    my $object = Test->new();
    is (ref $object, 'Test', 'test all 4: Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'test all 4: $object->test() - object not autoboxed');

    is (3->test(), 'MyScalar', 'test all 4: integer literal');
    is ((-3)->test(), 'MyScalar', 'test all 4: negative integer literal');
    is ((+3)->test(), 'MyScalar', 'test all 4: positive integer literal');
    is ($int->test(), 'MyScalar', 'test all 4: $int');

    is (3.1415927->test(), 'MyScalar', 'test all 4: float literal');
    is ((-3.1415927)->test(), 'MyScalar', 'test all 4: negative float literal');
    is ((+3.1415927)->test(), 'MyScalar', 'test all 4: positive float literal');
    is ($float->test(), 'MyScalar', 'test all 4: $float');

    is ('Hello, world'->test(), 'MyScalar',
	'test all 4: single quoted string literal');
    is ("Hello, world"->test(), 'MyScalar',
	'test all 4: double quoted string literal');
    is ($string->test(), 'MyScalar', 'test all 4: $string');

    my $error = q{Can't call method "test" on unblessed reference};
    eval { ({ 0 .. 9 })->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 4: HASH ref: not autoboxed');

    eval { (\&add)->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 4: CODE ref: not autoboxed');

    eval { sub { $_[0] + $_[1] }->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 4: ANON sub: not autoboxed');

    eval { $code->test() };
    ok (($@ && ($@ =~ /^$error/)), 'test all 4: $code: not autoboxed');
}

# test autobox not used
{
    eval { $int->test() };
    ok (($@ && ($@ =~ /^$error/)), 'autobox not used: $int');

    eval { $float->test() };
    ok (($@ && ($@ =~ /^$error/)), 'autobox not used: $float');

    eval { $string->test() };
    ok (($@ && ($@ =~ /^$string_error/)), 'autobox not used: $string');

    eval { $array->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'autobox not used: $array');

    eval { $hash->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'autobox not used: $hash');

    eval { $code->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'autobox not used: $code');
}

# test no autobox
{
    use autobox;

    no autobox;

    eval { $int->test() };
    ok (($@ && ($@ =~ /^$error/)), 'no autobox: $int');

    eval { $float->test() };
    ok (($@ && ($@ =~ /^$error/)), 'no autobox: $float');

    eval { $string->test() };
    ok (($@ && ($@ =~ /^$string_error/)), 'no autobox: $string');

    eval { $array->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'no autobox: $array');

    eval { $hash->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'no autobox: $hash');

    eval { $code->test() };
    ok (($@ && ($@ =~ /^$unblessed_error/)), 'no autobox: $code');
}

# test nested
{
    use autobox;

    my $object = Test->new();
    is (ref $object, 'Test', 'nested (outer): Test->new() - bareword not autoboxed');

    my $result = $object->test();
    is ($result, 'rubicund', 'nested (outer): $object->test() - object not autoboxed');

    is (3->test(), 'SCALAR', 'nested (outer): integer literal');
    is ((-3)->test(), 'SCALAR', 'nested (outer): negative integer literal');
    is ((+3)->test(), 'SCALAR', 'nested (outer): positive integer literal');
    is ($int->test(), 'SCALAR', 'nested (outer): $integer');

    {
	use autobox DEFAULT => 'MyNamespace::';

	is ('Hello, world'->test(), 'SCALAR', 'nested (inner): single quoted string literal');
	is ("Hello, world"->test(), 'SCALAR', 'nested (inner): double quoted string literal');
	is ($string->test(), 'SCALAR', 'nested (inner): $string');
	is ([ 0 .. 9 ]->test(), 'ARRAY', 'nested (inner): ARRAY ref');
	is ($array->test(), 'ARRAY', 'nested (inner): $array');

	ok ('Hello, world'->isa('SCALAR'), 'nested (inner): single quoted string literal isa(OUTER)');
	ok ("Hello, world"->isa('SCALAR'), 'nested (inner): double quoted string literal isa(OUTER)');
	ok ($string->isa('SCALAR'), 'nested (inner): $string isa(OUTER)');
	ok ([ 0 .. 9 ]->isa('ARRAY'), 'nested (inner): ARRAY ref isa(OUTER)');
	ok ($array->isa('ARRAY'), 'nested (inner): $array isa(OUTER)');

	ok ('Hello, world'->isa('MyNamespace::SCALAR'), 'nested (inner): single quoted string literal isa(INNER)');
	ok ("Hello, world"->isa('MyNamespace::SCALAR'), 'nested (inner): double quoted string literal isa(INNER)');
	ok ($string->isa('MyNamespace::SCALAR'), 'nested (inner): $string isa(INNER)');
	ok ([ 0 .. 9 ]->isa('MyNamespace::ARRAY'), 'nested (inner): ARRAY ref isa(INNER)');
	ok ($array->isa('MyNamespace::ARRAY'), 'nested (inner): $array isa(INNER)');
    }

    is ('Hello, world'->isa('MyNamespace::SCALAR'), '', 'nested (outer): single quoted string literal !isa(INNER)');
    is ("Hello, world"->isa('MyNamespace::SCALAR'), '', 'nested (outer): double quoted string literal !isa(INNER)');
    is ($string->isa('MyNamespace::SCALAR'), '', 'nested (outer): $string !isa(INNER)');
    is ([ 0 .. 9 ]->isa('MyNamespace::ARRAY'), '', 'nested (outer): ARRAY ref !isa(INNER)');
    is ($array->isa('MyNamespace::ARRAY'), '', 'nested (outer): $array !isa(INNER)');

    is ({ 0 .. 9 }->test(), 'HASH', 'nested (outer): HASH ref');
    is ($hash->test(), 'HASH', 'nested (outer): $hash');

    is ((\&add)->test(), 'CODE', 'nested (outer): CODE ref');
    is (sub { $_[0] + $_[1] }->test(), 'CODE', 'nested (outer): ANON sub');
    is ($code->test(), 'CODE', 'nested (outer): $code');
}

# test can
{
    use autobox;

    is (3->can('test'), \&SCALAR::test, 'can: integer literal');
    is ((-3)->can('test'), \&SCALAR::test, 'can: negative integer literal');
    is ((+3)->can('test'), \&SCALAR::test, 'can: positive integer literal');
    is ($int->can('test'), \&SCALAR::test, 'can: $integer');

    is (3.1415927->can('test'), \&SCALAR::test, 'can: float literal');
    is ((-3.1415927)->can('test'), \&SCALAR::test, 'can: negative float literal');
    is ((+3.1415927)->can('test'), \&SCALAR::test, 'can: positive float literal');
    is ($float->can('test'), \&SCALAR::test, 'can: $float');

    is ('Hello, world'->can('test'), \&SCALAR::test, 'can: single quoted string literal');
    is ("Hello, world"->can('test'), \&SCALAR::test, 'can: double quoted string literal');
    is ($string->can('test'), \&SCALAR::test, 'can: $string');

    is ([ 0 .. 9 ]->can('test'), \&ARRAY::test, 'can: ARRAY ref');
    is ($array->can('test'), \&ARRAY::test, 'can: $array');

    is ({ 0 .. 9 }->can('test'), \&HASH::test, 'can: HASH ref');
    is ($hash->can('test'), \&HASH::test, 'can: $hash');

    is ((\&add)->can('test'), \&CODE::test, 'can: CODE ref');
    is (sub { $_[0] + $_[1] }->can('test'), \&CODE::test, 'can: ANON sub');
    is ($code->can('test'), \&CODE::test, 'can: $code');
}

# test isa: also ensures isa() isn't simply
# returning true unconditionally
{
    use autobox;

    ok (3->isa('SCALAR'), 'isa SCALAR: integer literal');
    ok (3->isa('UNIVERSAL'), 'isa UNIVERSAL: integer literal');
    is (3->isa('UNKNOWN'), '', 'isa UNKNOWN: integer literal');

    ok ((-3)->isa('SCALAR'), 'isa SCALAR: negative integer literal');
    ok ((-3)->isa('UNIVERSAL'), 'isa UNIVERSAL: negative integer literal');
    is ((-3)->isa('UNKNOWN'), '', 'isa UNKNOWN: negative integer literal');

    ok ((+3)->isa('SCALAR'), 'isa SCALAR: positive integer literal');
    ok ((+3)->isa('UNIVERSAL'), 'isa UNIVERSAL: positive integer literal');
    is ((+3)->isa('UNKNOWN'), '', 'isa UNKNOWN: positive integer literal');

    ok ($int->isa('SCALAR'), 'isa SCALAR: $integer');
    ok ($int->isa('UNIVERSAL'), 'isa UNIVERSAL: $integer');
    is ($int->isa('UNKNOWN'), '', 'isa UNKNOWN: $integer');

    ok (3.1415927->isa('SCALAR'), 'isa SCALAR: float literal');
    ok (3.1415927->isa('UNIVERSAL'), 'isa UNIVERSAL: float literal');
    is (3.1415927->isa('UNKNOWN'), '', 'isa UNKNOWN: float literal');

    ok ((-3.1415927)->isa('SCALAR'), 'isa SCALAR: negative float literal');
    ok ((-3.1415927)->isa('UNIVERSAL'), 'isa UNIVERSAL: negative float literal');
    is ((-3.1415927)->isa('UNKNOWN'), '', 'isa UNKNOWN: negative float literal');

    ok ((+3.1415927)->isa('SCALAR'), 'isa SCALAR: positive float literal');
    ok ((+3.1415927)->isa('UNIVERSAL'), 'isa UNIVERSAL: positive float literal');
    is ((+3.1415927)->isa('UNKNOWN'), '', 'isa UNKNOWN: positive float literal');

    ok ($float->isa('SCALAR'), 'isa SCALAR: $float');
    ok ($float->isa('UNIVERSAL'), 'isa UNIVERSAL: $float');
    is ($float->isa('UNKNOWN'), '', 'isa UNKNOWN: $float');

    ok ('Hello, world'->isa('SCALAR'), 'isa SCALAR: single quoted string literal');
    ok ('Hello, world'->isa('UNIVERSAL'), 'isa UNIVERSAL: single quoted string literal');
    is ('Hello, world'->isa('UNKNOWN'), '', 'isa UNKNOWN: single quoted string literal');
	 
    ok ("Hello, world"->isa('SCALAR'), 'isa SCALAR: double quoted string literal');
    ok ("Hello, world"->isa('UNIVERSAL'), 'isa UNIVERSAL: double quoted string literal');
    is ("Hello, world"->isa('UNKNOWN'), '', 'isa UNKNOWN: double quoted string literal');

    ok ($string->isa('SCALAR'), 'isa SCALAR: $string');
    ok ($string->isa('UNIVERSAL'), 'isa UNIVERSAL: $string');
    is ($string->isa('UNKNOWN'), '', 'isa UNKNOWN: $string');

    ok ([ 0 .. 9 ]->isa('ARRAY'), 'isa ARRAY: ARRAY ref');
    ok ([ 0 .. 9 ]->isa('UNIVERSAL'), 'isa UNIVERSAL: ARRAY ref');
    is ([ 0 .. 9 ]->isa('UNKNOWN'), '', 'isa UNKNOWN: ARRAY ref');

    ok ($array->isa('ARRAY'), 'isa ARRAY: $array');
    ok ($array->isa('UNIVERSAL'), 'isa UNIVERSAL: $array');
    is ($array->isa('UNKNOWN'), '', 'isa UNKNOWN: $array');

    ok ({ 0 .. 9 }->isa('HASH'), 'isa HASH: HASH ref');
    ok ({ 0 .. 9 }->isa('UNIVERSAL'), 'isa UNIVERSAL: HASH ref');
    is ({ 0 .. 9 }->isa('UNKNOWN'), '', 'isa UNKNOWN: HASH ref');

    ok ($hash->isa('HASH'), 'isa HASH: $hash');
    ok ($hash->isa('UNIVERSAL'), 'isa UNIVERSAL: $hash');
    is ($hash->isa('UNKNOWN'), '', 'isa UNKNOWN: $hash');

    ok ((\&add)->isa('CODE'), 'isa CODE: CODE ref');
    ok ((\&add)->isa('UNIVERSAL'), 'isa UNIVERSAL: CODE ref');
    is ((\&add)->isa('UNKNOWN'), '', 'isa UNKNOWN: CODE ref');

    ok (sub { $_[0] + $_[1] }->isa('CODE'), 'isa CODE: ANON sub');
    ok (sub { $_[0] + $_[1] }->isa('UNIVERSAL'), 'isa UNIVERSAL: ANON sub');
    is (sub { $_[0] + $_[1] }->isa('UNKNOWN'), '', 'isa UNKNOWN: ANON sub');

    ok ($code->isa('CODE'), 'isa CODE: $code');
    ok ($code->isa('UNIVERSAL'), 'isa UNIVERSAL: $code');
    is ($code->isa('UNKNOWN'), '', 'isa UNKNOWN: $code');
}

# test VERSION
=pod
{
    use autobox;

    is (3->VERSION(), 0.01, 'can: integer literal');
    is ((-3)->VERSION(), 0.01, 'can: negative integer literal');
    is ((+3)->VERSION(), 0.01, 'can: positive integer literal');
    is ($int->VERSION(), 0.01, 'can: $integer');

    is (3.1415927->VERSION(), 0.01, 'can: float literal');
    is ((-3.1415927)->VERSION(), 0.01, 'can: negative float literal');
    is ((+3.1415927)->VERSION(), 0.01, 'can: positive float literal');
    is ($float->VERSION(), 0.01, 'can: $float');

    is ('Hello, world'->VERSION(), 0.01, 'can: single quoted string literal');
    is ("Hello, world"->VERSION(), 0.01, 'can: double quoted string literal');
    is ($string->VERSION(), 0.01, 'can: $string');

    is ([ 0 .. 9 ]->VERSION(), 0.01, 'can: ARRAY ref');
    is ($array->VERSION(), 0.01, 'can: $array');

    is ({ 0 .. 9 }->VERSION(), 0.01, 'can: HASH ref');
    is ($hash->VERSION(), 0.01, 'can: $hash');

    is ((\&add)->VERSION(), 0.01, 'can: CODE ref');
    is (sub { $_[0] + $_[1] }->VERSION(), 0.01, 'can: ANON sub');
    is ($code->VERSION(), 0.01, 'can: $code');
}
=cut

# test undef: by default, undef shouldn't be autoboxed...
{
    use autobox;

    eval { undef->test() };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef: undef->test()');

    eval { $undef->test() };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef: $undef->test()');

    eval { undef->isa('SCALAR') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef: undef->isa(...)');

    eval { $undef->isa('SCALAR') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef: $undef->isa(...)');

    eval { undef->can('test') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef: undef->can(...)');

    eval { $undef->can('test') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef: $undef->can(...)');
}

# test undef 2: not even if DEFAULT is specified
{
    use autobox DEFAULT => 'SCALAR';

    eval { undef->test() };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef with DEFAULT: undef->test()');

    eval { $undef->test() };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef with DEFAULT: $undef->test()');

    eval { undef->isa('SCALAR') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef with DEFAULT: undef->isa(...)');

    eval { $undef->isa('SCALAR') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef with DEFAULT: $undef->isa(...)');

    eval { undef->can('test') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef with DEFAULT: undef->can(...)');

    eval { $undef->can('test') };
    ok (($@ && ($@ =~ /^$undef_error/)), 'undef with DEFAULT: $undef->can(...)');
}

# test undef: but undef support can be enabled
{
    use autobox UNDEF => 'MyDefault';
    is (undef->test(), 'MyDefault', 'handle undef: undef');
    is ($undef->test(), 'MyDefault', 'handle undef: $undef');
}

# verify expected behaviour when autobox isn't enabled (workaround for a %^H bug)
{
    use autobox_scope_1;
    eval { autobox_scope_1::test() };
    ok(($@ && ($@ =~ /^$unblessed_error/)), '[]->test() raises an exception in a required module when autobox is not used');
}

# make sure behaviour is the same when autobox is enabled (workaround for a %^H bug)
{
    use autobox;
    use autobox_scope_2;
    eval { autobox_scope_2::test() };
    ok(($@ && ($@ =~ /^$unblessed_error/)), '[]->test() raises an exception in a required module when autobox is used');
}

# make sure enterscope/leavescope have popped the stack back so that the default op_method_named is restored
(my $isa_error = $error) =~ s/test/isa/;
eval { 3->isa('SCALAR') };
ok(
    ($@ && ($@ =~ /^$isa_error/)),
    "3->isa('SCALAR') raises an exception outside a lexical scope in which autobox is loaded"
);

1;