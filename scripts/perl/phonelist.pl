#!/usr/bin/perl
    use strict; use warnings;

    my $phone_list = {
        'Phil' => [
            { type => 'home',  number => '555-0001' },
            { type => 'pager', number => '555-1000' },
        ],
        'Frank' => [
            { type => 'cell',  number => '555-9012' },
            { type => 'pager', number => '555-5678' },
            { type => 'home',  number => '555-1234' },
        ],
    };

    my $person = shift or die "usage: $0 person\n";

    foreach my $number (@{$phone_list->{$person}}) {
        print "$number->{type} $number->{number}\n";
    }
