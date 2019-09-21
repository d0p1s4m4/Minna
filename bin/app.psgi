#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Minna;
use Minna::ActivityPub;

Dancer2->psgi_app(['Minna', 'Minna::ActivityPub']);