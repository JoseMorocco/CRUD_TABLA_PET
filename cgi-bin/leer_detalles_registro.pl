#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use JSON;
use DBI;

my $cgi = CGI->new;
print $cgi->header('application/json');

my $id = $cgi->param('id');
my %response;

if (defined $id) {
    # Conectar a la base de datos
    my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, PrintError => 0 })
        or die "No se pudo conectar: $DBI::errstr";

    # Consultar detalles del registro
    my $sth = $dbh->prepare("SELECT id, name, owner, species, sex, birth, death FROM pet WHERE id = ?")
        or die "Error al preparar la consulta: $DBI::errstr";

    $sth->execute($id);

    if (my $row = $sth->fetchrow_hashref) {
        %response = (
            status  => 200,
            message => "Datos encontrados",
            data    => $row
        );
    } else {
        %response = (
            status  => 404,
            message => "Registro no encontrado"
        );
    }

    # Desconectar la base de datos
    $dbh->disconnect;
} else {
    %response = (
        status  => 400,
        message => "Solicitud inválida: ID no proporcionado"
    );
}

print encode_json(\%response);
