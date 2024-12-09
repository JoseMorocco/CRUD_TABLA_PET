#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $cgi = CGI->new;
print $cgi->header('application/json');

# Obtener valores del formulario
my $name    = $cgi->param('name');
my $owner   = $cgi->param('owner');
my $species = $cgi->param('species');
my $sex     = $cgi->param('sex');
my $birth   = $cgi->param('birth');
my $death   = $cgi->param('death');

my %response;

if (defined $name && defined $owner && defined $species && defined $sex && defined $birth) {
    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, AutoCommit => 1 })
        or die encode_json({ status => "error", message => "No se pudo conectar: $DBI::errstr" });

    # Capturar posibles errores en la consulta
    eval {
        my $sth = $dbh->prepare("INSERT INTO pet (name, owner, species, sex, birth, death) VALUES (?, ?, ?, ?, ?, ?)");
        $sth->execute($name, $owner, $species, $sex, $birth, $death);
        %response = (status => "success", message => "Registro agregado correctamente");
    };
    if ($@) {
        %response = (status => "error", message => "Error en la base de datos: $@");
    }
    $dbh->disconnect;
} else {
    %response = (status => "error", message => "Faltan datos en el formulario");
}

print encode_json(\%response);
