requires "Dancer2" => "0.208001";
requires "DBD::SQLite" => "1.62";
requires "Crypt::OpenSSL::RSA" => "0.31";
requires "File::Slurper" => "0.012";

recommends "YAML"             => "0";
recommends "URL::Encode::XS"  => "0";
recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};
