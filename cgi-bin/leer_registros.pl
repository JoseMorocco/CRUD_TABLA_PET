#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI;
use JSON;
use utf8;

my $q = CGI->new;

print $q->header('text/html; charset=utf-8');

my $dbh = DBI->connect("DBI:mysql:menagerie", 'pet', '12345678', { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

my $sth = $dbh->prepare("SELECT id, name, owner, species, sex, birth, death FROM pet")
    or die "Error al preparar la consulta: $DBI::errstr";

$sth->execute()
    or die "Error al ejecutar la consulta: $DBI::errstr";

my @pets;
while (my $row = $sth->fetchrow_hashref) {
    push @pets, $row;
}

# Convertir los datos a JSON
my $json_pets = encode_json(\@pets);

print <<'HTML';
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registros de Mascotas</title>
    <script>
        // Cargar datos JSON desde el servidor
        const petsData = JSON.parse('$json_pets');
        console.log('Datos JSON desde la base de datos:', petsData);
    </script>
</head>
<body>
    <h1>Tabla PET</h1>
    <table class="table table-bordered table-striped">
        <tr>
            <th>No.</th>
            <th>Nombre</th>
            <th>Propietario</th>
            <th>Especie</th>
            <th>Sexo</th>
            <th>Fecha de Nacimiento</th>
            <th>Fecha de Fallecimiento</th>
            <th>Acciones</th>
        </tr>
HTML

# IMPRIME LAS FILAS DE LA TABLA
foreach my $pet (@pets) {
    my $name    = CGI::escapeHTML($pet->{name} // '');
    my $owner   = CGI::escapeHTML($pet->{owner} // '');
    my $species = CGI::escapeHTML($pet->{species} // '');
    my $sex     = CGI::escapeHTML($pet->{sex} // '');
    my $birth   = CGI::escapeHTML($pet->{birth} // '');
    my $death   = CGI::escapeHTML($pet->{death} // '');
    my $id      = $pet->{id};
    print qq{
        <tr>
            <td>$id</td>
            <td>$name</td>
            <td>$owner</td>
            <td>$species</td>
            <td>$sex</td>
            <td>$birth</td>
            <td>$death</td>
            <td>
                <button onclick="GetUserDetails('$id')" class="btn btn-warning">Editar</button>
                <button onclick="deleteRecord('$id')" class="btn btn-danger">Borrar</button>
            </td>
        </tr>
    };
}

print <<'HTML';
    </table>
</body>
</html>
HTML

$sth->finish;
$dbh->disconnect;
