#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use JSON;

my $cgi = CGI->new;
print $cgi->header('application/json');

# Obtener valores del formulario
my $id      = $cgi->param('id');
my $name    = $cgi->param('name');
my $owner   = $cgi->param('owner');
my $species = $cgi->param('species');
my $sex     = $cgi->param('sex');
my $birth   = $cgi->param('birth');
my $death   = $cgi->param('death');

# Si death está vacío, asignar NULL
$death = undef if !$death || $death eq '';

# Validar si los campos obligatorios existen
if ($id && $name && $owner && $species && $sex && $birth) {
    my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, AutoCommit => 1 });

    my $sth = $dbh->prepare("INSERT INTO pet (id, name, owner, species, sex, birth, death) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $sth->execute($id, $name, $owner, $species, $sex, $birth, $death);

    $dbh->disconnect;

    print encode_json({ status => "success", message => "Registro agregado correctamente" });
} else {
    print encode_json({ status => "error", message => "Faltan datos en el formulario" });
}
