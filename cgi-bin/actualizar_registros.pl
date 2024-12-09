#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/plain');

# Obtener valores del formulario
my $id      = $cgi->param('id');
my $name    = $cgi->param('name');
my $owner   = $cgi->param('owner');
my $species = $cgi->param('species');
my $sex     = $cgi->param('sex');
my $birth   = $cgi->param('birth');
my $death   = $cgi->param('death');

# Validar que los campos requeridos estén completos
if (defined $id && defined $name && defined $owner && defined $species && defined $sex && defined $birth) {
    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, AutoCommit => 1 })
        or die "No se pudo conectar: $DBI::errstr";

    # Preparar la consulta para actualizar
    my $sth = $dbh->prepare("UPDATE pet SET name = ?, owner = ?, species = ?, sex = ?, birth = ?, death = ? WHERE id = ?")
        or die "Error al preparar la consulta: $DBI::errstr";

    # Ejecutar la consulta con los parámetros
    eval {
        $sth->execute($name, $owner, $species, $sex, $birth, $death, $id);
        print "Registro actualizado correctamente!";
    };
    if ($@) {
        print "Error al actualizar el registro: $@";
    }

    $dbh->disconnect;
} else {
    print "Faltan datos en el formulario!";
}
