#!/bin/env perl

use strict;
use warnings;
use DBI;
use Data::Dumper;

my $ban_schema = <<END_BAN_SCHEMA;

CREATE TABLE IF NOT EXISTS "ban"
(
    Instance NVACHAR(253) NOT NULL UNIQUE,
    Reason TEXT DEFAULT ""
);

END_BAN_SCHEMA

my $following_schema = <<END_FOLLOWING_SCHEMA;

CREATE TABLE IF NOT EXISTS "following"
(
    inbox NVACHAR(253) NOT NULL UNIQUE
);

END_FOLLOWING_SCHEMA

sub connect_to_db {
    my $db = DBI->connect('dbi:SQLite:dbname=db.sqlite') or die $DBI::errstr;
    return $db;
}

sub show_help {
    print "USAGE\n";
    print "init\t\t\tInitialize database\n";
    print "ban <instance> <reason>\tBan instance\n";
    print "unban <instance>\tUnban instance\n";
    print "showban\t\t\tList all banned instances\n";
    exit 0;
}

sub fnc_init {
    print "create database:";
    my $db = connect_to_db;
    print " OK\nCreate ban table: ";
    $db->do($ban_schema) or die $db->errstr;
    print " OK\nCreate following table: ";
    $db->do($following_schema) or die $db->errstr;
    print " OK\n";
}

sub fnc_ban {
    my $instance = $ARGV[0] or show_help;
    my $reason = $ARGV[1];

    my $db = connect_to_db;
    my $query = $db->prepare(
        'insert into ban (instance, reason) values (?, ?)'
    ) or die $db->errstr;

    $query->execute(
        $instance, $reason
    ) or die $query->errstr;
}

sub fnc_unban {
    my $instance = $ARGV[0] or show_help;

    my $db = connect_to_db;
    my $query = $db->prepare(
        'delete from ban where instance = ?'
    ) or die $db->errstr;

    $query->execute(
        $instance
    ) or die $query->errstr;
}

sub fnc_showban {
    my $db = connect_to_db;
    my $query = $db->prepare(
        'select * from ban order by instance desc'
    ) or die $db->errstr;
    $query->execute() or die $query->errstr;
    my $arrayref = $query->fetchall_arrayref();
    map {
        print "@{ $_ }[0] : @{ $_ }[1]\n";
    } @{ $arrayref };
}

my %actions = (
    init => \&fnc_init,
    ban => \&fnc_ban,
    unban => \&fnc_unban,
    showban => \&fnc_showban
);

my $action = shift or show_help;

$actions{$action}->();
