#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/plain');

# Obtener el ID del registro a eliminar
my $id = $cgi->param('id');

if (defined $id) {
    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, PrintError => 0 })
        or die "No se pudo conectar: $DBI::errstr";

    # Preparar y ejecutar la consulta para eliminar
    my $sth = $dbh->prepare("DELETE FROM pet WHERE id = ?")
        or die "Error al preparar la consulta: $DBI::errstr";

    eval {
        $sth->execute($id);
        print "Registro eliminado correctamente!";
    };
    if ($@) {
        print "Error al eliminar el registro: $@";
    }

    # Desconectar la base de datos
    $dbh->disconnect;
} else {
    print "ID no proporcionado!";
}
